import 'package:dio/dio.dart';
import '../models/product_model.dart';

abstract class ProductRemoteDataSource {
  Future<List<ProductModel>> getProducts({int skip = 0, int limit = 10});
}

class ProductRemoteDataSourceImpl implements ProductRemoteDataSource {
  final Dio dio;

  ProductRemoteDataSourceImpl(this.dio);

  @override
  Future<List<ProductModel>> getProducts({int skip = 0, int limit = 10}) async {
    try {
      final response = await dio.get(
        'https://dummyjson.com/products',
        queryParameters: {
          'skip': skip,
          'limit': limit,
        },
      );
      
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['products'];
        return data.map((json) => ProductModel.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load products');
      }
    } catch (e) {
      throw Exception('Error fetching products: $e');
    }
  }
}
