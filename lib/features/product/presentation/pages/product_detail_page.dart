import 'package:ecommerce_project/core/theme/app_colors.dart';
import 'package:ecommerce_project/core/theme/app_fonts.dart';
import 'package:ecommerce_project/core/theme/app_spacing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/product_provider.dart';
import '../../domain/entities/product.dart';

class ProductDetailPage extends ConsumerWidget {
  final Product product;

  const ProductDetailPage({super.key, required this.product});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch for state changes to update the UI if favorited/unfavorited
    // Using a typed list explicitly to avoid inference issues
    final List<Product> products = ref.watch(productPaginationProvider).products;
    
    final currentProduct = products.firstWhere(
      (p) => p.id == product.id,
      orElse: () => product,
    );

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Hero(
                  tag: 'product-image-${product.id}',
                  child: Container(
                    height: 400,
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      color: AppColors.cardBgLightPurple,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(AppSpacing.xxl),
                        bottomRight: Radius.circular(AppSpacing.xxl),
                      ),
                    ),
                    child: Center(
                      child: Image.network(
                        product.thumbnail,
                        fit: BoxFit.contain,
                        height: 250,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return const Center(child: CircularProgressIndicator());
                        },
                        errorBuilder: (context, error, stackTrace) => const Center(
                          child: Icon(Icons.broken_image_outlined, size: 80, color: AppColors.textGrey),
                        ),
                      ),
                    ),
                  ),
                ),
                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.m, vertical: AppSpacing.xs),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CircleAvatar(
                          backgroundColor: Theme.of(context).cardColor,
                          child: IconButton(
                            icon: const Icon(Icons.arrow_back),
                            onPressed: () => context.pop(),
                          ),
                        ),
                        CircleAvatar(
                          backgroundColor: Theme.of(context).cardColor,
                          child: IconButton(
                            icon: Icon(
                              currentProduct.isFavorite ? Icons.favorite : Icons.favorite_border,
                              color: currentProduct.isFavorite ? AppColors.error : null,
                            ),
                            onPressed: () {
                              ref.read(productPaginationProvider.notifier).toggleFavorite(currentProduct);
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            
            Padding(
              padding: const EdgeInsets.all(AppSpacing.xl),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        currentProduct.category.toUpperCase(),
                        style: const TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.2,
                        ),
                      ),
                      Text(
                        '\$${currentProduct.price.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: AppFonts.sizeTitleMedium,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    currentProduct.title,
                    style: const TextStyle(
                      fontSize: AppFonts.sizeTitleLarge,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.s),
                  Row(
                    children: [
                      const Icon(Icons.star, color: AppColors.star, size: 20),
                      const SizedBox(width: AppSpacing.xxs),
                      Text(
                        currentProduct.rating.toString(),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: AppFonts.sizeMedium,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  Text(
                    currentProduct.description,
                    style: const TextStyle(
                      fontSize: AppFonts.sizeMedium,
                      color: AppColors.textGrey,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xxxl),
                  SizedBox(
                    width: double.infinity,
                    height: 64,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppSpacing.l),
                        ),
                      ),
                      child: const Text(
                        'Add to cart',
                        style: TextStyle(
                          color: AppColors.white,
                          fontSize: AppFonts.sizeLarge,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
