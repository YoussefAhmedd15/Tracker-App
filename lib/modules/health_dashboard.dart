import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'dart:ui';
import 'package:provider/provider.dart';
import 'package:tracker/models/realtime_user_model.dart';
import 'package:tracker/shared/components/components.dart';
import 'package:tracker/modules/workout_screen.dart';
import 'package:tracker/modules/profile_page.dart';
import 'package:tracker/modules/challenge_screen.dart';
import 'package:tracker/modules/activity_tracker.dart';
import 'package:tracker/layout/main_app_layout.dart';
import 'package:tracker/layout/card_section_layout.dart';
import 'package:tracker/shared/network/remote/realtime_database_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:tracker/shared/providers/step_counter_provider.dart';

class HealthDashboardScreen extends StatefulWidget {
  final String? userId;

  const HealthDashboardScreen({
    super.key,
    this.userId,
  });

  @override
  State<HealthDashboardScreen> createState() => _HealthDashboardScreenState();
}

class _HealthDashboardScreenState extends State<HealthDashboardScreen> {
  int selectedIndex = 0;
  bool _isLoading = true;
  RealtimeUserModel? _user;
  String? _currentUserId;
  final RealtimeDatabaseService _databaseService = RealtimeDatabaseService();

  @override
  void initState() {
    super.initState();
    _loadUserData();

    // Initialize step counter
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<StepCounterProvider>(context, listen: false).init();
    });
  }

  Future<String?> _getCurrentUserId() async {
    if (widget.userId != null) {
      return widget.userId;
    }

    // Try to get the user ID from SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('current_user_id');
  }

  Future<void> _loadUserData() async {
    // Don't set loading to true if we already have user data
    if (_user == null) {
      setState(() {
        _isLoading = true;
      });
    }

    try {
      _currentUserId = await _getCurrentUserId();

      if (_currentUserId == null) {
        // Handle case where no user ID is available
        setState(() {
          _isLoading = false;
        });
        return;
      }

      final user = await _databaseService.getUser(_currentUserId!);

      if (mounted) {
        setState(() {
          _user = user;
          _isLoading = false;
        });
      }
    } catch (e) {
      print('Error loading user data: $e');
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final stepProvider = Provider.of<StepCounterProvider>(context);

    // Check if we need to request permissions
    if (!stepProvider.isLoading && !stepProvider.isPermissionGranted) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showPermissionDialog();
      });
    }

    return MainAppLayout(
      title: l10n.dashboard,
      time: '9:41',
      selectedIndex: selectedIndex,
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                _buildHeader(),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Column(
                      children: [
                        const SizedBox(height: 16),
                        _buildProgressCard(),
                        const SizedBox(height: 16),
                        _buildMetricsRow(),
                        const SizedBox(height: 16),
                        _buildStandingCard(),
                        const SizedBox(height: 16),
                        _buildBottomCards(),
                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                ),
              ],
            ),
      onIndexChanged: (index) {
        setState(() {
          selectedIndex = index;
        });
      },
    );
  }

  Widget _buildHeader() {
    final l10n = AppLocalizations.of(context)!;
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: Colors.blue.shade200,
            child: Text(
              _user?.nickname?.isNotEmpty == true && _user!.nickname.isNotEmpty
                  ? _user!.nickname[0].toUpperCase()
                  : 'U',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Hi, ${_user?.nickname ?? _user?.fullName?.split(' ').first ?? 'User'}',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Text(
                'Good Morning',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
          const Spacer(),
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child:
                const Icon(Icons.notifications_outlined, color: Colors.black),
          ),
          const SizedBox(width: 12),
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: const Icon(Icons.add, color: Colors.black),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressCard() {
    final l10n = AppLocalizations.of(context)!;
    final stepProvider = Provider.of<StepCounterProvider>(context);

    // Get current step data
    final steps = stepProvider.isInitialized ? stepProvider.steps : 0;
    final calories = stepProvider.isInitialized ? stepProvider.calories : 0;
    final minutes = stepProvider.isInitialized
        ? (steps / 100).round()
        : 0; // Estimate minutes based on steps

    final stepProgress = math.min((steps / 10000) * 100, 100) / 100;
    final calorieProgress = math.min((calories / 500) * 100, 100) / 100;
    final minuteProgress = math.min((minutes / 60) * 100, 100) / 100;

    return CardSectionLayout(
      title: l10n.workoutProgress,
      actionButton: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) =>
                  const ActivityTrackerScreen(),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                const begin = Offset(1.0, 0.0);
                const end = Offset.zero;
                const curve = Curves.easeInOut;
                var tween = Tween(begin: begin, end: end)
                    .chain(CurveTween(curve: curve));
                var offsetAnimation = animation.drive(tween);
                return SlideTransition(position: offsetAnimation, child: child);
              },
              transitionDuration: const Duration(milliseconds: 300),
            ),
          );
        },
        child: Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.grey.shade100,
          ),
          child: const Icon(
            Icons.arrow_outward,
            size: 18,
          ),
        ),
      ),
      content: Column(
        children: [
          SizedBox(
            height: 200,
            width: double.infinity,
            child: Stack(
              alignment: Alignment.center,
              children: [
                CustomPaint(
                  size: const Size(200, 200),
                  painter: ProgressRingsPainter(
                    stepProgress: stepProgress,
                    calorieProgress: calorieProgress,
                    minuteProgress: minuteProgress,
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '${(((stepProgress + calorieProgress + minuteProgress) / 3) * 100).round()}%',
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      l10n.completed,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildProgressLegend(
                icon: Icons.directions_walk,
                color: Colors.blue,
                label: l10n.steps,
                value: '$steps',
                target: '10,000',
              ),
              _buildProgressLegend(
                icon: Icons.local_fire_department,
                color: Colors.orange,
                label: l10n.calories,
                value: '$calories',
                target: '500 ${l10n.kcal}',
              ),
              _buildProgressLegend(
                icon: Icons.timer,
                color: Colors.green,
                label: l10n.minutes,
                value: '$minutes',
                target: '60 ${l10n.minutes}',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProgressLegend({
    required IconData icon,
    required Color color,
    required String label,
    required String value,
    required String target,
  }) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            color: color,
            size: 20,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          'of $target',
          style: TextStyle(
            fontSize: 10,
            color: Colors.grey.shade600,
          ),
        ),
      ],
    );
  }

  Widget _buildMetricsRow() {
    final l10n = AppLocalizations.of(context)!;
    final stepProvider = Provider.of<StepCounterProvider>(context);

    return Row(
      children: [
        Expanded(
          child: _buildMetricCard(
            icon: Icons.local_fire_department,
            iconColor: Colors.orange,
            iconBgColor: Colors.orange.shade50,
            title: l10n.calories,
            value: stepProvider.isInitialized
                ? '+${stepProvider.calories}${l10n.kcal}'
                : '+0${l10n.kcal}',
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildMetricCard(
            icon: Icons.directions_walk,
            iconColor: Colors.purple,
            iconBgColor: Colors.purple.shade50,
            title: l10n.steps,
            value: stepProvider.isInitialized
                ? '+${stepProvider.steps} ${l10n.steps.toLowerCase()}'
                : '+0 ${l10n.steps.toLowerCase()}',
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildMetricCard(
            icon: Icons.timer,
            iconColor: Colors.pink,
            iconBgColor: Colors.pink.shade50,
            title: l10n.activities,
            value: '+40${l10n.minutes}',
          ),
        ),
      ],
    );
  }

  Widget _buildMetricCard({
    required IconData icon,
    required Color iconColor,
    required Color iconBgColor,
    required String title,
    required String value,
  }) {
    return CardSectionLayout(
      padding: const EdgeInsets.all(16),
      borderRadius: 20,
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: iconBgColor,
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: iconColor,
              size: 20,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStandingCard() {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
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
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.man,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.standing,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '0${l10n.hours}',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
          const Spacer(),
          const Icon(
            Icons.chevron_right,
            color: Colors.grey,
          ),
        ],
      ),
    );
  }

  Widget _buildBottomCards() {
    final l10n = AppLocalizations.of(context)!;
    return Row(
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
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
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.nightlight,
                    color: Colors.blue.shade300,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.sleep,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Add ${l10n.sleep.toLowerCase()} data',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
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
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.orange.shade50,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.favorite,
                    color: Colors.orange.shade300,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.heartRate,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Add ${l10n.heartRate.toLowerCase()} data',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // Show permission request dialog
  void _showPermissionDialog() {
    final l10n = AppLocalizations.of(context)!;
    final stepProvider =
        Provider.of<StepCounterProvider>(context, listen: false);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text('Permission Required'),
        content: Text(
            'This app needs activity recognition permission to count your steps and calculate calories burned.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.of(context).pop();
              await stepProvider.requestPermissions();
            },
            child: Text('Grant Permission'),
          ),
        ],
      ),
    );
  }
}

class ProgressRingsPainter extends CustomPainter {
  final double stepProgress;
  final double calorieProgress;
  final double minuteProgress;

  ProgressRingsPainter({
    this.stepProgress = 0.75,
    this.calorieProgress = 0.85,
    this.minuteProgress = 0.95,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    // Draw outer ring background (steps)
    _drawRing(
      canvas: canvas,
      center: center,
      radius: radius,
      strokeWidth: 20,
      color: Colors.blue.shade100,
      startAngle: -math.pi / 2,
      sweepAngle: math.pi * 2,
    );

    // Draw outer ring progress (steps)
    _drawRing(
      canvas: canvas,
      center: center,
      radius: radius,
      strokeWidth: 20,
      color: Colors.blue,
      startAngle: -math.pi / 2,
      sweepAngle: math.pi * 2 * stepProgress,
    );

    // Draw middle ring background (calories)
    _drawRing(
      canvas: canvas,
      center: center,
      radius: radius - 30,
      strokeWidth: 20,
      color: Colors.orange.shade100,
      startAngle: -math.pi / 2,
      sweepAngle: math.pi * 2,
    );

    // Draw middle ring progress (calories)
    _drawRing(
      canvas: canvas,
      center: center,
      radius: radius - 30,
      strokeWidth: 20,
      color: Colors.orange,
      startAngle: -math.pi / 2,
      sweepAngle: math.pi * 2 * calorieProgress,
    );

    // Draw inner ring background (minutes)
    _drawRing(
      canvas: canvas,
      center: center,
      radius: radius - 60,
      strokeWidth: 20,
      color: Colors.green.shade100,
      startAngle: -math.pi / 2,
      sweepAngle: math.pi * 2,
    );

    // Draw inner ring progress (minutes)
    _drawRing(
      canvas: canvas,
      center: center,
      radius: radius - 60,
      strokeWidth: 20,
      color: Colors.green,
      startAngle: -math.pi / 2,
      sweepAngle: math.pi * 2 * minuteProgress,
    );
  }

  void _drawRing({
    required Canvas canvas,
    required Offset center,
    required double radius,
    required double strokeWidth,
    required Color color,
    required double startAngle,
    required double sweepAngle,
  }) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweepAngle,
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant ProgressRingsPainter oldDelegate) {
    return stepProgress != oldDelegate.stepProgress ||
        calorieProgress != oldDelegate.calorieProgress ||
        minuteProgress != oldDelegate.minuteProgress;
  }
}
