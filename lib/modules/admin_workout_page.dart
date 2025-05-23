import 'package:flutter/material.dart';
import 'package:tracker/models/realtime_workout_model.dart';
import 'package:tracker/shared/network/remote/realtime_database_service.dart';
import 'package:tracker/shared/components/components.dart';

class AdminWorkoutPage extends StatefulWidget {
  const AdminWorkoutPage({Key? key}) : super(key: key);

  @override
  State<AdminWorkoutPage> createState() => _AdminWorkoutPageState();
}

class _AdminWorkoutPageState extends State<AdminWorkoutPage> {
  final RealtimeDatabaseService _databaseService = RealtimeDatabaseService();
  List<RealtimeWorkoutModel> _workouts = [];
  bool _isLoading = true;

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
      final workouts = await _databaseService.getAvailableWorkouts();
      if (mounted) {
        setState(() {
          _workouts = workouts;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading workouts: $e')),
        );
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _deleteWorkout(String? workoutId) async {
    if (workoutId == null) return;

    try {
      await _databaseService.deleteWorkout(workoutId);
      _loadWorkouts(); // Refresh the list
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Workout deleted successfully')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error deleting workout: $e')),
        );
      }
    }
  }

  void _showWorkoutDialog([RealtimeWorkoutModel? workout]) {
    showDialog(
      context: context,
      builder: (context) => WorkoutDialog(
        workout: workout,
        onSave: (newWorkout) async {
          try {
            if (workout?.id != null) {
              // Update existing workout
              await _databaseService.updateWorkout(
                workout!.id!,
                newWorkout.toMap(),
              );
            } else {
              // Create new workout
              await _databaseService.createWorkout(newWorkout);
            }
            if (mounted) {
              Navigator.pop(context);
              _loadWorkouts(); // Refresh the list
            }
          } catch (e) {
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Error saving workout: $e')),
              );
            }
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Workouts'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadWorkouts,
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: _workouts.length,
                itemBuilder: (context, index) {
                  final workout = _workouts[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 16),
                    child: ListTile(
                      title: Text(workout.name),
                      subtitle: Text(
                        '${workout.type} • ${workout.duration} min • ${workout.exercises.length} exercises',
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () => _showWorkoutDialog(workout),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () => _deleteWorkout(workout.id),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showWorkoutDialog(),
        child: const Icon(Icons.add),
      ),
    );
  }
}

class WorkoutDialog extends StatefulWidget {
  final RealtimeWorkoutModel? workout;
  final Function(RealtimeWorkoutModel) onSave;

  const WorkoutDialog({
    Key? key,
    this.workout,
    required this.onSave,
  }) : super(key: key);

  @override
  State<WorkoutDialog> createState() => _WorkoutDialogState();
}

class _WorkoutDialogState extends State<WorkoutDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _typeController = TextEditingController();
  final _durationController = TextEditingController();
  final _caloriesController = TextEditingController();
  final List<Map<String, TextEditingController>> _exerciseControllers = [];

  @override
  void initState() {
    super.initState();
    if (widget.workout != null) {
      _nameController.text = widget.workout!.name;
      _typeController.text = widget.workout!.type;
      _durationController.text = widget.workout!.duration.toString();
      _caloriesController.text = widget.workout!.caloriesBurned.toString();
      
      for (var exercise in widget.workout!.exercises) {
        _addExerciseControllers(
          name: exercise.name,
          sets: exercise.sets.toString(),
          reps: exercise.reps.toString(),
          weight: exercise.weight?.toString(),
        );
      }
    }
    
    if (_exerciseControllers.isEmpty) {
      _addExerciseControllers();
    }
  }

  void _addExerciseControllers({
    String? name,
    String? sets,
    String? reps,
    String? weight,
  }) {
    _exerciseControllers.add({
      'name': TextEditingController(text: name),
      'sets': TextEditingController(text: sets),
      'reps': TextEditingController(text: reps),
      'weight': TextEditingController(text: weight),
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _typeController.dispose();
    _durationController.dispose();
    _caloriesController.dispose();
    for (var controllers in _exerciseControllers) {
      controllers.values.forEach((controller) => controller.dispose());
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.workout == null ? 'Add Workout' : 'Edit Workout'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Workout Name'),
                validator: (value) =>
                    value?.isEmpty == true ? 'Please enter a name' : null,
              ),
              TextFormField(
                controller: _typeController,
                decoration: const InputDecoration(labelText: 'Workout Type'),
                validator: (value) =>
                    value?.isEmpty == true ? 'Please enter a type' : null,
              ),
              TextFormField(
                controller: _durationController,
                decoration: const InputDecoration(labelText: 'Duration (minutes)'),
                keyboardType: TextInputType.number,
                validator: (value) =>
                    value?.isEmpty == true ? 'Please enter duration' : null,
              ),
              TextFormField(
                controller: _caloriesController,
                decoration: const InputDecoration(labelText: 'Calories Burned'),
                keyboardType: TextInputType.number,
                validator: (value) =>
                    value?.isEmpty == true ? 'Please enter calories' : null,
              ),
              const SizedBox(height: 16),
              const Text('Exercises', style: TextStyle(fontWeight: FontWeight.bold)),
              ...List.generate(_exerciseControllers.length, (index) {
                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Exercise ${index + 1}'),
                            IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () {
                                setState(() {
                                  var controllers = _exerciseControllers.removeAt(index);
                                  controllers.values.forEach((controller) => controller.dispose());
                                });
                              },
                            ),
                          ],
                        ),
                        TextFormField(
                          controller: _exerciseControllers[index]['name'],
                          decoration: const InputDecoration(labelText: 'Exercise Name'),
                          validator: (value) =>
                              value?.isEmpty == true ? 'Please enter name' : null,
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: _exerciseControllers[index]['sets'],
                                decoration: const InputDecoration(labelText: 'Sets'),
                                keyboardType: TextInputType.number,
                                validator: (value) =>
                                    value?.isEmpty == true ? 'Required' : null,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: TextFormField(
                                controller: _exerciseControllers[index]['reps'],
                                decoration: const InputDecoration(labelText: 'Reps'),
                                keyboardType: TextInputType.number,
                                validator: (value) =>
                                    value?.isEmpty == true ? 'Required' : null,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: TextFormField(
                                controller: _exerciseControllers[index]['weight'],
                                decoration: const InputDecoration(labelText: 'Weight (kg)'),
                                keyboardType: TextInputType.number,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              }),
              TextButton(
                onPressed: () {
                  setState(() {
                    _addExerciseControllers();
                  });
                },
                child: const Text('Add Exercise'),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            if (_formKey.currentState?.validate() == true) {
              final exercises = _exerciseControllers.map((controllers) {
                return RealtimeExerciseModel(
                  name: controllers['name']!.text,
                  sets: int.parse(controllers['sets']!.text),
                  reps: int.parse(controllers['reps']!.text),
                  weight: controllers['weight']!.text.isNotEmpty
                      ? double.parse(controllers['weight']!.text)
                      : null,
                );
              }).toList();

              final workout = RealtimeWorkoutModel(
                id: widget.workout?.id,
                userId: 'admin', // Always set as admin for template workouts
                name: _nameController.text,
                type: _typeController.text,
                duration: int.parse(_durationController.text),
                caloriesBurned: int.parse(_caloriesController.text),
                date: DateTime.now().millisecondsSinceEpoch,
                exercises: exercises,
                timestamp: DateTime.now().millisecondsSinceEpoch,
              );

              widget.onSave(workout);
            }
          },
          child: const Text('Save'),
        ),
      ],
    );
  }
} 