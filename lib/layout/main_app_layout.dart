import 'package:flutter/material.dart';
import 'package:tracker/shared/components/components.dart';
import 'package:tracker/modules/health_dashboard.dart';
import 'package:tracker/modules/workout_screen.dart';
import 'package:tracker/modules/challenge_screen.dart';
import 'package:tracker/modules/profile_page.dart';

class MainAppLayout extends StatelessWidget {
  final String title;
  final String time;
  final bool showBackButton;
  final int selectedIndex;
  final Widget body;
  final Function(int)? onIndexChanged;
  final EdgeInsetsGeometry contentPadding;
  final bool navigateOnTabChange;
  // Add a static map to store screen instances
  static final Map<int, Widget> _screenInstances = {
    0: const HealthDashboardScreen(),
    1: const ChallengeScreen(),
    2: const WorkoutScreen(),
    3: const ProfilePage(),
  };

  const MainAppLayout({
    Key? key,
    required this.title,
    required this.time,
    required this.selectedIndex,
    required this.body,
    this.showBackButton = false,
    this.onIndexChanged,
    this.contentPadding = EdgeInsets.zero,
    this.navigateOnTabChange = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        title: title,
        time: time,
        showBackButton: showBackButton,
      ),
      body: SafeArea(
        child: Padding(
          padding: contentPadding,
          child: body,
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(
        selectedIndex: selectedIndex,
        onItemSelected: (index) {
          if (onIndexChanged != null) {
            onIndexChanged!(index);
          }

          if (navigateOnTabChange && index != selectedIndex) {
            _navigateToScreen(context, index);
          }
        },
      ),
    );
  }

  void _navigateToScreen(BuildContext context, int index) {
    // Get the cached screen instance or create a new one
    Widget screen = _screenInstances[index] ?? const HealthDashboardScreen();

    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => screen,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          Offset begin = index < selectedIndex
              ? const Offset(-1.0, 0.0)
              : const Offset(1.0, 0.0);
          const end = Offset.zero;
          const curve = Curves.easeInOut;
          var tween =
              Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
          var offsetAnimation = animation.drive(tween);
          return SlideTransition(position: offsetAnimation, child: child);
        },
        transitionDuration: const Duration(milliseconds: 300),
      ),
    );
  }
}
