import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:provider/provider.dart';
import 'package:tracker/shared/components/components.dart';
import 'package:tracker/modules/workout_screen.dart';
import 'package:tracker/modules/health_dashboard.dart';
import 'package:tracker/modules/challenge_screen.dart';
import 'package:tracker/modules/profile_page.dart';
import 'package:tracker/shared/providers/step_counter_provider.dart';
import 'package:tracker/layout/main_app_layout.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ActivityTrackerScreen extends StatefulWidget {
  const ActivityTrackerScreen({super.key});

  @override
  State<ActivityTrackerScreen> createState() => _ActivityTrackerScreenState();
}

class _ActivityTrackerScreenState extends State<ActivityTrackerScreen> {
  int selectedDateIndex = 3;
  int bottomNavIndex = 0;

  @override
  void initState() {
    super.initState();

    // Initialize step counter if not already initialized
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final stepProvider =
          Provider.of<StepCounterProvider>(context, listen: false);
      if (!stepProvider.isInitialized) {
        stepProvider.init();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return MainAppLayout(
      title: 'Activity Tracker',
      time: '9:41',
      selectedIndex: bottomNavIndex,
      showBackButton: true,
      onIndexChanged: (index) {
        setState(() {
          bottomNavIndex = index;
        });
      },
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              HeaderSection(
                title: 'Activity Tracker',
                rightWidget: CircularIconButton(
                  icon: Icons.add,
                  onPressed: null,
                ),
              ),
              const SizedBox(height: 24),
              _buildDateSelector(),
              const SizedBox(height: 24),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      _buildActivityCards(),
                      const SizedBox(height: 24),
                      _buildStatisticsSection(),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDateSelector() {
    final days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    final dates = [12, 13, 14, 15, 16, 17, 18];

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
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
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(
          7,
          (index) => _buildDateItem(dates[index], days[index], index == 3),
        ),
      ),
    );
  }

  Widget _buildDateItem(int date, String day, bool isSelected) {
    return Column(
      children: [
        Text(
          date.toString(),
          style: TextStyle(
            fontSize: 16,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            color: isSelected ? Colors.black : Colors.grey,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          day,
          style: TextStyle(
            fontSize: 14,
            color: isSelected ? Colors.black : Colors.grey,
          ),
        ),
      ],
    );
  }

  Widget _buildActivityCards() {
    final stepProvider = Provider.of<StepCounterProvider>(context);
    final l10n = AppLocalizations.of(context)!;

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: MetricCard(
                title: l10n.steps,
                value: stepProvider.isInitialized
                    ? stepProvider.steps.toString()
                    : '0',
                unit: l10n.steps.toLowerCase(),
                icon: Icons.directions_walk,
                color: Colors.blue,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: MetricCard(
                title: l10n.calories,
                value: stepProvider.isInitialized
                    ? stepProvider.calories.toString()
                    : '0',
                unit: l10n.kcal,
                icon: Icons.local_fire_department,
                color: Colors.orange,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            const Expanded(
              child: MetricCard(
                title: 'Heart Rate',
                value: '85',
                unit: 'bpm',
                icon: Icons.favorite,
                color: Colors.red,
              ),
            ),
            const SizedBox(width: 16),
            const Expanded(
              child: MetricCard(
                title: 'Sleep',
                value: '7.5',
                unit: 'hours',
                icon: Icons.nightlight,
                color: Colors.indigo,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatisticsSection() {
    final stepProvider = Provider.of<StepCounterProvider>(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Statistics',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            if (stepProvider.isInitialized)
              TextButton.icon(
                onPressed: () {
                  _showResetConfirmDialog();
                },
                icon: const Icon(Icons.refresh, size: 16),
                label: const Text('Reset Steps'),
                style: TextButton.styleFrom(
                  foregroundColor: Colors.red,
                ),
              ),
          ],
        ),
        const SizedBox(height: 16),
        Container(
          height: 200,
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
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: 20,
                barTouchData: BarTouchData(enabled: false),
                titlesData: FlTitlesData(
                  show: true,
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        const days = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
                        return Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Text(
                            days[value.toInt()],
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 12,
                            ),
                          ),
                        );
                      },
                      reservedSize: 30,
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),
                gridData: FlGridData(show: false),
                borderData: FlBorderData(show: false),
                barGroups: List.generate(
                  7,
                  (index) => BarChartGroupData(
                    x: index,
                    barRods: [
                      BarChartRodData(
                        toY: [12.0, 8.0, 15.0, 10.0, 7.0, 16.0, 9.0][index],
                        color: index == 3
                            ? Colors.blue
                            : Colors.blue.withOpacity(0.3),
                        width: 12,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // Show reset confirmation dialog
  void _showResetConfirmDialog() {
    final stepProvider =
        Provider.of<StepCounterProvider>(context, listen: false);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reset Step Counter'),
        content: const Text(
            'Are you sure you want to reset your step counter and calories burned?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.of(context).pop();
              await stepProvider.resetSteps();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text('Reset'),
          ),
        ],
      ),
    );
  }
}
