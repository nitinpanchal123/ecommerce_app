import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../features/auth/presentation/providers/auth_provider.dart';

class ThemeNotifier extends Notifier<ThemeMode> {
  static const _themeKey = 'theme_mode';

  @override
  ThemeMode build() {
    final prefs = ref.watch(sharedPreferencesProvider);
    final savedTheme = prefs.getString(_themeKey);
    
    if (savedTheme == 'dark') return ThemeMode.dark;
    if (savedTheme == 'light') return ThemeMode.light;
    return ThemeMode.light; // Default to light mode as requested
  }

  void toggleTheme() {
    final prefs = ref.read(sharedPreferencesProvider);
    if (state == ThemeMode.dark) {
      state = ThemeMode.light;
      prefs.setString(_themeKey, 'light');
    } else {
      state = ThemeMode.dark;
      prefs.setString(_themeKey, 'dark');
    }
  }
}

final themeModeProvider = NotifierProvider<ThemeNotifier, ThemeMode>(() {
  return ThemeNotifier();
});
