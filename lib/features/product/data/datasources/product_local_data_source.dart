import 'dart:convert';
import 'package:sqflite/sqflite.dart';
import '../models/product_model.dart';

abstract class ProductLocalDataSource {
  Future<void> cacheProducts(List<ProductModel> products);
  Future<List<ProductModel>> getCachedProducts();
  Future<List<ProductModel>> searchProducts(String query);
  Future<void> toggleFavorite(int productId, bool isFavorite);
  Future<List<ProductModel>> getWishlistProducts();
}

class ProductLocalDataSourceImpl implements ProductLocalDataSource {
  final Database database;

  ProductLocalDataSourceImpl(this.database);

  @override
  Future<void> cacheProducts(List<ProductModel> products) async {
    final batch = database.batch();
    
    for (var product in products) {
      // Use INSERT OR IGNORE or handle conflicts to avoid overwriting isFavorite
      // For simplicity, we check if it exists and keep isFavorite value
      final existing = await database.query('products', where: 'id = ?', whereArgs: [product.id]);
      
      final Map<String, dynamic> values = {
        'id': product.id,
        'title': product.title,
        'description': product.description,
        'category': product.category,
        'price': product.price,
        'discountPercentage': product.discountPercentage,
        'rating': product.rating,
        'stock': product.stock,
        'tags': jsonEncode(product.tags),
        'brand': product.brand,
        'sku': product.sku,
        'weight': product.weight,
        'dimensions_width': product.dimensions.width,
        'dimensions_height': product.dimensions.height,
        'dimensions_depth': product.dimensions.depth,
        'warrantyInformation': product.warrantyInformation,
        'shippingInformation': product.shippingInformation,
        'availabilityStatus': product.availabilityStatus,
        'returnPolicy': product.returnPolicy,
        'minimumOrderQuantity': product.minimumOrderQuantity,
        'meta_createdAt': product.meta.createdAt.toIso8601String(),
        'meta_updatedAt': product.meta.updatedAt.toIso8601String(),
        'meta_barcode': product.meta.barcode,
        'meta_qrCode': product.meta.qrCode,
        'images': jsonEncode(product.images),
        'thumbnail': product.thumbnail,
      };

      if (existing.isEmpty) {
        values['isFavorite'] = 0;
        batch.insert('products', values);
      } else {
        batch.update('products', values, where: 'id = ?', whereArgs: [product.id]);
      }
    }
    
    await batch.commit(noResult: true);
  }

  @override
  Future<List<ProductModel>> getCachedProducts() async {
    final List<Map<String, dynamic>> maps = await database.query('products');
    return maps.map((map) => _mapToProductModel(map)).toList();
  }

  @override
  Future<List<ProductModel>> searchProducts(String query) async {
    final List<Map<String, dynamic>> maps = await database.query(
      'products',
      where: 'title LIKE ?',
      whereArgs: ['%$query%'],
    );
    return maps.map((map) => _mapToProductModel(map)).toList();
  }

  @override
  Future<void> toggleFavorite(int productId, bool isFavorite) async {
    await database.update(
      'products',
      {'isFavorite': isFavorite ? 1 : 0},
      where: 'id = ?',
      whereArgs: [productId],
    );
  }

  @override
  Future<List<ProductModel>> getWishlistProducts() async {
    final List<Map<String, dynamic>> maps = await database.query(
      'products',
      where: 'isFavorite = 1',
    );
    return maps.map((map) => _mapToProductModel(map)).toList();
  }

  ProductModel _mapToProductModel(Map<String, dynamic> map) {
    return ProductModel.fromJson({
      'id': map['id'],
      'title': map['title'],
      'description': map['description'],
      'category': map['category'],
      'price': map['price'],
      'discountPercentage': map['discountPercentage'],
      'rating': map['rating'],
      'stock': map['stock'],
      'tags': jsonDecode(map['tags']),
      'brand': map['brand'],
      'sku': map['sku'],
      'weight': map['weight'],
      'dimensions': {
        'width': map['dimensions_width'],
        'height': map['dimensions_height'],
        'depth': map['dimensions_depth'],
      },
      'warrantyInformation': map['warrantyInformation'],
      'shippingInformation': map['shippingInformation'],
      'availabilityStatus': map['availabilityStatus'],
      'reviews': [],
      'returnPolicy': map['returnPolicy'],
      'minimumOrderQuantity': map['minimumOrderQuantity'],
      'meta': {
        'createdAt': map['meta_createdAt'],
        'updatedAt': map['meta_updatedAt'],
        'barcode': map['meta_barcode'],
        'qrCode': map['meta_qrCode'],
      },
      'images': jsonDecode(map['images']),
      'thumbnail': map['thumbnail'],
      'isFavorite': map['isFavorite'] == 1,
    });
  }
}
