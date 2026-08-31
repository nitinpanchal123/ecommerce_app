import 'package:ecommerce_project/core/theme/app_colors.dart';
import 'package:ecommerce_project/core/theme/app_fonts.dart';
import 'package:ecommerce_project/core/theme/app_spacing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/product_provider.dart';
import '../../domain/entities/product.dart';

class SearchPage extends ConsumerStatefulWidget {
  const SearchPage({super.key});

  @override
  ConsumerState<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends ConsumerState<SearchPage> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final searchResultsAsync = ref.watch(localSearchProvider);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.m, vertical: AppSpacing.xs),
              child: Row(
                children: [
                  if (Navigator.of(context).canPop())
                    IconButton(
                      icon: const Icon(Icons.arrow_back),
                      onPressed: () => context.pop(),
                    ),
                  const SizedBox(width: AppSpacing.xs),
                  const Text(
                    'Search',
                    style: TextStyle(
                      fontSize: AppFonts.sizeTitleSmall,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl, vertical: AppSpacing.xs),
              child: Container(
                height: 56,
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(AppSpacing.m),
                  border: Border.all(color: AppColors.primary, width: 1.5),
                ),
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.m),
                child: Row(
                  children: [
                    const Icon(Icons.search, color: AppColors.primary),
                    const SizedBox(width: AppSpacing.s),
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        autofocus: true,
                        onChanged: (value) {
                          ref.read(searchQueryProvider.notifier).state = value;
                        },
                        decoration: const InputDecoration(
                          hintText: 'headphones',
                          hintStyle: TextStyle(color: AppColors.textGrey),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    if (_searchController.text.isNotEmpty)
                      IconButton(
                        icon: const Icon(Icons.cancel, color: AppColors.textGrey),
                        onPressed: () {
                          _searchController.clear();
                          ref.read(searchQueryProvider.notifier).state = '';
                        },
                      ),
                  ],
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl, vertical: AppSpacing.m),
              child: Text(
                '${searchResultsAsync.value?.length ?? 0} results',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            Expanded(
              child: searchResultsAsync.when(
                data: (products) => ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    return _SearchProductCard(product: products[index]);
                  },
                ),
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (err, stack) => Center(child: Text('Error: $err')),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SearchProductCard extends StatelessWidget {
  final Product product;

  const _SearchProductCard({required this.product});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push('/product-detail', extra: product),
      child: Container(
        margin: const EdgeInsets.only(bottom: AppSpacing.m),
        padding: const EdgeInsets.all(AppSpacing.s),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(AppSpacing.l),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppColors.cardBgLightPurple,
                borderRadius: BorderRadius.circular(AppSpacing.m),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(AppSpacing.m),
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
                      child: Icon(Icons.broken_image_outlined, size: 30, color: AppColors.textGrey),
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
                  ),
                  const SizedBox(height: AppSpacing.xxs),
                  Text(
                    product.category.toUpperCase(),
                    style: const TextStyle(
                      color: AppColors.textGrey,
                      fontSize: AppFonts.sizeExtraSmall,
                      fontWeight: FontWeight.w500,
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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
