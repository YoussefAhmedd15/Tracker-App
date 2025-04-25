import 'package:flutter/material.dart';

class ResultScreen extends StatelessWidget {
  final String gender;
  final int age;
  final double bmiResult;

  const ResultScreen({
    super.key,
    required this.gender,
    required this.age,
    required this.bmiResult,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("BMI Result"),
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Gender: $gender"),
            Text("Age: $age"),
            Text("BMI: ${bmiResult.toStringAsFixed(1)}"),
          ],
        ),
      ),
    );
  }
}
