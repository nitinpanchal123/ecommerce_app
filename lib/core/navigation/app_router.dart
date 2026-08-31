import 'package:ecommerce_project/features/auth/presentation/pages/login_page.dart';
import 'package:ecommerce_project/features/homepage/presentation/pages/home_page.dart';
import 'package:ecommerce_project/features/homepage/presentation/widgets/bottom_nav_wrapper.dart';
import 'package:ecommerce_project/features/product/domain/entities/product.dart';
import 'package:ecommerce_project/features/product/presentation/pages/product_detail_page.dart';
import 'package:ecommerce_project/features/product/presentation/pages/wishlist_page.dart';
import 'package:ecommerce_project/features/product/presentation/pages/search_page.dart';
import 'package:ecommerce_project/features/splash/presentation/pages/splash_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();

final appRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const SplashPage(),
    ),
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginPage(),
    ),
    GoRoute(
      path: '/product-detail',
      builder: (context, state) {
        final product = state.extra as Product;
        return ProductDetailPage(product: product);
      },
    ),
    GoRoute(
      path: '/search',
      builder: (context, state) => const SearchPage(),
    ),
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return BottomNavWrapper(navigationShell: navigationShell);
      },
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/home',
              builder: (context, state) => const HomePage(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/search-tab',
              builder: (context, state) => const SearchPage(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/favorites',
              builder: (context, state) => const WishlistPage(),
            ),
          ],
        ),
      ],
    ),
  ],
);
