import 'package:flutter/material.dart';

class RunningChallengeCard extends StatelessWidget {
  const RunningChallengeCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text(
                'Past: 81cm',
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(width: 8),
              Icon(
                Icons.arrow_forward,
                size: 14,
                color: Colors.grey.shade400,
              ),
              const SizedBox(width: 8),
              const Text(
                'Current: 86cm',
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(7, (index) {
              final days = ['MO', 'TU', 'WE', 'TH', 'FR', 'ST', 'SU'];
              return Column(
                children: [
                  Text(
                    days[index],
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      color: Colors.yellow.shade50,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.yellow.shade200,
                        width: 2,
                      ),
                    ),
                    child: Center(
                      child: Icon(
                        Icons.wb_sunny_outlined,
                        size: 16,
                        color: Colors.yellow.shade700,
                      ),
                    ),
                  ),
                ],
              );
            }),
          ),
        ],
      ),
    );
  }
}
