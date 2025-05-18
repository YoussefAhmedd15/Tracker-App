import 'package:flutter/material.dart';
import 'package:tracker/shared/components/components.dart';
import 'package:tracker/modules/health_dashboard.dart';
import 'package:tracker/modules/profile_page.dart';
import 'package:tracker/modules/workout_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:tracker/layout/main_app_layout.dart';

class ChallengeScreen extends StatefulWidget {
  const ChallengeScreen({Key? key}) : super(key: key);

  @override
  State<ChallengeScreen> createState() => _ChallengeScreenState();
}

class _ChallengeScreenState extends State<ChallengeScreen> {
  int selectedIndex = 1; // Challenge icon selected

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
      body: SingleChildScrollView(
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
    );
  }

  Widget _buildActiveChallenge(AppLocalizations l10n) {
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
                  color: Colors.orange.shade100,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.directions_run,
                  color: Colors.orange,
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.running + ' ' + l10n.challenges.toLowerCase(),
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '5 days left',
                    style: const TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
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
              value: 0.65,
              minHeight: 10,
              backgroundColor: Colors.grey.shade200,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.orange.shade400),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '65% ' + l10n.completed.toLowerCase(),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '13/20 ' + l10n.km,
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
    final challenges = [
      {
        'title': '30 ' + l10n.days + ' ' + l10n.workouts,
        'subtitle': l10n.completed + ' ' + l10n.dailyGoal.toLowerCase(),
        'icon': Icons.fitness_center,
        'color': Colors.blue.shade100,
        'iconColor': Colors.blue,
      },
      {
        'title': l10n.water + ' ' + l10n.challenges.toLowerCase(),
        'subtitle': 'Drink 2L ' +
            l10n.water.toLowerCase() +
            ' ' +
            l10n.dailyGoal.toLowerCase(),
        'icon': Icons.water_drop,
        'color': Colors.cyan.shade100,
        'iconColor': Colors.cyan,
      },
      {
        'title': l10n.yoga,
        'subtitle': l10n.yoga +
            ' 10 ' +
            l10n.minutes +
            ' ' +
            l10n.dailyGoal.toLowerCase(),
        'icon': Icons.self_improvement,
        'color': Colors.purple.shade100,
        'iconColor': Colors.purple,
      },
      {
        'title': l10n.sleep + ' ' + l10n.better,
        'subtitle': l10n.sleep +
            ' 8 ' +
            l10n.hours +
            ' ' +
            l10n.dailyGoal.toLowerCase(),
        'icon': Icons.nightlight,
        'color': Colors.indigo.shade100,
        'iconColor': Colors.indigo,
      },
    ];

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: challenges.length,
      separatorBuilder: (context, index) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        final challenge = challenges[index];
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
                  color: challenge['color'] as Color,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  challenge['icon'] as IconData,
                  color: challenge['iconColor'] as Color,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      challenge['title'] as String,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      challenge['subtitle'] as String,
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: () {},
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
