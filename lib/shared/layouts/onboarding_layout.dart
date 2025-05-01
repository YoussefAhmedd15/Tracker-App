import 'package:flutter/material.dart';
import 'package:tracker/shared/styles/colors.dart';

class OnboardingLayout extends StatelessWidget {
  final Widget child;
  final VoidCallback? onBackPressed;
  final bool showBackButton;

  const OnboardingLayout({
    super.key,
    required this.child,
    this.onBackPressed,
    this.showBackButton = true,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (showBackButton) ...[
                Padding(
                  padding: const EdgeInsets.only(top: 16.0, bottom: 32.0),
                  child: IconButton(
                    onPressed: onBackPressed ?? () => Navigator.pop(context),
                    icon: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.buttonBackground,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.shadow,
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.arrow_back,
                        color: AppColors.buttonText,
                        size: 24,
                      ),
                    ),
                  ),
                ),
              ],
              Expanded(child: child),
            ],
          ),
        ),
      ),
    );
  }
}
