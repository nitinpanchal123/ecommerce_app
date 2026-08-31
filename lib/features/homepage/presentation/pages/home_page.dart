import 'package:ecommerce_project/core/presentation/widgets/no_internet_widget.dart';
import 'package:ecommerce_project/core/theme/app_colors.dart';
import 'package:ecommerce_project/core/theme/app_fonts.dart';
import 'package:ecommerce_project/core/theme/app_spacing.dart';
import 'package:ecommerce_project/features/product/presentation/providers/product_provider.dart';
import 'package:ecommerce_project/features/product/presentation/widgets/product_grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/theme_provider.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(productPaginationProvider.notifier).loadProducts();
    });
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      ref.read(productPaginationProvider.notifier).loadProducts();
    }
  }

  @override
  Widget build(BuildContext context) {
    final paginationState = ref.watch(productPaginationProvider);

    ref.listen(productPaginationProvider, (previous, next) {
      if (next.message != null && next.message != previous?.message) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.message!),
            duration: const Duration(seconds: 1),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    });

    if (paginationState.showNoInternetScreen) {
      return NoInternetWidget(
        onRetry: () => ref.read(productPaginationProvider.notifier).manualRetry(),
      );
    }

    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () => ref.read(productPaginationProvider.notifier).refreshProducts(),
          child: CustomScrollView(
            controller: _scrollController,
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(AppSpacing.xl, AppSpacing.l, AppSpacing.xl, AppSpacing.xl),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Hi',
                            style: TextStyle(
                              fontSize: AppFonts.sizeMedium,
                              color: AppColors.textGrey,
                            ),
                          ),
                          const SizedBox(height: AppSpacing.xxs),
                          const Text(
                            'Discover',
                            style: TextStyle(
                              fontSize: AppFonts.sizeTitleLarge,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      GestureDetector(
                        onTap: () {
                          ref.read(themeModeProvider.notifier).toggleTheme();
                        },
                        child: Container(
                          padding: const EdgeInsets.all(AppSpacing.s),
                          decoration: BoxDecoration(
                            color: Theme.of(context).cardColor,
                            borderRadius: BorderRadius.circular(AppSpacing.m),
                            border: Border.all(color: AppColors.border),
                          ),
                          child: Icon(
                            ref.watch(themeModeProvider) == ThemeMode.dark
                                ? Icons.light_mode_outlined
                                : Icons.dark_mode_outlined,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
                  child: GestureDetector(
                    onTap: () => context.push('/search'),
                    child: Container(
                      height: 56,
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(AppSpacing.m),
                        border: Border.all(color: AppColors.border),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.m),
                      child: const Row(
                        children: [
                          Icon(Icons.search, color: AppColors.textGrey),
                          SizedBox(width: AppSpacing.s),
                          Text(
                            'Search products',
                            style: TextStyle(color: AppColors.textGrey, fontSize: AppFonts.sizeMedium),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.xl)),

              const ProductGrid(),

              if (paginationState.isLoading && paginationState.products.isNotEmpty)
                const SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    child: Center(child: CircularProgressIndicator()),
                  ),
                ),
              
              const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.xl)),
            ],
          ),
        ),
      ),
    );
  }
}
