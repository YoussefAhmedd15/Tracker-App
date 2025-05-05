import 'package:flutter/material.dart';
import 'package:tracker/modules/weight.dart';
import 'package:tracker/shared/styles/colors.dart';
import 'package:tracker/shared/styles/fonts.dart';
import 'package:tracker/layout/onboarding_layout.dart';
import 'package:tracker/shared/components/components.dart';

class AgeSelectionPage extends StatefulWidget {
  final Function(int)? onAgeSelected;
  final VoidCallback? onBackPressed;

  const AgeSelectionPage({
    super.key,
    this.onAgeSelected,
    this.onBackPressed,
  });

  @override
  State<AgeSelectionPage> createState() => _AgeSelectionPageState();
}

class _AgeSelectionPageState extends State<AgeSelectionPage> {
  final int minAge = 18;
  final int maxAge = 100;
  int selectedAge = 28;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToSelectedAge(animate: false);
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToSelectedAge({bool animate = true}) {
    if (_scrollController.hasClients) {
      final itemExtent = 60.0;
      final offset = (selectedAge - minAge) * itemExtent;

      if (animate) {
        _scrollController.animateTo(
          offset,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOutCubic,
        );
      } else {
        _scrollController.jumpTo(offset);
      }
    }
  }

  void _updateSelectedAge(int age) {
    if (age != selectedAge && age >= minAge && age <= maxAge) {
      setState(() {
        selectedAge = age;
      });
      _scrollToSelectedAge();
    }
  }

  @override
  Widget build(BuildContext context) {
    return OnboardingLayout(
      onBackPressed: widget.onBackPressed,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          const Text(
            "How Old\nAre You?",
            style: AppTextStyles.heading1,
          ),

          const SizedBox(height: 16),

          // Info text
          const InfoBox(
            text:
                'Your age helps us create a personalized fitness plan that is right for you',
          ),

          const SizedBox(height: 40),

          // Selected Age Display
          Center(
            child: AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 200),
              style: AppTextStyles.numberLarge,
              child: Text(
                selectedAge.toString(),
                textAlign: TextAlign.center,
              ),
            ),
          ),

          const SizedBox(height: 10),

          // Triangle indicator
          const TriangleIndicator(),

          const SizedBox(height: 10),

          // Age selector
          Container(
            height: 60,
            decoration: BoxDecoration(
              color: AppColors.backgroundGrey,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Stack(
              children: [
                // Center Highlight
                Center(
                  child: Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: AppColors.buttonBackground.withOpacity(0.05),
                      border: Border(
                        left: BorderSide(color: AppColors.accent, width: 2),
                        right: BorderSide(color: AppColors.accent, width: 2),
                      ),
                    ),
                  ),
                ),

                // Scrollable Age Numbers
                NotificationListener<ScrollNotification>(
                  onNotification: (scrollNotification) {
                    if (scrollNotification is ScrollEndNotification) {
                      final itemExtent = 60.0;
                      final selectedIndex =
                          (_scrollController.offset / itemExtent).round();
                      final newAge = minAge + selectedIndex;

                      if (newAge >= minAge && newAge <= maxAge) {
                        _updateSelectedAge(newAge);
                      }
                    }
                    return true;
                  },
                  child: ListView.builder(
                    controller: _scrollController,
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    padding: EdgeInsets.symmetric(
                      horizontal: (MediaQuery.of(context).size.width - 60) / 2,
                    ),
                    itemCount: maxAge - minAge + 1,
                    itemExtent: 60.0,
                    itemBuilder: (context, index) {
                      final age = minAge + index;
                      final isSelected = age == selectedAge;

                      return NumberSelector(
                        value: age,
                        unit: '',
                        isSelected: isSelected,
                        onTap: () => _updateSelectedAge(age),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),

          const Spacer(),

          // Continue Button
          Padding(
            padding: const EdgeInsets.only(bottom: 32.0),
            child: CustomButton(
              text: 'Continue',
              onPressed: () {
                if (widget.onAgeSelected != null) {
                  widget.onAgeSelected!(selectedAge);
                }
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => WeightSelectionPage(
                      onWeightSelected: (weight) {
                        if (widget.onAgeSelected != null) {
                          widget.onAgeSelected!(selectedAge);
                        }
                        Navigator.pop(context, weight);
                      },
                      onBackPressed: () => Navigator.pop(context),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
