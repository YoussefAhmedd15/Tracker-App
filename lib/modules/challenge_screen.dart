import 'package:flutter/material.dart';
import 'package:tracker/shared/components/components.dart';
import 'package:tracker/modules/health_dashboard.dart';
import 'package:tracker/modules/profile_page.dart';
import 'package:tracker/modules/workout_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:tracker/layout/main_app_layout.dart';
import 'package:tracker/models/realtime_challenge_model.dart';
import 'package:tracker/shared/network/remote/realtime_database_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChallengeScreen extends StatefulWidget {
  const ChallengeScreen({Key? key}) : super(key: key);

  @override
  State<ChallengeScreen> createState() => _ChallengeScreenState();
}

class _ChallengeScreenState extends State<ChallengeScreen> {
  int selectedIndex = 1; // Challenge icon selected
  final RealtimeDatabaseService _databaseService = RealtimeDatabaseService();
  List<RealtimeChallengeModel> _challenges = [];
  Map<String, dynamic> _userChallenges = {};
  bool _isLoading = true;
  String? _userId;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Get user ID
      final prefs = await SharedPreferences.getInstance();
      _userId = prefs.getString('current_user_id');

      if (_userId != null) {
        // Load challenges and user's progress
        final challenges = await _databaseService.getAllChallenges();
        final userChallenges = await _databaseService.getUserChallenges(_userId!);

        if (mounted) {
          setState(() {
            _challenges = challenges.where((c) => c.isActive).toList();
            _userChallenges = userChallenges;
            _isLoading = false;
          });
        }
      }
    } catch (e) {
      print('Error loading challenges: $e');
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  RealtimeChallengeModel? _getActiveChallenge() {
    if (_userChallenges.isEmpty) return null;

    // Find the most recently joined active challenge
    String? mostRecentChallengeId;
    int? mostRecentTimestamp;

    _userChallenges.forEach((challengeId, data) {
      if (data['status'] == 'active') {
        final joinedAt = data['joinedAt'] as int;
        if (mostRecentTimestamp == null || joinedAt > mostRecentTimestamp!) {
          mostRecentTimestamp = joinedAt;
          mostRecentChallengeId = challengeId;
        }
      }
    });

    if (mostRecentChallengeId != null) {
      return _challenges.firstWhere(
        (c) => c.id == mostRecentChallengeId,
        orElse: () => _challenges.first,
      );
    }

    return null;
  }

  Future<void> _joinChallenge(String challengeId) async {
    if (_userId == null) return;

    try {
      await _databaseService.joinChallenge(_userId!, challengeId);
      _loadData(); // Refresh the data
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Successfully joined the challenge!')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error joining challenge: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return MainAppLayout(
      title: l10n.challenges,
      time: '9:41',
      selectedIndex: selectedIndex,
      onIndexChanged: (index) {
        setState(() {
          selectedIndex = index;
        });
      },
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadData,
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    _buildActiveChallenge(l10n),
                    const SizedBox(height: 30),
                    Text(
                      l10n.availableChallenges,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    _buildChallengeList(l10n),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildActiveChallenge(AppLocalizations l10n) {
    final activeChallenge = _getActiveChallenge();
    if (activeChallenge == null) {
      return Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: const Color(0xFFF6F6F6),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Center(
          child: Text(
            'No active challenges. Join one below!',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey.shade600,
            ),
          ),
        ),
      );
    }

    final challengeProgress = _userChallenges[activeChallenge.id]?['progress'] ?? 0;
    final progress = challengeProgress / activeChallenge.goal;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFF6F6F6),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: activeChallenge.getColor().withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  activeChallenge.getIcon(),
                  color: activeChallenge.getColor(),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      activeChallenge.name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '${activeChallenge.duration} days left',
                      style: const TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.green.shade100,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  l10n.inProgress,
                  style: const TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 10,
              backgroundColor: Colors.grey.shade200,
              valueColor: AlwaysStoppedAnimation<Color>(activeChallenge.getColor()),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${(progress * 100).toInt()}% ${l10n.completed.toLowerCase()}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '$challengeProgress/${activeChallenge.goal} ${activeChallenge.goalUnit}',
                style: TextStyle(
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildChallengeList(AppLocalizations l10n) {
    if (_challenges.isEmpty) {
      return Center(
        child: Text(
          'No challenges available',
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey.shade600,
          ),
        ),
      );
    }

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _challenges.length,
      separatorBuilder: (context, index) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        final challenge = _challenges[index];
        final isJoined = _userChallenges.containsKey(challenge.id);

        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: challenge.getColor().withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  challenge.getIcon(),
                  color: challenge.getColor(),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      challenge.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      challenge.description,
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              if (!isJoined)
                ElevatedButton(
                  onPressed: () => _joinChallenge(challenge.id!),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    minimumSize: const Size(80, 36),
                  ),
                  child: Text(l10n.join),
                ),
            ],
          ),
        );
      },
    );
  }
}
