import 'package:flutter/material.dart';
import 'package:tracker/modules/age.dart';
import 'package:tracker/shared/styles/colors.dart';
import 'package:tracker/shared/styles/fonts.dart';
import 'package:tracker/layout/onboarding_layout.dart';
import 'package:tracker/shared/components/components.dart';

class GenderSelectionPage extends StatefulWidget {
  final Function(String)? onGenderSelected;
  final VoidCallback? onBackPressed;

  const GenderSelectionPage({
    super.key,
    this.onGenderSelected,
    this.onBackPressed,
  });

  @override
  State<GenderSelectionPage> createState() => _GenderSelectionPageState();
}

class _GenderSelectionPageState extends State<GenderSelectionPage>
    with SingleTickerProviderStateMixin {
  String? selectedGender;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onGenderSelected(String gender) {
    setState(() {
      selectedGender = gender;
    });
    _animationController.forward().then((_) => _animationController.reverse());
  }

  void _navigateToAgeSelection() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AgeSelectionPage(
          onAgeSelected: (age) {
            if (widget.onGenderSelected != null) {
              widget.onGenderSelected!(selectedGender!);
            }
            Navigator.pop(context, age);
          },
          onBackPressed: () => Navigator.pop(context),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return OnboardingLayout(
      onBackPressed: () {
        if (widget.onBackPressed != null) {
          widget.onBackPressed!();
        } else {
          Navigator.pop(context);
        }
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "What's Your\nGender?",
            style: AppTextStyles.heading1,
          ),
          const SizedBox(height: 16),
          const InfoBox(
            text:
                'Help us create a personalized experience for your fitness journey',
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.08),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildGenderOption(
                'male',
                Icons.male,
                'Male',
                AppColors.backgroundGrey,
                selectedBorderColor: AppColors.accent,
              ),
              _buildGenderOption(
                'female',
                Icons.female,
                'Female',
                AppColors.backgroundGrey,
                selectedBorderColor: AppColors.accent,
              ),
            ],
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.only(bottom: 32.0),
            child: CustomButton(
              text: 'Continue',
              onPressed: selectedGender != null
                  ? () {
                      if (widget.onGenderSelected != null) {
                        widget.onGenderSelected!(selectedGender!);
                      }
                      _navigateToAgeSelection();
                    }
                  : () {},
              isEnabled: selectedGender != null,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGenderOption(
    String gender,
    IconData icon,
    String label,
    Color color, {
    Color? selectedBorderColor,
  }) {
    final isSelected = selectedGender == gender;

    return GestureDetector(
      onTap: () => _onGenderSelected(gender),
      child: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return Transform.scale(
            scale: isSelected ? _scaleAnimation.value : 1.0,
            child: Column(
              children: [
                Container(
                  width: 140,
                  height: 140,
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.buttonBackground : color,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isSelected
                          ? (selectedBorderColor ?? AppColors.buttonText)
                          : Colors.transparent,
                      width: 3,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.shadow,
                        blurRadius: isSelected ? 12 : 4,
                        spreadRadius: isSelected ? 2 : 0,
                      ),
                    ],
                  ),
                  child: Center(
                    child: Icon(
                      icon,
                      size: 60,
                      color:
                          isSelected ? AppColors.accent : AppColors.textPrimary,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  label,
                  style: AppTextStyles.bodyLarge.copyWith(
                    color: isSelected
                        ? AppColors.textPrimary
                        : AppColors.textSecondary,
                    fontWeight:
                        isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
