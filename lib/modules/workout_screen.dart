import 'package:flutter/material.dart';
import 'package:tracker/shared/components/components.dart';
import 'package:tracker/layout/main_app_layout.dart';
import 'package:tracker/models/realtime_workout_model.dart';
import 'package:tracker/shared/network/remote/realtime_database_service.dart';
import 'package:tracker/modules/workout_detail_screen.dart';
import 'package:intl/intl.dart';

class WorkoutScreen extends StatefulWidget {
  const WorkoutScreen({Key? key}) : super(key: key);

  @override
  State<WorkoutScreen> createState() => _WorkoutScreenState();
}

class _WorkoutScreenState extends State<WorkoutScreen> {
  int selectedIndex = 2; // Heart icon selected - updated index
  final RealtimeDatabaseService _databaseService = RealtimeDatabaseService();
  List<RealtimeWorkoutModel> _availableWorkouts = [];
  List<RealtimeWorkoutModel> _completedWorkouts = [];
  bool _isLoading = true;
  String _userId = 'current_user_id'; // Replace with actual user ID retrieval

  @override
  void initState() {
    super.initState();
    _loadWorkouts();
  }

  Future<void> _loadWorkouts() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Load both available and completed workouts
      final availableWorkouts =
          await _databaseService.getAvailableWorkoutsForUser(_userId);
      final completedWorkouts =
          await _databaseService.getUserCompletedWorkouts(_userId);

      if (mounted) {
        setState(() {
          _availableWorkouts = availableWorkouts;
          _completedWorkouts = completedWorkouts;
          _isLoading = false;
        });
      }
    } catch (e) {
      print('Error loading workouts: $e');
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  String _formatDate(int timestamp) {
    final date = DateTime.fromMillisecondsSinceEpoch(timestamp);
    return DateFormat('MMM dd, yyyy').format(date);
  }

  @override
  Widget build(BuildContext context) {
    return MainAppLayout(
      title: 'Workouts',
      time: '9:41',
      selectedIndex: selectedIndex,
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadWorkouts,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const WorkoutTopCard(),
                    const SizedBox(height: 30),
                    const Text(
                      'Available Workouts',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildAvailableWorkoutsList(),
                    const SizedBox(height: 30),
                    const Text(
                      'Your Workout Progress',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildCompletedWorkoutsList(),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
      onIndexChanged: (index) {
        setState(() {
          selectedIndex = index;
        });
      },
    );
  }

  Widget _buildAvailableWorkoutsList() {
    if (_availableWorkouts.isEmpty) {
      return Center(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'No available workouts',
                style: TextStyle(fontSize: 16),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                setState(() {
                  _isLoading = true;
                });
                try {
                  await _databaseService.createSampleWorkouts();
                  await _loadWorkouts();
                } catch (e) {
                  print('Error creating sample workouts: $e');
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Error: $e')),
                    );
                    setState(() {
                      _isLoading = false;
                    });
                  }
                }
              },
              child: const Text('Create Sample Workouts'),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _availableWorkouts.length,
      itemBuilder: (context, index) {
        final workout = _availableWorkouts[index];
        return _buildWorkoutCard(workout, false);
      },
    );
  }

  Widget _buildCompletedWorkoutsList() {
    if (_completedWorkouts.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Text(
            'No completed workouts yet',
            style: TextStyle(fontSize: 16),
          ),
        ),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _completedWorkouts.length,
      itemBuilder: (context, index) {
        final workout = _completedWorkouts[index];
        return _buildWorkoutCard(workout, true);
      },
    );
  }

  Widget _buildWorkoutCard(RealtimeWorkoutModel workout, bool isCompleted) {
    return GestureDetector(
      onTap: isCompleted
          ? null
          : () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => WorkoutDetailScreen(
                    workout: workout,
                    userId: _userId,
                  ),
                ),
              );

              // If workout was completed, refresh the lists
              if (result == true) {
                _loadWorkouts();
              }
            },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
          border:
              isCompleted ? Border.all(color: Colors.green, width: 2) : null,
        ),
        child: Row(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: isCompleted
                    ? Colors.green.withOpacity(0.1)
                    : Colors.blue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                isCompleted ? Icons.check_circle : Icons.fitness_center,
                color: isCompleted ? Colors.green : Colors.blue,
                size: 30,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    workout.name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Type: ${workout.type}',
                    style: TextStyle(
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    isCompleted
                        ? 'Completed on: ${_formatDate(workout.date)}'
                        : '${workout.exercises.length} exercises • ${workout.duration} min',
                    style: TextStyle(
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
            if (!isCompleted)
              const Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: Colors.grey,
              ),
          ],
        ),
      ),
    );
  }
}
