import '../../domain/entities/product.dart';
import '../../domain/repositories/product_repository.dart';
import '../datasources/product_remote_data_source.dart';
import '../datasources/product_local_data_source.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ProductRemoteDataSource remoteDataSource;
  final ProductLocalDataSource localDataSource;

  ProductRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<List<Product>> getProducts({int skip = 0, int limit = 10}) async {
    try {
      return await getRemoteProducts(skip: skip, limit: limit);
    } catch (e) {
      final localProducts = await getLocalProducts();
      if (localProducts.isNotEmpty) {
        return localProducts;
      } else {
        rethrow;
      }
    }
  }

  @override
  Future<List<Product>> getRemoteProducts({int skip = 0, int limit = 10}) async {
    final remoteProducts = await remoteDataSource.getProducts(skip: skip, limit: limit);
    if (skip == 0) {
      await localDataSource.cacheProducts(remoteProducts);
    }
    return remoteProducts;
  }

  @override
  Future<List<Product>> getLocalProducts() async {
    return await localDataSource.getCachedProducts();
  }

  @override
  Future<List<Product>> searchLocalProducts(String query) async {
    return await localDataSource.searchProducts(query);
  }

  @override
  Future<void> toggleFavorite(int productId, bool isFavorite) async {
    await localDataSource.toggleFavorite(productId, isFavorite);
  }

  @override
  Future<List<Product>> getWishlistProducts() async {
    return await localDataSource.getWishlistProducts();
  }
}
