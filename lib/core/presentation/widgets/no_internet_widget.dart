import 'package:ecommerce_project/core/theme/app_colors.dart';
import 'package:ecommerce_project/core/theme/app_fonts.dart';
import 'package:ecommerce_project/core/theme/app_spacing.dart';
import 'package:flutter/material.dart';

class NoInternetWidget extends StatelessWidget {
  final VoidCallback onRetry;

  const NoInternetWidget({super.key, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xxxl),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 140,
                height: 140,
                decoration: BoxDecoration(
                  color: AppColors.noInternetBg,
                  borderRadius: BorderRadius.circular(AppSpacing.xxxl),
                ),
                child: const Center(
                  child: Icon(
                    Icons.wifi_off_rounded,
                    color: AppColors.noInternetIcon,
                    size: 60,
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.xxxl),
              const Text(
                'No internet connection',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: AppFonts.sizeTitleSmall,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: AppSpacing.m),
              const Text(
                'Check your Wi-Fi or mobile data, then try connecting again.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: AppFonts.sizeMedium,
                  color: AppColors.textGrey,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: AppSpacing.jumbo),
              SizedBox(
                width: double.infinity,
                height: 64,
                child: OutlinedButton(
                  onPressed: onRetry,
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Color(0xFF1A1C1E)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppSpacing.m),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.refresh, color: Colors.white),
                      SizedBox(width: 12),
                      Text(
                        'Try again',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: AppFonts.sizeLarge,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
              const Text(
                'Cached products are still available',
                style: TextStyle(
                  color: AppColors.textGrey,
                  fontSize: AppFonts.sizeSmall,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
