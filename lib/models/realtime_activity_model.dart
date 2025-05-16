class RealtimeLocationModel {
  final double latitude;
  final double longitude;

  RealtimeLocationModel({
    required this.latitude,
    required this.longitude,
  });

  // Convert from Realtime Database data
  factory RealtimeLocationModel.fromRealtime(Map<dynamic, dynamic> data) {
    return RealtimeLocationModel(
      latitude:
          data['latitude'] != null ? (data['latitude'] as num).toDouble() : 0.0,
      longitude: data['longitude'] != null
          ? (data['longitude'] as num).toDouble()
          : 0.0,
    );
  }

  // Convert to Realtime Database data
  Map<String, dynamic> toMap() {
    return {
      'latitude': latitude,
      'longitude': longitude,
    };
  }
}

class RealtimeActivityModel {
  final String? id;
  final String userId;
  final String type;
  final int duration;
  final double distance;
  final int caloriesBurned;
  final int date;
  final RealtimeLocationModel? location;
  final int heartRateAvg;
  final int heartRateMax;
  final int steps;
  final String mood;
  final String? notes;
  final int timestamp;

  RealtimeActivityModel({
    this.id,
    required this.userId,
    required this.type,
    required this.duration,
    required this.distance,
    required this.caloriesBurned,
    required this.date,
    this.location,
    required this.heartRateAvg,
    required this.heartRateMax,
    required this.steps,
    required this.mood,
    this.notes,
    required this.timestamp,
  });

  // Convert from Realtime Database data
  factory RealtimeActivityModel.fromRealtime(
      String activityId, Map<dynamic, dynamic> data) {
    RealtimeLocationModel? locationData;
    if (data['location'] != null) {
      locationData = RealtimeLocationModel.fromRealtime(
          data['location'] as Map<dynamic, dynamic>);
    }

    return RealtimeActivityModel(
      id: activityId,
      userId: data['userId'] ?? '',
      type: data['type'] ?? '',
      duration: data['duration'] ?? 0,
      distance:
          data['distance'] != null ? (data['distance'] as num).toDouble() : 0.0,
      caloriesBurned: data['caloriesBurned'] ?? 0,
      date: data['date'] ?? 0,
      location: locationData,
      heartRateAvg: data['heartRateAvg'] ?? 0,
      heartRateMax: data['heartRateMax'] ?? 0,
      steps: data['steps'] ?? 0,
      mood: data['mood'] ?? '',
      notes: data['notes'],
      timestamp: data['timestamp'] ?? 0,
    );
  }

  // Convert to Realtime Database data
  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{
      'userId': userId,
      'type': type,
      'duration': duration,
      'distance': distance,
      'caloriesBurned': caloriesBurned,
      'date': date,
      'heartRateAvg': heartRateAvg,
      'heartRateMax': heartRateMax,
      'steps': steps,
      'mood': mood,
    };

    if (location != null) {
      map['location'] = location!.toMap();
    }

    if (notes != null) {
      map['notes'] = notes;
    }

    return map;
  }
}
