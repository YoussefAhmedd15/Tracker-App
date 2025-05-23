import 'package:flutter/material.dart';
import 'package:tracker/modules/health_dashboard.dart';
import 'package:tracker/modules/settings.dart';
import 'package:tracker/shared/components/components.dart';
import 'package:tracker/modules/workout_screen.dart';
import 'package:tracker/modules/challenge_screen.dart';
import 'package:tracker/models/realtime_user_model.dart';
import 'package:tracker/shared/network/remote/realtime_database_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:tracker/layout/main_app_layout.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  int selectedIndex = 3; // Profile tab - updated index
  bool _isLoading = true;
  RealtimeUserModel? _user;
  final RealtimeDatabaseService _databaseService = RealtimeDatabaseService();

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
      // Get the user ID from SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getString('current_user_id');

      if (userId != null) {
        final user = await _databaseService.getUser(userId);

        if (mounted) {
          setState(() {
            _user = user;
            _isLoading = false;
          });
        }
      } else {
        setState(() {
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

    return MainAppLayout(
      title: l10n.profile,
      time: '9:41',
      selectedIndex: selectedIndex,
      onIndexChanged: (index) {
        setState(() {
          selectedIndex = index;
        });
      },
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),

              // Profile Info
              Center(
                child: _isLoading
                    ? const CircularProgressIndicator()
                    : Column(
                        children: [
                          _buildProfileHeader(),
                          const SizedBox(height: 12),
                          Text(
                            _user?.email ?? 'user@example.com',
                            style: const TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
              ),

              const SizedBox(height: 30),

              // Competition Card
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
                decoration: BoxDecoration(
                  color: const Color(0xFFF6F6F6),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.emoji_events, color: Colors.amber),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Competition',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w600)),
                          SizedBox(height: 4),
                          Text('Start a competition',
                              style: TextStyle(color: Colors.grey)),
                        ],
                      ),
                    ),
                    TextButton(
                      onPressed: () {},
                      child: const Text('View'),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Settings Cards
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (context, animation, secondaryAnimation) =>
                          const SettingsPage(),
                      transitionsBuilder:
                          (context, animation, secondaryAnimation, child) {
                        const begin = Offset(1.0, 0.0);
                        const end = Offset.zero;
                        const curve = Curves.easeInOut;
                        var tween = Tween(begin: begin, end: end)
                            .chain(CurveTween(curve: curve));
                        var offsetAnimation = animation.drive(tween);
                        return SlideTransition(
                            position: offsetAnimation, child: child);
                      },
                      transitionDuration: const Duration(milliseconds: 300),
                    ),
                  );
                },
                child: const SettingsCard(
                    icon: Icons.settings,
                    color: Colors.deepPurple,
                    title: 'App settings'),
              ),
              const SettingsCard(
                  icon: Icons.insert_chart,
                  color: Colors.green,
                  title: 'Third-party data'),
              const SettingsCard(
                  icon: Icons.devices_other,
                  color: Colors.teal,
                  title: 'Devices permission'),
              const SettingsCard(
                  icon: Icons.security,
                  color: Colors.green,
                  title: 'App permission'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    final userName = _user?.nickname ?? _user?.fullName?.split(' ').first ?? 'User';

    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      child: Column(
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              CircleAvatar(
                radius: 50,
                backgroundColor: Colors.blue.shade200,
                child: Text(
                  userName.isNotEmpty ? userName[0].toUpperCase() : 'U',
                  style: const TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              // Optional edit button removed
            ],
          ),
          const SizedBox(height: 16),
          // ... rest of the method
        ],
      ),
    );
  }
}

class SettingsCard extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String title;

  const SettingsCard({
    super.key,
    required this.icon,
    required this.color,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
      decoration: BoxDecoration(
        color: const Color(0xFFF6F6F6),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: color.withOpacity(0.2),
            child: Icon(icon, color: color),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(title,
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
          ),
          const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
        ],
      ),
    );
  }
}
