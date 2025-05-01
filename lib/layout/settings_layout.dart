import 'package:flutter/material.dart';
import 'package:tracker/shared/components/custom_app_bar.dart';
import 'package:tracker/shared/components/bottom_nav_bar.dart';

class SettingsLayout extends StatelessWidget {
  final String title;
  final String time;
  final List<Widget> settingsItems;
  final int selectedIndex;
  final Function(int)? onIndexChanged;

  const SettingsLayout({
    Key? key,
    required this.title,
    required this.time,
    required this.settingsItems,
    required this.selectedIndex,
    this.onIndexChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        title: title,
        time: time,
        showBackButton: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              ...settingsItems,
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
      bottomNavigationBar: selectedIndex >= 0
          ? CustomBottomNavBar(
              selectedIndex: selectedIndex,
              onItemSelected: (index) {
                if (onIndexChanged != null) {
                  onIndexChanged!(index);
                }
              },
            )
          : null,
    );
  }
}
