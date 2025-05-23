import 'package:flutter/material.dart';
import 'package:tracker/models/realtime_challenge_model.dart';
import 'package:tracker/shared/network/remote/realtime_database_service.dart';
import 'package:tracker/shared/styles/colors.dart';

class AdminChallengePage extends StatefulWidget {
  const AdminChallengePage({Key? key}) : super(key: key);

  @override
  State<AdminChallengePage> createState() => _AdminChallengePageState();
}

class _AdminChallengePageState extends State<AdminChallengePage> {
  final RealtimeDatabaseService _databaseService = RealtimeDatabaseService();
  List<RealtimeChallengeModel> _challenges = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadChallenges();
  }

  Future<void> _loadChallenges() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final challenges = await _databaseService.getAllChallenges();
      if (mounted) {
        setState(() {
          _challenges = challenges;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading challenges: $e')),
        );
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _deleteChallenge(String? challengeId) async {
    if (challengeId == null) return;

    try {
      await _databaseService.deleteChallenge(challengeId);
      _loadChallenges(); // Refresh the list
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Challenge deleted successfully')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error deleting challenge: $e')),
        );
      }
    }
  }

  void _showChallengeDialog([RealtimeChallengeModel? challenge]) {
    showDialog(
      context: context,
      builder: (context) => ChallengeDialog(
        challenge: challenge,
        onSave: (newChallenge) async {
          try {
            if (challenge?.id != null) {
              // Update existing challenge
              await _databaseService.updateChallenge(
                challenge!.id!,
                newChallenge.toMap(),
              );
            } else {
              // Create new challenge
              await _databaseService.createChallenge(newChallenge);
            }
            if (mounted) {
              Navigator.pop(context);
              _loadChallenges(); // Refresh the list
            }
          } catch (e) {
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Error saving challenge: $e')),
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
        title: const Text('Manage Challenges'),
        backgroundColor: AppColors.buttonBackground,
        foregroundColor: Colors.white,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadChallenges,
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: _challenges.length,
                itemBuilder: (context, index) {
                  final challenge = _challenges[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 16),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: challenge.getColor().withOpacity(0.2),
                        child: Icon(
                          challenge.getIcon(),
                          color: challenge.getColor(),
                        ),
                      ),
                      title: Text(challenge.name),
                      subtitle: Text(
                        '${challenge.type} • ${challenge.duration} days • ${challenge.goal} ${challenge.goalUnit}',
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Switch(
                            value: challenge.isActive,
                            onChanged: (value) async {
                              try {
                                await _databaseService.updateChallenge(
                                  challenge.id!,
                                  {...challenge.toMap(), 'isActive': value},
                                );
                                _loadChallenges();
                              } catch (e) {
                                if (mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('Error updating status: $e'),
                                    ),
                                  );
                                }
                              }
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () => _showChallengeDialog(challenge),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () => _deleteChallenge(challenge.id),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showChallengeDialog(),
        child: const Icon(Icons.add),
      ),
    );
  }
}

class ChallengeDialog extends StatefulWidget {
  final RealtimeChallengeModel? challenge;
  final Function(RealtimeChallengeModel) onSave;

  const ChallengeDialog({
    Key? key,
    this.challenge,
    required this.onSave,
  }) : super(key: key);

  @override
  State<ChallengeDialog> createState() => _ChallengeDialogState();
}

class _ChallengeDialogState extends State<ChallengeDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _goalController = TextEditingController();
  final _goalUnitController = TextEditingController();
  final _durationController = TextEditingController();
  String _selectedType = 'running';
  bool _isActive = true;

  final List<String> _challengeTypes = [
    'running',
    'workout',
    'water',
    'yoga',
    'sleep',
  ];

  @override
  void initState() {
    super.initState();
    if (widget.challenge != null) {
      _nameController.text = widget.challenge!.name;
      _descriptionController.text = widget.challenge!.description;
      _goalController.text = widget.challenge!.goal.toString();
      _goalUnitController.text = widget.challenge!.goalUnit;
      _durationController.text = widget.challenge!.duration.toString();
      _selectedType = widget.challenge!.type;
      _isActive = widget.challenge!.isActive;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _goalController.dispose();
    _goalUnitController.dispose();
    _durationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.challenge == null ? 'Add Challenge' : 'Edit Challenge'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Challenge Name'),
                validator: (value) =>
                    value?.isEmpty == true ? 'Please enter a name' : null,
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
                validator: (value) =>
                    value?.isEmpty == true ? 'Please enter a description' : null,
              ),
              DropdownButtonFormField<String>(
                value: _selectedType,
                decoration: const InputDecoration(labelText: 'Type'),
                items: _challengeTypes.map((type) {
                  return DropdownMenuItem(
                    value: type,
                    child: Text(type.toUpperCase()),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _selectedType = value;
                    });
                  }
                },
              ),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _goalController,
                      decoration: const InputDecoration(labelText: 'Goal'),
                      keyboardType: TextInputType.number,
                      validator: (value) =>
                          value?.isEmpty == true ? 'Please enter a goal' : null,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextFormField(
                      controller: _goalUnitController,
                      decoration: const InputDecoration(labelText: 'Goal Unit'),
                      validator: (value) =>
                          value?.isEmpty == true ? 'Please enter a unit' : null,
                    ),
                  ),
                ],
              ),
              TextFormField(
                controller: _durationController,
                decoration: const InputDecoration(labelText: 'Duration (days)'),
                keyboardType: TextInputType.number,
                validator: (value) =>
                    value?.isEmpty == true ? 'Please enter duration' : null,
              ),
              const SizedBox(height: 16),
              SwitchListTile(
                title: const Text('Active'),
                value: _isActive,
                onChanged: (value) {
                  setState(() {
                    _isActive = value;
                  });
                },
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
              final challenge = RealtimeChallengeModel(
                id: widget.challenge?.id,
                name: _nameController.text,
                description: _descriptionController.text,
                type: _selectedType,
                goal: int.parse(_goalController.text),
                goalUnit: _goalUnitController.text,
                duration: int.parse(_durationController.text),
                startDate: DateTime.now().millisecondsSinceEpoch,
                isActive: _isActive,
                timestamp: DateTime.now().millisecondsSinceEpoch,
              );

              widget.onSave(challenge);
            }
          },
          child: const Text('Save'),
        ),
      ],
    );
  }
} 