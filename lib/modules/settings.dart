import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:ui';
import 'package:tracker/shared/components/bottom_nav_bar.dart';
import 'package:tracker/modules/health_dashboard.dart';
import 'package:tracker/modules/profile_page.dart';
import 'package:tracker/modules/workout_screen.dart';
import 'package:tracker/modules/challenge_screen.dart';
import 'package:tracker/shared/components/custom_app_bar.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool notificationsEnabled = true;
  bool connectionAlertsEnabled = true;
  bool phoneCallsEnabled = false;
  int selectedIndex = 3; // Updated to match profile tab index

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const CustomAppBar(
        title: 'Settings',
        time: '9:41',
        showBackButton: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  children: [
                    const SizedBox(height: 16),
                    _buildSettingsCard(),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(
        selectedIndex: selectedIndex,
        onItemSelected: (index) {
          if (index == 0) {
            // Home icon
            Navigator.pushReplacement(
              context,
              PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) =>
                    const HealthDashboardScreen(),
                transitionsBuilder:
                    (context, animation, secondaryAnimation, child) {
                  const begin = Offset(-1.0, 0.0);
                  const end = Offset.zero;
                  const curve = Curves.easeInOut;
                  var tween = Tween(begin: begin, end: end)
                      .chain(CurveTween(curve: curve));
                  var offsetAnimation = animation.drive(tween);
                  return SlideTransition(
                      position: offsetAnimation, child: child);
                },
                transitionDuration: const Duration(milliseconds: 300),
              ),
            );
          } else if (index == 1) {
            // Trophy icon (challenges)
            Navigator.pushReplacement(
              context,
              PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) =>
                    const ChallengeScreen(),
                transitionsBuilder:
                    (context, animation, secondaryAnimation, child) {
                  const begin = Offset(1.0, 0.0);
                  const end = Offset.zero;
                  const curve = Curves.easeInOut;
                  var tween = Tween(begin: begin, end: end)
                      .chain(CurveTween(curve: curve));
                  var offsetAnimation = animation.drive(tween);
                  return SlideTransition(
                      position: offsetAnimation, child: child);
                },
                transitionDuration: const Duration(milliseconds: 300),
              ),
            );
          } else if (index == 2) {
            // Heart icon (workout)
            Navigator.pushReplacement(
              context,
              PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) =>
                    const WorkoutScreen(),
                transitionsBuilder:
                    (context, animation, secondaryAnimation, child) {
                  const begin = Offset(1.0, 0.0);
                  const end = Offset.zero;
                  const curve = Curves.easeInOut;
                  var tween = Tween(begin: begin, end: end)
                      .chain(CurveTween(curve: curve));
                  var offsetAnimation = animation.drive(tween);
                  return SlideTransition(
                      position: offsetAnimation, child: child);
                },
                transitionDuration: const Duration(milliseconds: 300),
              ),
            );
          } else if (index == 3) {
            // Profile icon
            Navigator.pushReplacement(
              context,
              PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) =>
                    const ProfilePage(),
                transitionsBuilder:
                    (context, animation, secondaryAnimation, child) {
                  const begin = Offset(-1.0, 0.0);
                  const end = Offset.zero;
                  const curve = Curves.easeInOut;
                  var tween = Tween(begin: begin, end: end)
                      .chain(CurveTween(curve: curve));
                  var offsetAnimation = animation.drive(tween);
                  return SlideTransition(
                      position: offsetAnimation, child: child);
                },
                transitionDuration: const Duration(milliseconds: 300),
              ),
            );
          } else {
            setState(() {
              selectedIndex = index;
            });
          }
        },
      ),
    );
  }

  Widget _buildSettingsCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildSettingItem(
            icon: Icons.language,
            iconColor: Colors.blue,
            iconBgColor: Colors.blue.shade50,
            title: 'Language',
            subtitle: 'English',
            onTap: () {},
          ),
          const Divider(height: 32),
          _buildToggleItem(
            icon: Icons.notifications,
            iconColor: Colors.orange,
            iconBgColor: Colors.orange.shade50,
            title: 'Notifications',
            value: notificationsEnabled,
            onChanged: (value) {
              setState(() {
                notificationsEnabled = value;
              });
            },
          ),
          const Divider(height: 32),
          _buildToggleItem(
            icon: Icons.warning,
            iconColor: Colors.red,
            iconBgColor: Colors.red.shade50,
            title: 'Connection alerts',
            value: connectionAlertsEnabled,
            onChanged: (value) {
              setState(() {
                connectionAlertsEnabled = value;
              });
            },
          ),
          const Divider(height: 32),
          _buildToggleItem(
            icon: Icons.phone,
            iconColor: Colors.teal,
            iconBgColor: Colors.teal.shade50,
            title: 'Phone calls',
            value: phoneCallsEnabled,
            onChanged: (value) {
              setState(() {
                phoneCallsEnabled = value;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSettingItem({
    required IconData icon,
    required Color iconColor,
    required Color iconBgColor,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: iconBgColor,
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: iconColor,
              size: 20,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
          const Icon(
            Icons.chevron_right,
            color: Colors.grey,
          ),
        ],
      ),
    );
  }

  Widget _buildToggleItem({
    required IconData icon,
    required Color iconColor,
    required Color iconBgColor,
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: iconBgColor,
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            color: iconColor,
            size: 20,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        CupertinoSwitch(
          value: value,
          activeColor: Colors.black,
          onChanged: onChanged,
        ),
      ],
    );
  }
}
