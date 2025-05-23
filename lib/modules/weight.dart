import 'package:flutter/material.dart';
import 'package:tracker/models/registration_data.dart';
import 'package:tracker/shared/styles/colors.dart';
import 'package:tracker/shared/styles/fonts.dart';
import 'package:tracker/modules/height_picker_page.dart';
import 'package:tracker/layout/onboarding_layout.dart';
import 'package:tracker/shared/components/components.dart';

class WeightSelectionPage extends StatefulWidget {
  final RegistrationData? registrationData;
  final Function(int)? onWeightSelected;
  final VoidCallback? onBackPressed;

  const WeightSelectionPage({
    super.key,
    this.registrationData,
    this.onWeightSelected,
    this.onBackPressed,
  });

  @override
  State<WeightSelectionPage> createState() => _WeightSelectionPageState();
}

class _WeightSelectionPageState extends State<WeightSelectionPage> {
  int selectedWeight = 75;
  final int minWeight = 40;
  final int maxWeight = 150;
  final ScrollController _scrollController = ScrollController();
  late RegistrationData _registrationData;

  @override
  void initState() {
    super.initState();

    // Initialize registration data
    _registrationData = widget.registrationData ?? RegistrationData();

    // Set selected weight if available in registration data
    if (_registrationData.weight != null) {
      selectedWeight = _registrationData.weight!;
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToSelectedWeight(animate: false);
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToSelectedWeight({bool animate = true}) {
    if (_scrollController.hasClients) {
      final itemExtent = 60.0;
      final offset = (selectedWeight - minWeight) * itemExtent;

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

  void _updateSelectedWeight(int weight) {
    if (weight != selectedWeight &&
        weight >= minWeight &&
        weight <= maxWeight) {
      setState(() {
        selectedWeight = weight;
      });
      _scrollToSelectedWeight();
    }
  }

  void _navigateToHeightSelection() {
    // Update registration data with selected weight
    _registrationData.weight = selectedWeight;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => HeightPickerPage(
          registrationData: _registrationData,
          onBackPressed: () => Navigator.pop(context),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return OnboardingLayout(
      onBackPressed: widget.onBackPressed,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "What's Your\nWeight?",
            style: AppTextStyles.heading1,
          ),
          const SizedBox(height: 16),
          const InfoBox(
            text:
                'Your weight helps us create a personalized fitness plan that is right for you',
          ),
          const SizedBox(height: 40),
          Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                AnimatedDefaultTextStyle(
                  duration: const Duration(milliseconds: 200),
                  style: AppTextStyles.numberLarge,
                  child: Text(
                    '$selectedWeight',
                    textAlign: TextAlign.center,
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(bottom: 12.0, left: 4.0),
                  child: Text(
                    'KG',
                    style: AppTextStyles.bodyLarge,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          const TriangleIndicator(),
          const SizedBox(height: 10),
          Container(
            height: 60,
            decoration: BoxDecoration(
              color: AppColors.backgroundGrey,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Stack(
              children: [
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
                NotificationListener<ScrollNotification>(
                  onNotification: (scrollNotification) {
                    if (scrollNotification is ScrollEndNotification) {
                      final itemExtent = 60.0;
                      final selectedIndex =
                          (_scrollController.offset / itemExtent).round();
                      final newWeight = minWeight + selectedIndex;

                      if (newWeight >= minWeight && newWeight <= maxWeight) {
                        _updateSelectedWeight(newWeight);
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
                    itemCount: maxWeight - minWeight + 1,
                    itemExtent: 60.0,
                    itemBuilder: (context, index) {
                      final weight = minWeight + index;
                      final isSelected = weight == selectedWeight;

                      return NumberSelector(
                        value: weight,
                        unit: 'KG',
                        isSelected: isSelected,
                        onTap: () => _updateSelectedWeight(weight),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.only(bottom: 32.0),
            child: CustomButton(
              text: 'Continue',
              onPressed: _navigateToHeightSelection,
            ),
          ),
        ],
      ),
    );
  }
}
