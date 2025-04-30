import 'package:flutter/material.dart';
import 'package:tracker/modules/gender.dart';

class WorkoutMotivationScreen extends StatelessWidget {
  const WorkoutMotivationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
                  Colors.black.withOpacity(0.3),
                  Colors.black.withOpacity(0.8),
                ],
              ),
            ),
          ),
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
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.yellow,
                          height: 1.2,
                          shadows: [
                            Shadow(
                              offset: const Offset(0, 1),
                              blurRadius: 3.0,
                              color: Colors.black.withOpacity(0.2),
                            ),
                          ],
                        ),
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
                    color: Colors.white,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(40),
                      topRight: Radius.circular(40),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
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
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.grey[800],
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 40),
                      // Next Button
                      Container(
                        width: double.infinity,
                        height: 60,
                        margin: const EdgeInsets.symmetric(horizontal: 24),
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const GenderSelectionPage(),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 0,
                          ),
                          child: const Text(
                            'Next',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
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
