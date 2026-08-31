import 'package:ecommerce_project/core/theme/app_colors.dart';
import 'package:ecommerce_project/core/theme/app_fonts.dart';
import 'package:ecommerce_project/core/theme/app_spacing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/auth_provider.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isPasswordVisible = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onSignIn() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    await ref.read(authProvider.notifier).login(email, password);
    
    if (ref.read(authStateProvider)) {
      if (mounted) {
        context.go('/home');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);

    ref.listen<AsyncValue<void>>(authProvider, (previous, next) {
      next.whenOrNull(
        error: (error, stackTrace) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(error.toString())),
          );
        },
      );
    });

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: AppSpacing.xxxl),
              Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(AppSpacing.s),
                    ),
                    child: const Icon(Icons.shopping_bag_outlined, color: AppColors.white),
                  ),
                  const SizedBox(width: AppSpacing.s),
                  const Text(
                    'MyShop',
                    style: TextStyle(
                      fontSize: AppFonts.sizeTitleMedium,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textDark,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.massive),
              const Text(
                'Welcome back',
                style: TextStyle(
                  fontSize: AppFonts.sizeTitleLarge,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textDark,
                ),
              ),
              const SizedBox(height: AppSpacing.xs),
              const Text(
                'Sign in to continue shopping.',
                style: TextStyle(
                  fontSize: AppFonts.sizeMedium,
                  color: AppColors.textGrey,
                ),
              ),
              const SizedBox(height: AppSpacing.xxxl),
              const Text(
                'Email',
                style: TextStyle(fontWeight: FontWeight.w600, color: AppColors.textDark),
              ),
              const SizedBox(height: AppSpacing.xs),
              TextField(
                controller: _emailController,
                style: const TextStyle(color: AppColors.textDark, fontSize: AppFonts.sizeMedium),
                decoration: InputDecoration(
                  hintText: 'you@example.com',
                  hintStyle: const TextStyle(color: AppColors.textGrey),
                  prefixIcon: const Icon(Icons.email_outlined, color: AppColors.textGrey),
                  filled: true,
                  fillColor: Theme.of(context).cardColor,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppSpacing.s),
                    borderSide: const BorderSide(color: AppColors.border),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppSpacing.s),
                    borderSide: const BorderSide(color: AppColors.border),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
              const Text(
                'Password',
                style: TextStyle(fontWeight: FontWeight.w600, color: AppColors.textDark),
              ),
              const SizedBox(height: AppSpacing.xs),
              TextField(
                controller: _passwordController,
                obscureText: !_isPasswordVisible,
                style: const TextStyle(color: AppColors.textDark, fontSize: AppFonts.sizeMedium),
                decoration: InputDecoration(
                  hintText: '••••••••',
                  hintStyle: const TextStyle(color: AppColors.textGrey),
                  prefixIcon: const Icon(Icons.lock_outline, color: AppColors.textGrey),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isPasswordVisible ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                      color: AppColors.textGrey,
                    ),
                    onPressed: () => setState(() => _isPasswordVisible = !_isPasswordVisible),
                  ),
                  filled: true,
                  fillColor: Theme.of(context).cardColor,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppSpacing.s),
                    borderSide: const BorderSide(color: AppColors.border),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppSpacing.s),
                    borderSide: const BorderSide(color: AppColors.border),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.xxxl),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: authState.isLoading ? null : _onSignIn,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.black,
                    foregroundColor: AppColors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppSpacing.s),
                    ),
                  ),
                  child: authState.isLoading
                      ? const CircularProgressIndicator(color: AppColors.white)
                      : const Text('Sign in', style: TextStyle(fontSize: AppFonts.sizeLarge, fontWeight: FontWeight.bold)),
                ),
              ),
              const SizedBox(height: AppSpacing.giant),
              const Center(
                child: Text(
                  'Demo authentication • Any credentials work',
                  style: TextStyle(color: AppColors.textGrey, fontSize: AppFonts.sizeSmall),
                ),
              ),
              const SizedBox(height: AppSpacing.l),
            ],
          ),
        ),
      ),
    );
  }
}
