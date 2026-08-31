import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Provider for SharedPreferences - will be overridden in main.dart
final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError();
});

final authStateProvider = StateProvider<bool>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return prefs.getBool('isLoggedIn') ?? false;
});

class AuthNotifier extends StateNotifier<AsyncValue<void>> {
  final Ref ref;
  AuthNotifier(this.ref) : super(const AsyncValue.data(null));

  Future<void> login(String email, String password) async {
    state = const AsyncValue.loading();
    
    // Dummy validation
    if (email.isEmpty || !email.contains('@')) {
      state = AsyncValue.error('Please enter a valid email', StackTrace.current);
      return;
    }
    if (password.length < 6) {
      state = AsyncValue.error('Password must be at least 6 characters', StackTrace.current);
      return;
    }

    // Dummy API call
    await Future.delayed(const Duration(seconds: 2));
    
    // Persist login state
    final prefs = ref.read(sharedPreferencesProvider);
    await prefs.setBool('isLoggedIn', true);
    
    ref.read(authStateProvider.notifier).state = true;
    state = const AsyncValue.data(null);
  }

  Future<void> logout() async {
    final prefs = ref.read(sharedPreferencesProvider);
    await prefs.setBool('isLoggedIn', false);
    ref.read(authStateProvider.notifier).state = false;
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, AsyncValue<void>>((ref) {
  return AuthNotifier(ref);
});
