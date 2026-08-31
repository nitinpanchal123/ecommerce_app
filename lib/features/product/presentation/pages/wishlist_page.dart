import 'package:ecommerce_project/core/theme/app_colors.dart';
import 'package:ecommerce_project/core/theme/app_fonts.dart';
import 'package:ecommerce_project/core/theme/app_spacing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/product_provider.dart';
import '../../domain/entities/product.dart';

class WishlistPage extends ConsumerWidget {
  const WishlistPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final wishlistAsync = ref.watch(wishlistProvider);

    return wishlistAsync.when(
      data: (products) {
        final isEmpty = products.isEmpty;
        
        return Scaffold(
          backgroundColor: isEmpty ? AppColors.black : null,
          body: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(AppSpacing.xl, AppSpacing.l, AppSpacing.xl, AppSpacing.xl),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Saved for later',
                            style: TextStyle(
                              fontSize: AppFonts.sizeMedium,
                              color: AppColors.textGrey,
                            ),
                          ),
                          const SizedBox(height: AppSpacing.xxs),
                          Text(
                            'Wishlist',
                            style: TextStyle(
                              fontSize: AppFonts.sizeTitleLarge,
                              fontWeight: FontWeight.bold,
                              color: isEmpty ? AppColors.white : null,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.all(AppSpacing.s),
                        decoration: BoxDecoration(
                          color: isEmpty ? AppColors.textDark : AppColors.wishlistBg,
                          borderRadius: BorderRadius.circular(AppSpacing.m),
                        ),
                        child: Icon(
                          Icons.favorite, 
                          color: isEmpty ? AppColors.white : AppColors.error,
                        ),
                      ),
                    ],
                  ),
                ),

                Expanded(
                  child: isEmpty 
                    ? const _EmptyWishlistContent() 
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
                        itemCount: products.length,
                        itemBuilder: (context, index) {
                          return _WishlistProductCard(product: products[index]);
                        },
                      ),
                ),
              ],
            ),
          ),
        );
      },
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (err, stack) => Scaffold(
        body: Center(child: Text('Error: $err')),
      ),
    );
  }
}

class _EmptyWishlistContent extends StatelessWidget {
  const _EmptyWishlistContent();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xxxl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 140,
              height: 140,
              decoration: BoxDecoration(
                color: AppColors.primaryLight,
                borderRadius: BorderRadius.circular(AppSpacing.xxxl),
              ),
              child: Center(
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(AppSpacing.xl),
                  ),
                  child: const Icon(
                    Icons.favorite_outline,
                    color: AppColors.primary,
                    size: 40,
                  ),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.xxxl),
            const Text(
              'Your wishlist is empty',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: AppFonts.sizeTitleSmall,
                fontWeight: FontWeight.bold,
                color: AppColors.white,
              ),
            ),
            const SizedBox(height: AppSpacing.m),
            const Text(
              'Save products you love and find them quickly whenever you’re ready to shop.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: AppFonts.sizeMedium,
                color: AppColors.textGrey,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }
}

class _WishlistProductCard extends ConsumerWidget {
  final Product product;

  const _WishlistProductCard({required this.product});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () => context.push('/product-detail', extra: product),
      child: Container(
        margin: const EdgeInsets.only(bottom: AppSpacing.m),
        padding: const EdgeInsets.all(AppSpacing.m),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(AppSpacing.xl),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: AppColors.cardBgLightPurple,
                borderRadius: BorderRadius.circular(AppSpacing.l),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(AppSpacing.l),
                child: Hero(
                  tag: 'product-image-${product.id}',
                  child: Image.network(
                    product.thumbnail,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return const Center(child: CircularProgressIndicator());
                    },
                    errorBuilder: (context, error, stackTrace) => const Center(
                      child: Icon(Icons.broken_image_outlined, size: 40, color: AppColors.textGrey),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.m),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: AppFonts.sizeLarge,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: AppSpacing.xxs),
                  Text(
                    '${product.brand ?? 'Generic'} • ${product.category}',
                    style: const TextStyle(
                      color: AppColors.textGrey,
                      fontSize: AppFonts.sizeSmall,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    '\$${product.price.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: AppFonts.sizeExtraLarge,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.s),
                  SizedBox(
                    height: 36,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.black,
                        foregroundColor: AppColors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.m),
                      ),
                      child: const Text('Add to cart', style: TextStyle(fontSize: AppFonts.sizeExtraSmall, fontWeight: FontWeight.bold)),
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
