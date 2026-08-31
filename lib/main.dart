import 'package:ecommerce_project/core/navigation/app_router.dart';
import 'package:ecommerce_project/core/theme/app_theme.dart';
import 'package:ecommerce_project/core/theme/theme_provider.dart';
import 'package:ecommerce_project/features/auth/presentation/providers/auth_provider.dart';
import 'package:ecommerce_project/features/product/presentation/providers/product_provider.dart';
import 'package:ecommerce_project/core/database/database_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  final prefs = await SharedPreferences.getInstance();
  final database = await DatabaseHelper().database;
  
  runApp(
    ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(prefs),
        databaseProvider.overrideWithValue(database),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);

    return MaterialApp.router(
      title: 'Ecommerce App',
      debugShowCheckedModeBanner: false,
      routerConfig: appRouter,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode,
    );
  }
}
