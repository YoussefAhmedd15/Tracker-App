import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:tracker/models/realtime_activity_model.dart';
import 'package:tracker/models/realtime_user_model.dart';
import 'package:tracker/models/realtime_weight_record_model.dart';
import 'package:tracker/shared/components/components.dart';
import 'package:tracker/shared/network/remote/realtime_database_service.dart';
import 'package:tracker/shared/styles/colors.dart';
import 'package:tracker/shared/styles/fonts.dart';
import 'package:intl/intl.dart';

class DashboardScreen extends StatefulWidget {
  final String userId;

  const DashboardScreen({
    super.key,
    required this.userId,
  });

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final RealtimeDatabaseService _databaseService = RealtimeDatabaseService();
  RealtimeUserModel? _user;
  List<RealtimeActivityModel> _recentActivities = [];
  List<RealtimeWeightRecordModel> _weightRecords = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Load user data
      final user = await _databaseService.getUser(widget.userId);

      // Load recent activities
      final activities =
          await _databaseService.getUserActivities(widget.userId);

      // Sort activities by date (most recent first)
      activities.sort((a, b) => b.date.compareTo(a.date));

      // Load weight records
      final weightRecords =
          await _databaseService.getUserWeightRecords(widget.userId);

      // Sort weight records by date (most recent first)
      weightRecords.sort((a, b) => b.date.compareTo(a.date));

      if (mounted) {
        setState(() {
          _user = user;
          _recentActivities = activities.take(5).toList(); // Take 5 most recent
          _weightRecords = weightRecords;
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

  String _formatDate(int timestamp) {
    final date = DateTime.fromMillisecondsSinceEpoch(timestamp);
    return DateFormat('MMM dd, yyyy').format(date);
  }

  String _formatDuration(int seconds) {
    final duration = Duration(seconds: seconds);
    return '${duration.inHours}h ${duration.inMinutes % 60}m';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _user == null
              ? const Center(child: Text('User not found'))
              : SafeArea(
                  child: RefreshIndicator(
                    onRefresh: _loadUserData,
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // User Welcome
                            Row(
                              children: [
                                CircleAvatar(
                                  radius: 30,
                                  backgroundImage:
                                      _user!.profileImage.isNotEmpty
                                          ? NetworkImage(_user!.profileImage)
                                          : null,
                                  child: _user!.profileImage.isEmpty
                                      ? Icon(
                                          Icons.person,
                                          size: 40,
                                          color: AppColors.textSecondary,
                                        )
                                      : null,
                                ),
                                const SizedBox(width: 16),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Welcome back,',
                                      style: AppTextStyles.bodyMedium,
                                    ),
                                    Text(
                                      _user!.nickname.isNotEmpty
                                          ? _user!.nickname
                                          : _user!.fullName,
                                      style: AppTextStyles.heading2,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(height: 24),

                            // Stats Cards
                            Text(
                              'Your Stats',
                              style: AppTextStyles.heading3,
                            ),
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                Expanded(
                                  child: MetricCard(
                                    title: 'Weight',
                                    value: _user!.weight.toString(),
                                    unit: 'kg',
                                    icon: Icons.monitor_weight_outlined,
                                    color: AppColors.accent,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: MetricCard(
                                    title: 'Height',
                                    value: _user!.height.toString(),
                                    unit: 'cm',
                                    icon: Icons.height,
                                    color: AppColors.buttonBackground,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 24),

                            // Weight Chart
                            if (_weightRecords.isNotEmpty) ...[
                              HeaderSection(
                                title: 'Weight History',
                                subtitle:
                                    'Last ${_weightRecords.length} records',
                                rightWidget: TextButton(
                                  onPressed: () {
                                    // Navigate to weight history page
                                  },
                                  child: Text(
                                    'See All',
                                    style: AppTextStyles.bodySmall.copyWith(
                                      color: AppColors.buttonBackground,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16),
                              Container(
                                height: 200,
                                width: double.infinity,
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(16),
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppColors.shadow,
                                      blurRadius: 8,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: Center(
                                  child: Text(
                                    'Weight Chart Coming Soon',
                                    style: AppTextStyles.bodyMedium,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 24),
                            ],

                            // Recent Activities
                            HeaderSection(
                              title: 'Recent Activities',
                              subtitle: _recentActivities.isEmpty
                                  ? 'No activities yet'
                                  : 'Last ${_recentActivities.length} activities',
                              rightWidget: TextButton(
                                onPressed: () {
                                  // Navigate to activities page
                                },
                                child: Text(
                                  'See All',
                                  style: AppTextStyles.bodySmall.copyWith(
                                    color: AppColors.buttonBackground,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            if (_recentActivities.isEmpty)
                              InfoBox(
                                text:
                                    'No activities recorded yet. Start tracking your workouts!',
                              )
                            else
                              ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: _recentActivities.length,
                                itemBuilder: (context, index) {
                                  final activity = _recentActivities[index];
                                  return Container(
                                    margin: const EdgeInsets.only(bottom: 12),
                                    padding: const EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(16),
                                      boxShadow: [
                                        BoxShadow(
                                          color: AppColors.shadow,
                                          blurRadius: 4,
                                          offset: const Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                    child: Row(
                                      children: [
                                        Container(
                                          width: 50,
                                          height: 50,
                                          decoration: BoxDecoration(
                                            color: AppColors.backgroundGrey,
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                          child: Icon(
                                            _getActivityIcon(activity.type),
                                            color: AppColors.buttonBackground,
                                          ),
                                        ),
                                        const SizedBox(width: 16),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                activity.type,
                                                style: AppTextStyles.bodyLarge
                                                    .copyWith(
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              Text(
                                                _formatDate(activity.date),
                                                style: AppTextStyles.bodySmall,
                                              ),
                                            ],
                                          ),
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            Text(
                                              '${activity.distance.toStringAsFixed(1)} km',
                                              style: AppTextStyles.bodyMedium
                                                  .copyWith(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Text(
                                              _formatDuration(
                                                  activity.duration),
                                              style: AppTextStyles.bodySmall,
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
      bottomNavigationBar: CustomBottomNavBar(
        selectedIndex: 0,
        onItemSelected: (index) {
          // Handle navigation
        },
      ),
    );
  }

  IconData _getActivityIcon(String activityType) {
    switch (activityType.toLowerCase()) {
      case 'running':
        return Icons.directions_run;
      case 'cycling':
        return Icons.directions_bike;
      case 'swimming':
        return Icons.pool;
      case 'walking':
        return Icons.directions_walk;
      case 'hiking':
        return Icons.terrain;
      case 'gym':
        return Icons.fitness_center;
      default:
        return Icons.sports;
    }
  }
}
