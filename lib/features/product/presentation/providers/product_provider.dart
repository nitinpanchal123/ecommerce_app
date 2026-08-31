import 'package:dio/dio.dart';
import 'package:dio_smart_retry/dio_smart_retry.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:sqflite/sqflite.dart';
import '../../data/datasources/product_remote_data_source.dart';
import '../../data/datasources/product_local_data_source.dart';
import '../../data/repositories/product_repository_impl.dart';
import '../../domain/entities/product.dart';
import '../../domain/repositories/product_repository.dart';

final dioProvider = Provider<Dio>((ref) {
  final dio = Dio(
    BaseOptions(
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      sendTimeout: const Duration(seconds: 10),
    ),
  );

  dio.interceptors.add(
    RetryInterceptor(
      dio: dio,
      logPrint: print,
      retries: 0, 
    ),
  );

  return dio;
});

final databaseProvider = Provider<Database>((ref) {
  throw UnimplementedError();
});

final productRemoteDataSourceProvider = Provider<ProductRemoteDataSource>((ref) {
  return ProductRemoteDataSourceImpl(ref.watch(dioProvider));
});

final productLocalDataSourceProvider = Provider<ProductLocalDataSource>((ref) {
  return ProductLocalDataSourceImpl(ref.watch(databaseProvider));
});

final productRepositoryProvider = Provider<ProductRepository>((ref) {
  return ProductRepositoryImpl(
    remoteDataSource: ref.watch(productRemoteDataSourceProvider),
    localDataSource: ref.watch(productLocalDataSourceProvider),
  );
});

class ProductPaginationState {
  final List<Product> products;
  final bool isLoading;
  final bool hasMore;
  final int skip;
  final String? error;
  final String? message; 
  final bool showNoInternetScreen;

  ProductPaginationState({
    required this.products,
    required this.isLoading,
    required this.hasMore,
    required this.skip,
    this.error,
    this.message,
    this.showNoInternetScreen = false,
  });

  ProductPaginationState copyWith({
    List<Product>? products,
    bool? isLoading,
    bool? hasMore,
    int? skip,
    String? error,
    String? message,
    bool? showNoInternetScreen,
  }) {
    return ProductPaginationState(
      products: products ?? this.products,
      isLoading: isLoading ?? this.isLoading,
      hasMore: hasMore ?? this.hasMore,
      skip: skip ?? this.skip,
      error: error,
      message: message,
      showNoInternetScreen: showNoInternetScreen ?? this.showNoInternetScreen,
    );
  }
}

class ProductNotifier extends Notifier<ProductPaginationState> {
  @override
  ProductPaginationState build() {
    return ProductPaginationState(
      products: [],
      isLoading: false,
      hasMore: true,
      skip: 0,
    );
  }

  static const int limit = 10;

  Future<void> refreshProducts() async {
    state = ProductPaginationState(
      products: [],
      isLoading: false,
      hasMore: true,
      skip: 0,
    );
    await loadProducts();
  }

  Future<void> loadProducts() async {
    if (state.isLoading || !state.hasMore) return;

    state = state.copyWith(isLoading: true, error: null);

    try {
      final repository = ref.read(productRepositoryProvider);
      final newProducts = await repository.getRemoteProducts(
        skip: state.skip,
        limit: limit,
      );

      state = state.copyWith(
        products: List<Product>.from([...state.products, ...newProducts]),
        isLoading: false,
        hasMore: newProducts.length == limit,
        skip: state.skip + limit,
        error: null,
        showNoInternetScreen: false,
      );
    } catch (e) {
      if (state.products.isEmpty) {
        state = state.copyWith(
          isLoading: false, 
          error: e.toString(),
          showNoInternetScreen: true,
        );
      } else {
        state = state.copyWith(isLoading: false);
      }
    }
  }

  Future<void> manualRetry() async {
    final repository = ref.read(productRepositoryProvider);
    state = state.copyWith(isLoading: true, error: null, message: null);

    for (int i = 1; i <= 3; i++) {
      state = state.copyWith(message: 'Retry attempt $i/3...');
      try {
        final remoteProducts = await repository.getRemoteProducts(skip: 0, limit: limit);
        state = state.copyWith(
          products: List<Product>.from(remoteProducts),
          isLoading: false,
          hasMore: remoteProducts.length == limit,
          skip: limit,
          error: null,
          message: 'Connected! Loading products...',
          showNoInternetScreen: false,
        );
        return;
      } catch (e) {
        if (i == 3) {
          state = state.copyWith(message: 'Retries failed. Showing offline data.');
          final localProducts = await repository.getLocalProducts();
          state = state.copyWith(
            products: List<Product>.from(localProducts),
            isLoading: false,
            hasMore: false,
            skip: localProducts.length,
            error: null,
            showNoInternetScreen: false, 
          );
        } else {
          await Future.delayed(const Duration(seconds: 2));
        }
      }
    }
  }

  Future<void> toggleFavorite(Product product) async {
    final repository = ref.read(productRepositoryProvider);
    final newFavoriteStatus = !product.isFavorite;
    
    await repository.toggleFavorite(product.id, newFavoriteStatus);
    
    state = state.copyWith(
      products: state.products.map((p) {
        if (p.id == product.id) {
          return _updateProductFavorite(p, newFavoriteStatus);
        }
        return p;
      }).toList(),
    );
    
    ref.invalidate(localSearchProvider);
    ref.invalidate(wishlistProvider);
  }

  Product _updateProductFavorite(Product p, bool isFavorite) {
    return Product(
      id: p.id,
      title: p.title,
      description: p.description,
      category: p.category,
      price: p.price,
      discountPercentage: p.discountPercentage,
      rating: p.rating,
      stock: p.stock,
      tags: p.tags,
      brand: p.brand,
      sku: p.sku,
      weight: p.weight,
      dimensions: p.dimensions,
      warrantyInformation: p.warrantyInformation,
      shippingInformation: p.shippingInformation,
      availabilityStatus: p.availabilityStatus,
      reviews: p.reviews,
      returnPolicy: p.returnPolicy,
      minimumOrderQuantity: p.minimumOrderQuantity,
      meta: p.meta,
      images: p.images,
      thumbnail: p.thumbnail,
      isFavorite: isFavorite,
    );
  }
}

final productPaginationProvider =
    NotifierProvider<ProductNotifier, ProductPaginationState>(() {
  return ProductNotifier();
});

final productsProvider = FutureProvider<List<Product>>((ref) async {
  final state = ref.watch(productPaginationProvider);
  return state.products;
});

final searchQueryProvider = StateProvider<String>((ref) => '');

final localSearchProvider = FutureProvider<List<Product>>((ref) async {
  final query = ref.watch(searchQueryProvider);
  if (query.isEmpty) return [];
  
  final repository = ref.read(productRepositoryProvider);
  final products = await repository.searchLocalProducts(query);
  return List<Product>.from(products);
});

final wishlistProvider = FutureProvider<List<Product>>((ref) async {
  final repository = ref.watch(productRepositoryProvider);
  final products = await repository.getWishlistProducts();
  return List<Product>.from(products);
});
