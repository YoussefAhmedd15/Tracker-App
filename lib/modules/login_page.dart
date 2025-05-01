import 'package:flutter/material.dart';
import 'package:tracker/shared/styles/colors.dart';
import 'package:tracker/shared/styles/fonts.dart';
import 'package:tracker/shared/layouts/auth_layout.dart';
import 'package:tracker/modules/motivation.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AuthLayout(
      title: 'Login',
      subtitle: 'Welcome back! Please enter your details.',
      children: [
        // Email Field
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Email',
              style: AppTextStyles.inputLabel,
            ),
            const SizedBox(height: 8),
            TextField(
              decoration: InputDecoration(
                hintText: 'Enter your email',
                filled: true,
                fillColor: AppColors.backgroundGrey,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        // Password Field
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Password',
              style: AppTextStyles.inputLabel,
            ),
            const SizedBox(height: 8),
            TextField(
              obscureText: true,
              decoration: InputDecoration(
                hintText: 'Enter your password',
                filled: true,
                fillColor: AppColors.backgroundGrey,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        // Forgot Password
        Align(
          alignment: Alignment.centerRight,
          child: TextButton(
            onPressed: () {},
            child: Text(
              'Forgot Password?',
              style: AppTextStyles.bodySmall,
            ),
          ),
        ),
      ],
      bottomButton: SizedBox(
        width: double.infinity,
        height: 55,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.buttonBackground,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const WorkoutMotivationScreen(),
              ),
            );
          },
          child: Text(
            'Login',
            style: AppTextStyles.buttonLarge,
          ),
        ),
      ),
    );
  }
}
