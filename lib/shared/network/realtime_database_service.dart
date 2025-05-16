import 'package:firebase_database/firebase_database.dart';
import '../../models/realtime_user_model.dart';
import '../../models/realtime_workout_model.dart';
import '../../models/realtime_activity_model.dart';
import '../../models/realtime_weight_record_model.dart';

class RealtimeDatabaseService {
  final DatabaseReference _database = FirebaseDatabase.instance.ref();

  // Initialize the database references
  Future<void> initializeDatabase() async {
    try {
      // Check if we can connect to the database
      await _database.get();
      print('Realtime Database connected successfully');

      // Create main data nodes if they don't exist
      await _createNodeIfNotExists('users');
      await _createNodeIfNotExists('workouts');
      await _createNodeIfNotExists('activities');
      await _createNodeIfNotExists('weight_records');
      await _createNodeIfNotExists('challenges');
      await _createNodeIfNotExists('motivation');
      await _createNodeIfNotExists('settings');
      await _createNodeIfNotExists('goals');
      await _createNodeIfNotExists('progress');
      await _createNodeIfNotExists('notifications');

      print('Realtime Database nodes initialized successfully');
    } catch (e) {
      print('Error initializing Realtime Database: $e');
    }
  }

  // Create a node if it doesn't exist
  Future<void> _createNodeIfNotExists(String nodePath) async {
    try {
      final snapshot = await _database.child(nodePath).get();
      if (!snapshot.exists) {
        await _database.child(nodePath).set({
          'initialized': true,
          'timestamp': ServerValue.timestamp,
        });
        print('Created node: $nodePath');
      }
    } catch (e) {
      print('Error creating node $nodePath: $e');
    }
  }

  // === USER OPERATIONS ===

  // Create user
  Future<void> createUser(String userId, RealtimeUserModel user) async {
    try {
      await _database.child('users/$userId').set({
        ...user.toMap(),
        'lastUpdated': ServerValue.timestamp,
      });
      print('Created user with ID: $userId');
      return;
    } catch (e) {
      print('Error creating user: $e');
      throw e;
    }
  }

  // Read user
  Future<RealtimeUserModel?> getUser(String userId) async {
    try {
      final snapshot = await _database.child('users/$userId').get();
      if (snapshot.exists) {
        return RealtimeUserModel.fromRealtime(
            userId, snapshot.value as Map<dynamic, dynamic>);
      }
      return null;
    } catch (e) {
      print('Error getting user: $e');
      throw e;
    }
  }

  // Update user
  Future<void> updateUser(String userId, Map<String, dynamic> userData) async {
    try {
      await _database.child('users/$userId').update({
        ...userData,
        'lastUpdated': ServerValue.timestamp,
      });
      print('Updated user with ID: $userId');
      return;
    } catch (e) {
      print('Error updating user: $e');
      throw e;
    }
  }

  // Delete user
  Future<void> deleteUser(String userId) async {
    try {
      await _database.child('users/$userId').remove();
      print('Deleted user with ID: $userId');
      return;
    } catch (e) {
      print('Error deleting user: $e');
      throw e;
    }
  }

  // List all users
  Future<List<RealtimeUserModel>> getAllUsers() async {
    try {
      final snapshot = await _database.child('users').get();
      if (snapshot.exists) {
        final usersMap = snapshot.value as Map<dynamic, dynamic>;
        return usersMap.entries.map((entry) {
          return RealtimeUserModel.fromRealtime(
              entry.key.toString(), entry.value as Map<dynamic, dynamic>);
        }).toList();
      }
      return [];
    } catch (e) {
      print('Error getting all users: $e');
      return [];
    }
  }

  // === WORKOUT OPERATIONS ===

  // Create workout
  Future<String?> createWorkout(RealtimeWorkoutModel workout) async {
    try {
      final newWorkoutRef = _database.child('workouts').push();
      await newWorkoutRef.set({
        ...workout.toMap(),
        'timestamp': ServerValue.timestamp,
      });
      print('Created workout with ID: ${newWorkoutRef.key}');
      return newWorkoutRef.key;
    } catch (e) {
      print('Error creating workout: $e');
      throw e;
    }
  }

  // Read workout
  Future<RealtimeWorkoutModel?> getWorkout(String workoutId) async {
    try {
      final snapshot = await _database.child('workouts/$workoutId').get();
      if (snapshot.exists) {
        return RealtimeWorkoutModel.fromRealtime(
            workoutId, snapshot.value as Map<dynamic, dynamic>);
      }
      return null;
    } catch (e) {
      print('Error getting workout: $e');
      throw e;
    }
  }

  // Update workout
  Future<void> updateWorkout(
      String workoutId, Map<String, dynamic> workoutData) async {
    try {
      await _database.child('workouts/$workoutId').update({
        ...workoutData,
        'timestamp': ServerValue.timestamp,
      });
      print('Updated workout with ID: $workoutId');
      return;
    } catch (e) {
      print('Error updating workout: $e');
      throw e;
    }
  }

  // Delete workout
  Future<void> deleteWorkout(String workoutId) async {
    try {
      await _database.child('workouts/$workoutId').remove();
      print('Deleted workout with ID: $workoutId');
      return;
    } catch (e) {
      print('Error deleting workout: $e');
      throw e;
    }
  }

  // Get user workouts
  Future<List<RealtimeWorkoutModel>> getUserWorkouts(String userId) async {
    try {
      final snapshot = await _database
          .child('workouts')
          .orderByChild('userId')
          .equalTo(userId)
          .get();

      if (snapshot.exists) {
        final workoutsMap = snapshot.value as Map<dynamic, dynamic>;
        return workoutsMap.entries.map((entry) {
          return RealtimeWorkoutModel.fromRealtime(
              entry.key.toString(), entry.value as Map<dynamic, dynamic>);
        }).toList();
      }
      return [];
    } catch (e) {
      print('Error getting user workouts: $e');
      return [];
    }
  }

  // === ACTIVITY OPERATIONS ===

  // Create activity
  Future<String?> createActivity(RealtimeActivityModel activity) async {
    try {
      final newActivityRef = _database.child('activities').push();
      await newActivityRef.set({
        ...activity.toMap(),
        'timestamp': ServerValue.timestamp,
      });
      print('Created activity with ID: ${newActivityRef.key}');
      return newActivityRef.key;
    } catch (e) {
      print('Error creating activity: $e');
      throw e;
    }
  }

  // Read activity
  Future<RealtimeActivityModel?> getActivity(String activityId) async {
    try {
      final snapshot = await _database.child('activities/$activityId').get();
      if (snapshot.exists) {
        return RealtimeActivityModel.fromRealtime(
            activityId, snapshot.value as Map<dynamic, dynamic>);
      }
      return null;
    } catch (e) {
      print('Error getting activity: $e');
      throw e;
    }
  }

  // Update activity
  Future<void> updateActivity(
      String activityId, Map<String, dynamic> activityData) async {
    try {
      await _database.child('activities/$activityId').update({
        ...activityData,
        'timestamp': ServerValue.timestamp,
      });
      print('Updated activity with ID: $activityId');
      return;
    } catch (e) {
      print('Error updating activity: $e');
      throw e;
    }
  }

  // Delete activity
  Future<void> deleteActivity(String activityId) async {
    try {
      await _database.child('activities/$activityId').remove();
      print('Deleted activity with ID: $activityId');
      return;
    } catch (e) {
      print('Error deleting activity: $e');
      throw e;
    }
  }

  // Get user activities
  Future<List<RealtimeActivityModel>> getUserActivities(String userId) async {
    try {
      final snapshot = await _database
          .child('activities')
          .orderByChild('userId')
          .equalTo(userId)
          .get();

      if (snapshot.exists) {
        final activitiesMap = snapshot.value as Map<dynamic, dynamic>;
        return activitiesMap.entries.map((entry) {
          return RealtimeActivityModel.fromRealtime(
              entry.key.toString(), entry.value as Map<dynamic, dynamic>);
        }).toList();
      }
      return [];
    } catch (e) {
      print('Error getting user activities: $e');
      return [];
    }
  }

  // === WEIGHT RECORD OPERATIONS ===

  // Create weight record
  Future<String?> createWeightRecord(RealtimeWeightRecordModel record) async {
    try {
      final newRecordRef = _database.child('weight_records').push();
      await newRecordRef.set({
        ...record.toMap(),
        'timestamp': ServerValue.timestamp,
      });
      print('Created weight record with ID: ${newRecordRef.key}');
      return newRecordRef.key;
    } catch (e) {
      print('Error creating weight record: $e');
      throw e;
    }
  }

  // Read weight record
  Future<RealtimeWeightRecordModel?> getWeightRecord(String recordId) async {
    try {
      final snapshot = await _database.child('weight_records/$recordId').get();
      if (snapshot.exists) {
        return RealtimeWeightRecordModel.fromRealtime(
            recordId, snapshot.value as Map<dynamic, dynamic>);
      }
      return null;
    } catch (e) {
      print('Error getting weight record: $e');
      throw e;
    }
  }

  // Update weight record
  Future<void> updateWeightRecord(
      String recordId, Map<String, dynamic> recordData) async {
    try {
      await _database.child('weight_records/$recordId').update({
        ...recordData,
        'timestamp': ServerValue.timestamp,
      });
      print('Updated weight record with ID: $recordId');
      return;
    } catch (e) {
      print('Error updating weight record: $e');
      throw e;
    }
  }

  // Delete weight record
  Future<void> deleteWeightRecord(String recordId) async {
    try {
      await _database.child('weight_records/$recordId').remove();
      print('Deleted weight record with ID: $recordId');
      return;
    } catch (e) {
      print('Error deleting weight record: $e');
      throw e;
    }
  }

  // Get user weight records
  Future<List<RealtimeWeightRecordModel>> getUserWeightRecords(
      String userId) async {
    try {
      final snapshot = await _database
          .child('weight_records')
          .orderByChild('userId')
          .equalTo(userId)
          .get();

      if (snapshot.exists) {
        final recordsMap = snapshot.value as Map<dynamic, dynamic>;
        return recordsMap.entries.map((entry) {
          return RealtimeWeightRecordModel.fromRealtime(
              entry.key.toString(), entry.value as Map<dynamic, dynamic>);
        }).toList();
      }
      return [];
    } catch (e) {
      print('Error getting user weight records: $e');
      return [];
    }
  }

  // === GOALS OPERATIONS ===

  Future<String?> createGoal(
      String userId, Map<String, dynamic> goalData) async {
    try {
      final newGoalRef = _database.child('goals').push();
      await newGoalRef.set({
        ...goalData,
        'userId': userId,
        'timestamp': ServerValue.timestamp,
        'completed': false,
      });
      print('Created goal with ID: ${newGoalRef.key}');
      return newGoalRef.key;
    } catch (e) {
      print('Error creating goal: $e');
      throw e;
    }
  }

  Future<List<Map<String, dynamic>>> getUserGoals(String userId) async {
    try {
      final snapshot = await _database
          .child('goals')
          .orderByChild('userId')
          .equalTo(userId)
          .get();

      if (snapshot.exists) {
        List<Map<String, dynamic>> goals = [];
        Map<dynamic, dynamic> goalsMap = snapshot.value as Map;
        goalsMap.forEach((key, value) {
          goals.add({
            'id': key,
            ...Map<String, dynamic>.from(value as Map),
          });
        });
        return goals;
      }
      return [];
    } catch (e) {
      print('Error getting user goals: $e');
      return [];
    }
  }

  // === SETTINGS OPERATIONS ===

  Future<void> updateUserSettings(
      String userId, Map<String, dynamic> settings) async {
    try {
      await _database.child('settings/$userId').update({
        ...settings,
        'timestamp': ServerValue.timestamp,
      });
      print('Updated settings for user: $userId');
    } catch (e) {
      print('Error updating settings: $e');
      throw e;
    }
  }

  Future<Map<String, dynamic>?> getUserSettings(String userId) async {
    try {
      final snapshot = await _database.child('settings/$userId').get();
      if (snapshot.exists) {
        return Map<String, dynamic>.from(snapshot.value as Map);
      }
      return null;
    } catch (e) {
      print('Error getting user settings: $e');
      return null;
    }
  }

  // === REAL-TIME LISTENERS ===

  // Listen to user changes
  Stream<DatabaseEvent> getUserStream(String userId) {
    return _database.child('users/$userId').onValue;
  }

  // Listen to user workouts
  Stream<DatabaseEvent> getUserWorkoutsStream(String userId) {
    return _database
        .child('workouts')
        .orderByChild('userId')
        .equalTo(userId)
        .onValue;
  }

  // Listen to user activities
  Stream<DatabaseEvent> getUserActivitiesStream(String userId) {
    return _database
        .child('activities')
        .orderByChild('userId')
        .equalTo(userId)
        .onValue;
  }

  // Listen to user weight records
  Stream<DatabaseEvent> getUserWeightRecordsStream(String userId) {
    return _database
        .child('weight_records')
        .orderByChild('userId')
        .equalTo(userId)
        .onValue;
  }

  // Listen to user goals
  Stream<DatabaseEvent> getUserGoalsStream(String userId) {
    return _database
        .child('goals')
        .orderByChild('userId')
        .equalTo(userId)
        .onValue;
  }
}
