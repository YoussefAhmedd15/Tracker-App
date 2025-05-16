import 'package:tracker/models/realtime_activity_model.dart';
import 'package:tracker/models/realtime_user_model.dart';
import 'package:tracker/models/realtime_weight_record_model.dart';
import 'package:tracker/models/realtime_workout_model.dart';
import 'package:tracker/shared/network/realtime_database_service.dart';

class RealtimeDataCreator {
  final RealtimeDatabaseService _databaseService = RealtimeDatabaseService();

  Future<void> createSampleData() async {
    try {
      // Initialize the database
      await _databaseService.initializeDatabase();

      // Create a sample user
      final sampleUserId = '123';
      await _createSampleUser(sampleUserId);

      // Create sample workouts
      await _createSampleWorkouts(sampleUserId);

      // Create sample activities
      await _createSampleActivities(sampleUserId);

      // Create sample weight records
      await _createSampleWeightRecords(sampleUserId);

      // Create sample goals
      await _createSampleGoals(sampleUserId);

      // Create sample settings
      await _createSampleSettings(sampleUserId);

      print('Sample data created successfully');
    } catch (e) {
      print('Error creating sample data: $e');
    }
  }

  Future<void> _createSampleUser(String userId) async {
    final sampleUser = RealtimeUserModel(
      id: userId,
      email: 'user@example.com',
      age: 28,
      fullName: 'John Doe',
      gender: 'male',
      height: 180,
      nickname: 'Johnny',
      profileImage: '',
      weight: 75,
      lastUpdated: DateTime.now().millisecondsSinceEpoch,
    );

    await _databaseService.createUser(userId, sampleUser);
  }

  Future<void> _createSampleWorkouts(String userId) async {
    // We need to check the RealtimeWorkoutModel to make proper objects
    for (var i = 0; i < 3; i++) {
      final workout = RealtimeWorkoutModel(
        id: null,
        userId: userId,
        name: i == 0
            ? 'Morning Cardio'
            : i == 1
                ? 'Upper Body Strength'
                : 'Lower Body Focus',
        type: i == 0
            ? 'Cardio'
            : i == 1
                ? 'Strength'
                : 'Strength',
        duration: i == 0
            ? 1800
            : // 30 minutes in seconds
            i == 1
                ? 2700
                : 3600, // 45 or 60 minutes
        caloriesBurned: i == 0
            ? 320
            : i == 1
                ? 450
                : 520,
        date: _daysAgo(i * 2).millisecondsSinceEpoch,
        exercises: [], // We'll need to create proper exercise objects based on the model
        timestamp: DateTime.now().millisecondsSinceEpoch,
      );

      await _databaseService.createWorkout(workout);
    }
  }

  Future<void> _createSampleActivities(String userId) async {
    final activityTypes = ['Running', 'Cycling', 'Swimming', 'Walking'];
    final durations = [1800, 3600, 2400, 2700]; // in seconds
    final distances = [5.2, 18.5, 1.5, 3.8]; // in km
    final calories = [450, 680, 520, 280];
    final days = [1, 3, 6, 8];
    final heartRateAvgs = [145, 135, 130, 110];
    final heartRateMaxs = [175, 160, 150, 125];
    final steps = [6500, 0, 0, 5200];
    final moods = ['Energized', 'Happy', 'Relaxed', 'Peaceful'];
    final notes = [
      'Great morning run, felt strong today!',
      'Beautiful day for a ride along the river',
      'Pool was quiet today, focused on technique',
      'Evening walk to clear my mind'
    ];

    for (var i = 0; i < activityTypes.length; i++) {
      final activity = RealtimeActivityModel(
        id: null,
        userId: userId,
        type: activityTypes[i],
        duration: durations[i],
        distance: distances[i],
        caloriesBurned: calories[i],
        date: _daysAgo(days[i]).millisecondsSinceEpoch,
        heartRateAvg: heartRateAvgs[i],
        heartRateMax: heartRateMaxs[i],
        steps: steps[i],
        mood: moods[i],
        notes: notes[i],
        timestamp: DateTime.now().millisecondsSinceEpoch,
      );

      await _databaseService.createActivity(activity);
    }
  }

  Future<void> _createSampleWeightRecords(String userId) async {
    final weights = [76.2, 75.8, 75.5, 75.3, 75.0, 74.8, 74.5];
    final days = [30, 25, 20, 15, 10, 5, 0];

    for (var i = 0; i < weights.length; i++) {
      final record = RealtimeWeightRecordModel(
        id: null,
        userId: userId,
        weight: weights[i],
        date: _daysAgo(days[i]).millisecondsSinceEpoch,
        timestamp: DateTime.now().millisecondsSinceEpoch,
      );

      await _databaseService.createWeightRecord(record);
    }
  }

  Future<void> _createSampleGoals(String userId) async {
    final goals = [
      {
        'title': 'Lose 5kg',
        'description': 'Reach target weight of 70kg',
        'targetDate': _daysAhead(60).millisecondsSinceEpoch,
        'completed': false,
        'type': 'weight',
        'targetValue': 70,
      },
      {
        'title': 'Run 10km',
        'description': 'Complete a 10km run without stopping',
        'targetDate': _daysAhead(45).millisecondsSinceEpoch,
        'completed': false,
        'type': 'distance',
        'targetValue': 10,
      },
      {
        'title': 'Workout 4x/week',
        'description': 'Maintain a consistent workout schedule',
        'targetDate': _daysAhead(30).millisecondsSinceEpoch,
        'completed': false,
        'type': 'frequency',
        'targetValue': 4,
      },
    ];

    for (var goal in goals) {
      await _databaseService.createGoal(userId, goal);
    }
  }

  Future<void> _createSampleSettings(String userId) async {
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

  DateTime _daysAgo(int days) {
    return DateTime.now().subtract(Duration(days: days));
  }

  DateTime _daysAhead(int days) {
    return DateTime.now().add(Duration(days: days));
  }
}
