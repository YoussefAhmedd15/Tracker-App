import 'package:flutter/material.dart';
import 'package:tracker/models/realtime_user_model.dart';
import 'package:tracker/shared/network/remote/realtime_database_service.dart';
import 'package:firebase_database/firebase_database.dart';

class UserService {
  final RealtimeDatabaseService _databaseService = RealtimeDatabaseService();

  // Generate a unique user ID
  String _generateUserId() {
    return 'user_${DateTime.now().millisecondsSinceEpoch}';
  }

  // Login user with email and password
  Future<RealtimeUserModel?> loginUser({
    required String email,
    required String password,
  }) async {
    try {
      // Get users by email
      final snapshot = await FirebaseDatabase.instance
          .ref()
          .child('users')
          .orderByChild('email')
          .equalTo(email)
          .get();

      if (!snapshot.exists) {
        // No user found with this email
        return null;
      }

      // Find the user with matching password
      final usersMap = snapshot.value as Map<dynamic, dynamic>;
      for (final entry in usersMap.entries) {
        final userData = entry.value as Map<dynamic, dynamic>;
        final userId = entry.key.toString();

        if (userData['password'] == password) {
          return RealtimeUserModel.fromRealtime(userId, userData);
        }
      }

      // Password doesn't match
      return null;
    } catch (e) {
      debugPrint('Error logging in: $e');
      throw Exception('Failed to login: $e');
    }
  }

  // Register a new user
  Future<String> registerUser({
    required String email,
    String? password,
    required String fullName,
    required int age,
    required String gender,
    required int height,
    required int weight,
    String nickname = '',
    String profileImage = '',
  }) async {
    try {
      final userId = _generateUserId();

      final user = RealtimeUserModel(
        id: userId,
        email: email,
        password: password, // In a real app, this should be handled securely
        age: age,
        fullName: fullName,
        gender: gender,
        height: height,
        nickname: nickname.isEmpty ? fullName.split(' ').first : nickname,
        profileImage: profileImage,
        weight: weight,
        lastUpdated: DateTime.now().millisecondsSinceEpoch,
      );

      await _databaseService.createUser(userId, user);

      // Create default settings
      await _createDefaultSettings(userId);

      return userId;
    } catch (e) {
      debugPrint('Error registering user: $e');
      throw Exception('Failed to register user: $e');
    }
  }

  // Create default settings for a new user
  Future<void> _createDefaultSettings(String userId) async {
    final settings = {
      'weightUnit': 'kg',
      'heightUnit': 'cm',
      'distanceUnit': 'km',
      'darkMode': false,
      'notificationsEnabled': true,
      'reminderTime': '07:00',
      'weeklyGoal': 4,
    };

    await _databaseService.updateUserSettings(userId, settings);
  }

  // Get user by ID
  Future<RealtimeUserModel?> getUser(String userId) async {
    return await _databaseService.getUser(userId);
  }

  // Update user data
  Future<void> updateUser(String userId, Map<String, dynamic> userData) async {
    await _databaseService.updateUser(userId, userData);
  }
}
