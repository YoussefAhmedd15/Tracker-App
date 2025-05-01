import 'package:flutter/material.dart';
import 'exercise_card.dart';

class MuscleSection extends StatelessWidget {
  const MuscleSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Muscles workload',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Select muscles type you want to make strong',
          style: TextStyle(
            fontSize: 16,
            color: Colors.black54,
          ),
        ),
        const SizedBox(height: 20),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 0.85,
          ),
          itemCount: 4,
          itemBuilder: (context, index) {
            final items = [
              {'name': 'Quads', 'color': const Color(0xFFF6F6F6)},
              {'name': 'Chest', 'color': const Color(0xFFE5F3EA)},
              {'name': 'Abs', 'color': const Color(0xFFFFF3E9)},
              {'name': 'Biceps', 'color': const Color(0xFFFFEEF0)},
            ];
            return ExerciseCard(
              name: items[index]['name'] as String,
              color: items[index]['color'] as Color,
            );
          },
        ),
      ],
    );
  }
}
