import 'package:ecommerce_project/core/theme/app_spacing.dart';
import 'package:ecommerce_project/features/product/presentation/providers/product_provider.dart';
import 'package:ecommerce_project/features/product/presentation/widgets/product_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProductGrid extends ConsumerWidget {
  const ProductGrid({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final paginationState = ref.watch(productPaginationProvider);
    final products = paginationState.products;

    if (products.isEmpty && paginationState.isLoading) {
      return const SliverFillRemaining(
        child: Center(child: CircularProgressIndicator()),
      );
    }

    if (products.isEmpty && !paginationState.isLoading) {
      return const SliverFillRemaining(
        child: Center(child: Text('No products found')),
      );
    }

    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
      sliver: SliverGrid(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: AppSpacing.m,
          crossAxisSpacing: AppSpacing.m,
          childAspectRatio: 0.7,
        ),
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            final product = products[index];
            return ProductCard(product: product);
          },
          childCount: products.length,
        ),
      ),
    );
  }
}
