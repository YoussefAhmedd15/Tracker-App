import 'package:flutter/material.dart';
import 'package:tracker/modules/gender.dart';
import 'package:tracker/shared/styles/colors.dart';
import 'package:tracker/shared/styles/fonts.dart';
import 'package:tracker/shared/layouts/onboarding_layout.dart';
import 'package:tracker/shared/components/sign_components.dart';

class WorkoutMotivationScreen extends StatelessWidget {
  const WorkoutMotivationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background Image
          Image.asset(
            'images/workout_man.jpg',
            fit: BoxFit.cover,
            alignment: Alignment.topCenter,
            width: double.infinity,
            height: double.infinity,
          ),
          // Dark Gradient Overlay for better text visibility
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  AppColors.primary.withOpacity(0.3),
                  AppColors.primary.withOpacity(0.8),
                ],
              ),
            ),
          ),
          // Back Button
          Positioned(
            top: 16,
            left: 16,
            child: IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
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
          // Content
          SafeArea(
            child: Column(
              children: [
                const Spacer(flex: 3),
                // Motivation Text
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Consistency Is\nThe Key To Progress.\nDon\'t Give Up!',
                        textAlign: TextAlign.center,
                        style: AppTextStyles.motivationalText,
                      ),
                    ],
                  ),
                ),
                const Spacer(flex: 2),
                // Motivational Text Box
                Container(
                  width: double.infinity,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 32, vertical: 32),
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(40),
                      topRight: Radius.circular(40),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.shadow,
                        blurRadius: 10,
                        offset: const Offset(0, -2),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Text(
                        'Every rep brings you closer to your goals. Remember, your body achieves what your mind believes. Make today\'s workout the reason for tomorrow\'s strength.',
                        textAlign: TextAlign.center,
                        style: AppTextStyles.motivationalQuote,
                      ),
                      const SizedBox(height: 40),
                      // Next Button
                      Container(
                        width: double.infinity,
                        height: 60,
                        margin: const EdgeInsets.symmetric(horizontal: 24),
                        child: CustomButton(
                          text: 'Next',
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const GenderSelectionPage(),
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
