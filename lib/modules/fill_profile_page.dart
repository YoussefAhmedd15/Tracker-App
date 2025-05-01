import 'package:flutter/material.dart';
import 'package:tracker/layout/auth_layout.dart';
import 'package:tracker/shared/styles/colors.dart';
import 'package:tracker/shared/styles/fonts.dart';
import 'package:tracker/layout/onboarding_layout.dart';
import 'package:tracker/shared/components/sign_components.dart';

class FillProfilePage extends StatelessWidget {
  final int? selectedWeight;
  final int? selectedHeight;

  const FillProfilePage({
    super.key,
    this.selectedWeight,
    this.selectedHeight,
  });

  @override
  Widget build(BuildContext context) {
    return AuthLayout(
      title: 'Fill Your Profile',
      subtitle: 'Please fill in your details below to complete your profile.',
      children: [
        // Profile Picture Section
        Container(
          height: 140,
          width: double.infinity,
          decoration: BoxDecoration(
            color: AppColors.avatarBackground,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Center(
            child: Stack(
              alignment: Alignment.center,
              clipBehavior: Clip.none,
              children: [
                const CircleAvatar(
                  radius: 45,
                  backgroundImage: AssetImage('images/pp.jpg'),
                ),
                Positioned(
                  bottom: -4,
                  right: -4,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: AppColors.background,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.shadow,
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.edit,
                      size: 18,
                      color: AppColors.iconColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 30),
        // Form Fields
        const CustomTextField(
          label: 'Full Name',
          hintText: 'Madison Smith',
        ),
        const SizedBox(height: 16),
        const CustomTextField(
          label: 'Nickname',
          hintText: 'Madison',
        ),
        const SizedBox(height: 16),
        const CustomTextField(
          label: 'Email',
          hintText: 'madisons@example.com',
        ),
        const SizedBox(height: 16),
        const CustomTextField(
          label: 'Password',
          hintText: '*******',
          obscureText: true,
        ),
        const SizedBox(height: 16),
        // Display selected weight and height
        if (selectedWeight != null && selectedHeight != null)
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.backgroundGrey,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    Text(
                      '$selectedWeight',
                      style: AppTextStyles.numberLarge,
                    ),
                    const Text(
                      'Weight (kg)',
                      style: AppTextStyles.bodySmall,
                    ),
                  ],
                ),
                Column(
                  children: [
                    Text(
                      '$selectedHeight',
                      style: AppTextStyles.numberLarge,
                    ),
                    const Text(
                      'Height (cm)',
                      style: AppTextStyles.bodySmall,
                    ),
                  ],
                ),
              ],
            ),
          ),
      ],
      bottomButton: CustomButton(
        text: 'Start',
        onPressed: () {
          // TODO: Save profile data and navigate to main app
        },
      ),
    );
  }
}

class CustomTextField extends StatelessWidget {
  final String label;
  final String hintText;
  final bool obscureText;

  const CustomTextField({
    super.key,
    required this.label,
    required this.hintText,
    this.obscureText = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.inputLabel,
        ),
        const SizedBox(height: 8),
        TextField(
          decoration: InputDecoration(
            hintText: hintText,
            filled: true,
            fillColor: AppColors.backgroundGrey,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
          ),
          obscureText: obscureText,
        ),
      ],
    );
  }
}
