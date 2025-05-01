import 'package:flutter/material.dart';
import 'package:tracker/modules/fill_profile_page.dart';
import 'package:tracker/shared/styles/colors.dart';
import 'package:tracker/shared/styles/fonts.dart';
import 'package:tracker/layout/onboarding_layout.dart';
import 'package:tracker/shared/components/sign_components.dart';

class HeightPickerPage extends StatefulWidget {
  final int? selectedWeight;

  const HeightPickerPage({
    super.key,
    this.selectedWeight,
  });

  @override
  State<HeightPickerPage> createState() => _HeightPickerPageState();
}

class _HeightPickerPageState extends State<HeightPickerPage> {
  FixedExtentScrollController scrollController =
      FixedExtentScrollController(initialItem: 45);
  int selectedHeight = 165;

  double dragStartDy = 0.0;

  @override
  Widget build(BuildContext context) {
    return OnboardingLayout(
      child: Column(
        children: [
          const Text(
            'What Is Your Height?',
            style: AppTextStyles.heading3,
          ),
          const SizedBox(height: 8),
          const Text(
            'Please select your height from the ruler below.',
            style: AppTextStyles.bodySmall,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                selectedHeight.toString(),
                style: AppTextStyles.numberLarge,
              ),
              const SizedBox(width: 4),
              const Padding(
                padding: EdgeInsets.only(bottom: 8),
                child: Text('Cm', style: AppTextStyles.bodyMedium),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Expanded(
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: 100,
                  margin: const EdgeInsets.symmetric(horizontal: 40),
                  decoration: BoxDecoration(
                    color: AppColors.accentPurple,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: GestureDetector(
                    onVerticalDragStart: (details) {
                      dragStartDy = details.localPosition.dy;
                    },
                    onVerticalDragUpdate: (details) {
                      double dragDistance =
                          details.localPosition.dy - dragStartDy;
                      if (dragDistance.abs() > 20) {
                        if (dragDistance > 0) {
                          if (selectedHeight > 120) {
                            setState(() {
                              selectedHeight--;
                              scrollController.jumpToItem(selectedHeight - 120);
                            });
                          }
                        } else {
                          if (selectedHeight < 220) {
                            setState(() {
                              selectedHeight++;
                              scrollController.jumpToItem(selectedHeight - 120);
                            });
                          }
                        }
                        dragStartDy = details.localPosition.dy;
                      }
                    },
                    child: ListWheelScrollView.useDelegate(
                      controller: scrollController,
                      itemExtent: 20,
                      physics: const FixedExtentScrollPhysics(),
                      perspective: 0.0001,
                      diameterRatio: 2.5,
                      onSelectedItemChanged: (index) {
                        setState(() {
                          selectedHeight = 120 + index;
                        });
                      },
                      childDelegate: ListWheelChildBuilderDelegate(
                        builder: (context, index) {
                          int value = 120 + index;
                          if (value > 220) return null;

                          bool isMajor = value % 5 == 0;

                          return Container(
                            alignment: Alignment.centerLeft,
                            padding: const EdgeInsets.only(left: 12),
                            child: Row(
                              children: [
                                Container(
                                  height: 2,
                                  width: isMajor ? 20 : 10,
                                  color: AppColors.accentDeepPurple,
                                ),
                                const SizedBox(width: 8),
                                if (isMajor)
                                  Text(
                                    value.toString(),
                                    style: AppTextStyles.bodySmall,
                                  ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),

                // Yellow Center Line
                Positioned(
                  right: 24,
                  child: Container(
                    width: 14,
                    height: 2,
                    color: AppColors.accent,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: CustomButton(
              text: 'Continue',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FillProfilePage(
                      selectedWeight: widget.selectedWeight,
                      selectedHeight: selectedHeight,
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
