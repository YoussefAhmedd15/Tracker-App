import 'package:flutter/material.dart';
import 'package:tracker/models/realtime_workout_model.dart';
import 'package:tracker/shared/components/components.dart';
import 'package:tracker/shared/styles/colors.dart';
import 'package:tracker/shared/network/remote/realtime_database_service.dart';

class WorkoutDetailScreen extends StatefulWidget {
  final RealtimeWorkoutModel workout;
  final String userId;

  const WorkoutDetailScreen({
    Key? key,
    required this.workout,
    required this.userId,
  }) : super(key: key);

  @override
  State<WorkoutDetailScreen> createState() => _WorkoutDetailScreenState();
}

class _WorkoutDetailScreenState extends State<WorkoutDetailScreen> {
  final RealtimeDatabaseService _databaseService = RealtimeDatabaseService();
  final List<bool> _completedExercises = [];
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _completedExercises.addAll(
      List.generate(widget.workout.exercises.length, (_) => false),
    );
  }

  Future<void> _submitWorkoutProgress() async {
    if (_completedExercises.contains(false)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please complete all exercises before submitting'),
        ),
      );
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      // Create workout progress object
      final workoutProgress = RealtimeWorkoutModel(
        userId: widget.userId,
        name: widget.workout.name,
        type: widget.workout.type,
        duration: widget.workout.duration,
        caloriesBurned: widget.workout.caloriesBurned,
        date: DateTime.now().millisecondsSinceEpoch,
        exercises: widget.workout.exercises,
        timestamp: DateTime.now().millisecondsSinceEpoch,
      );

      // Submit workout progress
      await _databaseService.saveWorkoutProgress(workoutProgress);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Workout completed successfully!'),
            backgroundColor: Colors.green,
          ),
        );

        // Navigate back with success result
        Navigator.pop(context, true);
      }
    } catch (e) {
      print('Error submitting workout progress: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: widget.workout.name,
        showBackButton: true,
        time: '9:41',
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildWorkoutHeader(),
                  const SizedBox(height: 24),
                  _buildExercisesList(),
                ],
              ),
            ),
          ),
          _buildBottomButton(),
        ],
      ),
    );
  }

  Widget _buildWorkoutHeader() {
    return Container(
      padding: const EdgeInsets.all(16.0),
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
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.fitness_center,
                  color: Colors.blue,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.workout.type,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.blue,
                      ),
                    ),
                    Text(
                      widget.workout.name,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildInfoChip(
                Icons.timer,
                '${widget.workout.duration} min',
                Colors.orange,
              ),
              _buildInfoChip(
                Icons.local_fire_department,
                '${widget.workout.caloriesBurned} cal',
                Colors.red,
              ),
              _buildInfoChip(
                Icons.fitness_center,
                '${widget.workout.exercises.length} exercises',
                Colors.purple,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 16),
          const SizedBox(width: 6),
          Text(
            text,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExercisesList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Exercises',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: widget.workout.exercises.length,
          itemBuilder: (context, index) {
            final exercise = widget.workout.exercises[index];
            return _buildExerciseCard(exercise, index);
          },
        ),
      ],
    );
  }

  Widget _buildExerciseCard(RealtimeExerciseModel exercise, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color:
              _completedExercises[index] ? Colors.green : Colors.grey.shade200,
          width: 2,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  exercise.name,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Checkbox(
                value: _completedExercises[index],
                onChanged: (value) {
                  setState(() {
                    _completedExercises[index] = value!;
                  });
                },
                activeColor: Colors.green,
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _buildExerciseDetail(
                'Sets',
                '${exercise.sets}',
              ),
              const SizedBox(width: 16),
              _buildExerciseDetail(
                'Reps',
                '${exercise.reps}',
              ),
              const SizedBox(width: 16),
              if (exercise.weight != null)
                _buildExerciseDetail(
                  'Weight',
                  '${exercise.weight} kg',
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildExerciseDetail(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey.shade600,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildBottomButton() {
    final allCompleted = !_completedExercises.contains(false);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        child: SizedBox(
          width: double.infinity,
          height: 55,
          child: ElevatedButton(
            onPressed: _isSubmitting ? null : _submitWorkoutProgress,
            style: ElevatedButton.styleFrom(
              backgroundColor:
                  allCompleted ? AppColors.buttonBackground : Colors.grey,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: _isSubmitting
                ? const CircularProgressIndicator(color: Colors.white)
                : Text(
                    allCompleted
                        ? 'Complete Workout'
                        : 'Complete All Exercises',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}
