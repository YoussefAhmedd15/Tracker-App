// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:train/home_screen.dart';

void main() {
  testWidgets('BMI Calculator smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MaterialApp(home: HomeScreen()));

    // Verify that the app title is present
    expect(find.text('BMI Calculator'), findsOneWidget);

    // Verify that initial values are present
    expect(find.text('60'), findsOneWidget); // Initial weight
    expect(find.text('160'), findsOneWidget); // Initial height
    expect(find.text('30'), findsOneWidget); // Initial age
  });
}
