import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import '../services/step_counter_service.dart';

class StepCounterProvider extends ChangeNotifier {
  final StepCounterService _stepCounterService = StepCounterService();

  bool _isInitialized = false;
  bool _isPermissionGranted = false;
  bool _isLoading = false;

  // Getters
  bool get isInitialized => _isInitialized;
  bool get isPermissionGranted => _isPermissionGranted;
  bool get isLoading => _isLoading;
  int get steps => _stepCounterService.steps;
  int get calories => _stepCounterService.caloriesBurned;
  String get status => _stepCounterService.status;

  // Initialize the provider
  Future<void> init() async {
    if (_isInitialized) return;

    _isLoading = true;
    notifyListeners();

    // Check permissions
    await _checkPermissions();

    if (_isPermissionGranted) {
      // Initialize step counter service
      await _stepCounterService.init();
      _isInitialized = _stepCounterService.isInitialized;
    }

    _isLoading = false;
    notifyListeners();

    // Set up periodic updates to refresh UI
    _setupPeriodicUpdates();
  }

  // Check activity recognition permissions
  Future<void> _checkPermissions() async {
    final status = await Permission.activityRecognition.status;
    _isPermissionGranted = status.isGranted;

    if (!_isPermissionGranted) {
      final result = await Permission.activityRecognition.request();
      _isPermissionGranted = result.isGranted;
    }

    notifyListeners();
  }

  // Request permissions manually
  Future<void> requestPermissions() async {
    final result = await Permission.activityRecognition.request();
    _isPermissionGranted = result.isGranted;

    if (_isPermissionGranted && !_isInitialized) {
      await init();
    }

    notifyListeners();
  }

  // Reset steps manually
  Future<void> resetSteps() async {
    await _stepCounterService.resetSteps();
    notifyListeners();
  }

  // Set up periodic updates to refresh UI
  void _setupPeriodicUpdates() {
    // Update UI every 5 seconds to reflect step changes
    Future.delayed(const Duration(seconds: 5), () {
      if (_isInitialized) {
        notifyListeners();
      }
      _setupPeriodicUpdates();
    });
  }
}
