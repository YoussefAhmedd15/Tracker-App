import 'package:flutter/material.dart';
import 'package:tracker/shared/components/workout_top_card.dart';
import 'package:tracker/shared/components/progress_card.dart';
import 'package:tracker/shared/components/muscle_section.dart';
import 'package:tracker/layout/main_app_layout.dart';

class WorkoutScreen extends StatefulWidget {
  const WorkoutScreen({Key? key}) : super(key: key);

  @override
  State<WorkoutScreen> createState() => _WorkoutScreenState();
}

class _WorkoutScreenState extends State<WorkoutScreen> {
  int selectedIndex = 2; // Heart icon selected - updated index

  @override
  Widget build(BuildContext context) {
    return MainAppLayout(
      title: 'Workout',
      time: '9:41',
      selectedIndex: selectedIndex,
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            WorkoutTopCard(),
            SizedBox(height: 30),
            ProgressCard(
              progress: 0.6,
              exercisesLeft: 12,
            ),
            SizedBox(height: 30),
            MuscleSection(),
          ],
        ),
      ),
      onIndexChanged: (index) {
        setState(() {
          selectedIndex = index;
        });
      },
    );
  }
}
