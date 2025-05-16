class RealtimeExerciseModel {
  final String name;
  final int sets;
  final int reps;
  final double? weight;

  RealtimeExerciseModel({
    required this.name,
    required this.sets,
    required this.reps,
    this.weight,
  });

  // Convert from Realtime Database data
  factory RealtimeExerciseModel.fromRealtime(Map<dynamic, dynamic> data) {
    return RealtimeExerciseModel(
      name: data['name'] ?? '',
      sets: data['sets'] ?? 0,
      reps: data['reps'] ?? 0,
      weight:
          data['weight'] != null ? (data['weight'] as num).toDouble() : null,
    );
  }

  // Convert to Realtime Database data
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'sets': sets,
      'reps': reps,
      'weight': weight,
    };
  }
}

class RealtimeWorkoutModel {
  final String? id;
  final String userId;
  final String name;
  final String type;
  final int duration;
  final int caloriesBurned;
  final int date;
  final List<RealtimeExerciseModel> exercises;
  final int timestamp;

  RealtimeWorkoutModel({
    this.id,
    required this.userId,
    required this.name,
    required this.type,
    required this.duration,
    required this.caloriesBurned,
    required this.date,
    required this.exercises,
    required this.timestamp,
  });

  // Convert from Realtime Database data
  factory RealtimeWorkoutModel.fromRealtime(
      String workoutId, Map<dynamic, dynamic> data) {
    List<RealtimeExerciseModel> exercisesList = [];

    if (data['exercises'] != null) {
      final exercises = data['exercises'] as List<dynamic>;
      exercisesList = exercises
          .map((exercise) => RealtimeExerciseModel.fromRealtime(exercise))
          .toList();
    }

    return RealtimeWorkoutModel(
      id: workoutId,
      userId: data['userId'] ?? '',
      name: data['name'] ?? '',
      type: data['type'] ?? '',
      duration: data['duration'] ?? 0,
      caloriesBurned: data['caloriesBurned'] ?? 0,
      date: data['date'] ?? 0,
      exercises: exercisesList,
      timestamp: data['timestamp'] ?? 0,
    );
  }

  // Convert to Realtime Database data
  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'name': name,
      'type': type,
      'duration': duration,
      'caloriesBurned': caloriesBurned,
      'date': date,
      'exercises': exercises.map((exercise) => exercise.toMap()).toList(),
      // timestamp is added automatically by the database service
    };
  }
}
