import 'package:flutter/material.dart';

class RealtimeChallengeModel {
  final String? id;
  final String name;
  final String description;
  final String type;
  final int goal;
  final String goalUnit;
  final int duration; // in days
  final int startDate;
  final bool isActive;
  final int timestamp;

  RealtimeChallengeModel({
    this.id,
    required this.name,
    required this.description,
    required this.type,
    required this.goal,
    required this.goalUnit,
    required this.duration,
    required this.startDate,
    required this.isActive,
    required this.timestamp,
  });

  // Convert from Realtime Database data
  factory RealtimeChallengeModel.fromRealtime(String id, Map<dynamic, dynamic> data) {
    return RealtimeChallengeModel(
      id: id,
      name: data['name'] ?? '',
      description: data['description'] ?? '',
      type: data['type'] ?? '',
      goal: data['goal'] ?? 0,
      goalUnit: data['goalUnit'] ?? '',
      duration: data['duration'] ?? 0,
      startDate: data['startDate'] ?? 0,
      isActive: data['isActive'] ?? false,
      timestamp: data['timestamp'] ?? 0,
    );
  }

  // Convert to Realtime Database data
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'type': type,
      'goal': goal,
      'goalUnit': goalUnit,
      'duration': duration,
      'startDate': startDate,
      'isActive': isActive,
      'timestamp': timestamp,
    };
  }

  // Get icon based on challenge type
  IconData getIcon() {
    switch (type.toLowerCase()) {
      case 'running':
        return Icons.directions_run;
      case 'workout':
        return Icons.fitness_center;
      case 'water':
        return Icons.water_drop;
      case 'yoga':
        return Icons.self_improvement;
      case 'sleep':
        return Icons.nightlight;
      default:
        return Icons.star;
    }
  }

  // Get color based on challenge type
  Color getColor() {
    switch (type.toLowerCase()) {
      case 'running':
        return Colors.orange;
      case 'workout':
        return Colors.blue;
      case 'water':
        return Colors.cyan;
      case 'yoga':
        return Colors.purple;
      case 'sleep':
        return Colors.indigo;
      default:
        return Colors.green;
    }
  }
} 