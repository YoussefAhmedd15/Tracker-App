import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:tracker/models/realtime_activity_model.dart';
import 'package:tracker/models/realtime_user_model.dart';
import 'package:tracker/models/realtime_weight_record_model.dart';
import 'package:tracker/models/realtime_workout_model.dart';
import 'package:tracker/modules/login_page.dart';
import 'package:tracker/modules/motivation.dart';
import 'package:tracker/modules/settings.dart';
import 'package:tracker/shared/providers/language_provider.dart';
import 'package:tracker/shared/providers/step_counter_provider.dart';
import 'firebase_options.dart';
import 'shared/network/remote/realtime_database_service.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    // Configure Firebase Realtime Database
    FirebaseDatabase.instance.databaseURL =
        'https://tracker-app-fbc43-default-rtdb.firebaseio.com/';

    // Initialize Realtime Database
    final realtimeDatabaseService = RealtimeDatabaseService();
    await realtimeDatabaseService.initializeDatabase();

    print('Firebase initialized successfully');
  } catch (e) {
    print('Error initializing Firebase: $e');
  }

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => LanguageProvider()),
        ChangeNotifierProvider(create: (context) => StepCounterProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<LanguageProvider>(
      builder: (context, languageProvider, child) {
        return MaterialApp(
          title: 'Tracker App',
          theme: ThemeData(
            scaffoldBackgroundColor: Colors.white,
            primaryColor: Colors.black,
            fontFamily: 'SF Pro Display',
            useMaterial3: true,
          ),
          locale: languageProvider.currentLocale,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('en'), // English
            Locale('ar'), // Arabic
            Locale('es'), // Spanish
            Locale('tr'), // Turkish
            Locale('pt'), // Portuguese
          ],
          home: const LoginPage(),
          debugShowCheckedModeBanner: false,
        );
      },
    );
  }
}

// Helper function for sample data creation
Future<void> createSampleData() async {
  final databaseService = RealtimeDatabaseService();
  final userId = "123"; // Sample user ID

  try {
    // Create sample user
    final user = RealtimeUserModel(
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

    await databaseService.createUser(userId, user);
    print('Sample user created');

    // Create a sample workout with proper exercise models
    final workout = RealtimeWorkoutModel(
      id: null,
      userId: userId,
      name: 'Morning Cardio',
      type: 'Cardio',
      duration: 1800, // 30 minutes in seconds
      caloriesBurned: 320,
      date: DateTime.now().millisecondsSinceEpoch,
      exercises: [
        RealtimeExerciseModel(
          name: 'Running',
          sets: 1,
          reps: 1,
          weight: null,
        ),
        RealtimeExerciseModel(
          name: 'Jumping Jacks',
          sets: 3,
          reps: 20,
          weight: null,
        ),
        RealtimeExerciseModel(
          name: 'Mountain Climbers',
          sets: 3,
          reps: 15,
          weight: null,
        ),
      ],
      timestamp: DateTime.now().millisecondsSinceEpoch,
    );

    await databaseService.createWorkout(workout);
    print('Sample workout created');

    // Create a sample activity
    final activity = RealtimeActivityModel(
      id: null,
      userId: userId,
      type: 'Running',
      duration: 1800, // 30 minutes in seconds
      distance: 5.2,
      caloriesBurned: 450,
      date: DateTime.now().millisecondsSinceEpoch,
      heartRateAvg: 145,
      heartRateMax: 175,
      steps: 6500,
      mood: 'Energized',
      notes: 'Great morning run, felt strong today!',
      timestamp: DateTime.now().millisecondsSinceEpoch,
    );

    await databaseService.createActivity(activity);
    print('Sample activity created');

    // Create a sample weight record
    final weightRecord = RealtimeWeightRecordModel(
      id: null,
      userId: userId,
      weight: 75.5,
      date: DateTime.now().millisecondsSinceEpoch,
      timestamp: DateTime.now().millisecondsSinceEpoch,
    );

    await databaseService.createWeightRecord(weightRecord);
    print('Sample weight record created');

    // Create sample goals
    final goals = [
      {
        'title': 'Lose 5kg',
        'description': 'Reach target weight of 70kg',
        'targetDate':
            DateTime.now().add(const Duration(days: 60)).millisecondsSinceEpoch,
        'completed': false,
        'type': 'weight',
        'targetValue': 70,
      },
      {
        'title': 'Run 10km',
        'description': 'Complete a 10km run without stopping',
        'targetDate':
            DateTime.now().add(const Duration(days: 30)).millisecondsSinceEpoch,
        'completed': false,
        'type': 'distance',
        'targetValue': 10,
      },
    ];

    for (var goal in goals) {
      await databaseService.createGoal(userId, goal);
    }
    print('Sample goals created');

    // Create sample settings
    final settings = {
      'weightUnit': 'kg',
      'heightUnit': 'cm',
      'distanceUnit': 'km',
      'darkMode': false,
      'notificationsEnabled': true,
      'reminderTime': '07:00',
      'language': 'en',
    };

    await databaseService.updateUserSettings(userId, settings);
    print('Sample settings created');

    print('All sample data created successfully');
  } catch (e) {
    print('Error creating sample data: $e');
  }
}
