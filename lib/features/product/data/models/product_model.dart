import '../../domain/entities/product.dart';

class ProductModel extends Product {
  const ProductModel({
    required super.id,
    required super.title,
    required super.description,
    required super.category,
    required super.price,
    required super.discountPercentage,
    required super.rating,
    required super.stock,
    required super.tags,
    super.brand,
    required super.sku,
    required super.weight,
    required super.dimensions,
    required super.warrantyInformation,
    required super.shippingInformation,
    required super.availabilityStatus,
    required super.reviews,
    required super.returnPolicy,
    required super.minimumOrderQuantity,
    required super.meta,
    required super.images,
    required super.thumbnail,
    super.isFavorite,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      category: json['category'],
      price: (json['price'] as num).toDouble(),
      discountPercentage: (json['discountPercentage'] as num).toDouble(),
      rating: (json['rating'] as num).toDouble(),
      stock: json['stock'],
      tags: List<String>.from(json['tags']),
      brand: json['brand'],
      sku: json['sku'],
      weight: (json['weight'] as num).toDouble(),
      dimensions: DimensionsModel.fromJson(json['dimensions']),
      warrantyInformation: json['warrantyInformation'],
      shippingInformation: json['shippingInformation'],
      availabilityStatus: json['availabilityStatus'],
      reviews: (json['reviews'] as List)
          .map((e) => ReviewModel.fromJson(e))
          .toList(),
      returnPolicy: json['returnPolicy'],
      minimumOrderQuantity: json['minimumOrderQuantity'],
      meta: MetaModel.fromJson(json['meta']),
      images: List<String>.from(json['images']),
      thumbnail: json['thumbnail'],
      isFavorite: false,
    );
  }
}

class DimensionsModel extends Dimensions {
  const DimensionsModel({
    required super.width,
    required super.height,
    required super.depth,
  });

  factory DimensionsModel.fromJson(Map<String, dynamic> json) {
    return DimensionsModel(
      width: (json['width'] as num).toDouble(),
      height: (json['height'] as num).toDouble(),
      depth: (json['depth'] as num).toDouble(),
    );
  }
}

class ReviewModel extends Review {
  const ReviewModel({
    required super.rating,
    required super.comment,
    required super.date,
    required super.reviewerName,
    required super.reviewerEmail,
  });

  factory ReviewModel.fromJson(Map<String, dynamic> json) {
    return ReviewModel(
      rating: json['rating'],
      comment: json['comment'],
      date: DateTime.parse(json['date']),
      reviewerName: json['reviewerName'],
      reviewerEmail: json['reviewerEmail'],
    );
  }
}

class MetaModel extends Meta {
  const MetaModel({
    required super.createdAt,
    required super.updatedAt,
    required super.barcode,
    required super.qrCode,
  });

  factory MetaModel.fromJson(Map<String, dynamic> json) {
    return MetaModel(
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      barcode: json['barcode'],
      qrCode: json['qrCode'],
    );
  }
}
