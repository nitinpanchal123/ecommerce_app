import '../entities/product.dart';

abstract class ProductRepository {
  Future<List<Product>> getProducts({int skip = 0, int limit = 10});
  Future<List<Product>> getRemoteProducts({int skip = 0, int limit = 10});
  Future<List<Product>> getLocalProducts();
  Future<List<Product>> searchLocalProducts(String query);
  Future<void> toggleFavorite(int productId, bool isFavorite);
  Future<List<Product>> getWishlistProducts();
}
