import 'dart:async';
import 'package:pedometer/pedometer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

class StepCounterService {
  static final StepCounterService _instance = StepCounterService._internal();

  factory StepCounterService() {
    return _instance;
  }

  StepCounterService._internal();

  // Stream controllers
  Stream<StepCount>? _stepCountStream;
  Stream<PedestrianStatus>? _pedestrianStatusStream;

  // Step count variables
  int _steps = 0;
  int _stepsAtReset = 0;
  int _caloriesBurned = 0;
  DateTime? _lastResetDate;

  // Status variables
  String _status = 'Unknown';
  bool _isInitialized = false;

  // Getters
  int get steps => _steps - _stepsAtReset;
  int get caloriesBurned => _caloriesBurned;
  String get status => _status;
  bool get isInitialized => _isInitialized;

  // Initialize the step counter
  Future<void> init() async {
    if (_isInitialized) return;

    try {
      // Load saved data
      await _loadSavedData();

      // Initialize pedometer streams
      _stepCountStream = Pedometer.stepCountStream;
      _pedestrianStatusStream = Pedometer.pedestrianStatusStream;

      // Listen to step count events
      _stepCountStream?.listen(_onStepCount).onError(_onStepCountError);

      // Listen to status events
      _pedestrianStatusStream
          ?.listen(_onPedestrianStatusChanged)
          .onError(_onPedestrianStatusError);

      _isInitialized = true;
      debugPrint('Step counter initialized successfully');
    } catch (e) {
      debugPrint('Error initializing step counter: $e');
    }
  }

  // Handle step count updates
  void _onStepCount(StepCount event) {
    _steps = event.steps;

    // Check if we need to reset the counter (new day)
    _checkForDayChange();

    // Calculate calories
    _calculateCalories();

    // Save the data
    _saveData();
  }

  // Handle pedestrian status changes
  void _onPedestrianStatusChanged(PedestrianStatus event) {
    _status = event.status;
  }

  // Handle step count errors
  void _onStepCountError(error) {
    debugPrint('Step count error: $error');
  }

  // Handle pedestrian status errors
  void _onPedestrianStatusError(error) {
    debugPrint('Pedestrian status error: $error');
  }

  // Calculate calories burned based on steps
  // Using a simple formula: calories = steps * 0.04
  void _calculateCalories() {
    _caloriesBurned = ((steps) * 0.04).round();
  }

  // Check if the day has changed and reset the counter if needed
  void _checkForDayChange() async {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    if (_lastResetDate == null) {
      _lastResetDate = today;
      return;
    }

    if (today.isAfter(_lastResetDate!)) {
      // It's a new day, reset the counter
      _stepsAtReset = _steps;
      _lastResetDate = today;
      await _saveData();
    }
  }

  // Save data to SharedPreferences
  Future<void> _saveData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('steps_at_reset', _stepsAtReset);
      await prefs.setString('last_reset_date', _lastResetDate.toString());
    } catch (e) {
      debugPrint('Error saving step data: $e');
    }
  }

  // Load saved data from SharedPreferences
  Future<void> _loadSavedData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _stepsAtReset = prefs.getInt('steps_at_reset') ?? 0;

      final lastResetString = prefs.getString('last_reset_date');
      if (lastResetString != null) {
        _lastResetDate = DateTime.parse(lastResetString);
      } else {
        _lastResetDate = DateTime.now();
      }

      // Check if we need to reset for a new day
      _checkForDayChange();
    } catch (e) {
      debugPrint('Error loading step data: $e');
    }
  }

  // Reset the step counter manually
  Future<void> resetSteps() async {
    _stepsAtReset = _steps;
    _caloriesBurned = 0;
    await _saveData();
  }
}
