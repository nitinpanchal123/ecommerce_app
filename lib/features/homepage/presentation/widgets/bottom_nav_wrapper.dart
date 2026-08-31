import 'package:ecommerce_project/core/theme/app_colors.dart';
import 'package:ecommerce_project/core/theme/app_spacing.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class BottomNavWrapper extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const BottomNavWrapper({
    super.key,
    required this.navigationShell,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          border: Border(
            top: BorderSide(
              color: AppColors.border,
              width: 1,
            ),
          ),
        ),
        child: BottomNavigationBar(
          currentIndex: navigationShell.currentIndex,
          onTap: (index) => navigationShell.goBranch(index),
          type: BottomNavigationBarType.fixed,
          backgroundColor: Theme.of(context).cardColor,
          selectedItemColor: AppColors.primary,
          unselectedItemColor: AppColors.textGrey,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          elevation: 0,
          items: [
            const BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home, color: AppColors.primary),
              label: 'Home',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.search),
              label: 'Search',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.favorite_border),
              activeIcon: Icon(Icons.favorite, color: AppColors.error),
              label: 'Favorites',
            ),
          ],
        ),
      ),
    );
  }
}
