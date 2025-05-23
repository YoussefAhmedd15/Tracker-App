import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:ui';
import 'package:provider/provider.dart';
import 'package:tracker/shared/components/components.dart';
import 'package:tracker/modules/health_dashboard.dart';
import 'package:tracker/modules/profile_page.dart';
import 'package:tracker/modules/workout_screen.dart';
import 'package:tracker/modules/challenge_screen.dart';
import 'package:tracker/layout/main_app_layout.dart';
import 'package:tracker/modules/language_selection_page.dart';
import 'package:tracker/shared/providers/language_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:tracker/models/realtime_user_model.dart';
import 'package:tracker/shared/network/remote/realtime_database_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tracker/modules/admin_page.dart';
import 'package:tracker/shared/styles/fonts.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool notificationsEnabled = true;
  bool connectionAlertsEnabled = true;
  bool phoneCallsEnabled = false;
  int selectedIndex = 3;
  bool _isLoading = true;
  RealtimeUserModel? _user;
  final RealtimeDatabaseService _databaseService = RealtimeDatabaseService();
  bool _isAdmin = false;

  @override
  void initState() {
    super.initState();
    _loadSettings();
    _loadUserData();
  }

  Future<void> _loadSettings() async {
    // Implementation of _loadSettings method
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
            _isAdmin = prefs.getBool('is_admin') ?? false;
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
      title: l10n.settings,
      time: '9:41',
      selectedIndex: selectedIndex,
      showBackButton: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
      onIndexChanged: (index) {
        setState(() {
          selectedIndex = index;
        });
      },
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 16),
                  _buildUserHeader(),
                  const SizedBox(height: 16),
                  _buildSettingsCard(),
                  const SizedBox(height: 16),
                  if (_isAdmin) ...[
                    const SizedBox(height: 24),
                    Text(
                      'Admin',
                      style: AppTextStyles.heading3,
                    ),
                    const SizedBox(height: 16),
                    ListTile(
                      leading: const Icon(Icons.admin_panel_settings),
                      title: const Text('Admin Dashboard'),
                      subtitle: const Text('Manage users and app data'),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const AdminPage(),
                          ),
                        );
                      },
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUserHeader() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    final l10n = AppLocalizations.of(context)!;
    final userName =
        _user?.nickname ?? _user?.fullName?.split(' ').first ?? 'User';

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
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
          CircleAvatar(
            radius: 30,
            backgroundColor: Colors.blue.shade200,
            child: Text(
              userName.isNotEmpty ? userName[0].toUpperCase() : 'U',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.hello,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey.shade600,
                ),
              ),
              Text(
                userName,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsCard() {
    final languageProvider = Provider.of<LanguageProvider>(context);
    final l10n = AppLocalizations.of(context)!;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildSettingItem(
            icon: Icons.language,
            iconColor: Colors.blue,
            iconBgColor: Colors.blue.shade50,
            title: l10n.language,
            subtitle: languageProvider.getCurrentLanguageName(),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const LanguageSelectionPage(),
                ),
              );
            },
          ),
          const Divider(height: 32),
          _buildToggleItem(
            icon: Icons.notifications,
            iconColor: Colors.orange,
            iconBgColor: Colors.orange.shade50,
            title: l10n.notifications,
            value: notificationsEnabled,
            onChanged: (value) {
              setState(() {
                notificationsEnabled = value;
              });
            },
          ),
          const Divider(height: 32),
          _buildToggleItem(
            icon: Icons.warning,
            iconColor: Colors.red,
            iconBgColor: Colors.red.shade50,
            title: l10n.connectionAlerts,
            value: connectionAlertsEnabled,
            onChanged: (value) {
              setState(() {
                connectionAlertsEnabled = value;
              });
            },
          ),
          const Divider(height: 32),
          _buildToggleItem(
            icon: Icons.phone,
            iconColor: Colors.teal,
            iconBgColor: Colors.teal.shade50,
            title: l10n.phoneCalls,
            value: phoneCallsEnabled,
            onChanged: (value) {
              setState(() {
                phoneCallsEnabled = value;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSettingItem({
    required IconData icon,
    required Color iconColor,
    required Color iconBgColor,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Row(
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
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
          const Icon(
            Icons.chevron_right,
            color: Colors.grey,
          ),
        ],
      ),
    );
  }

  Widget _buildToggleItem({
    required IconData icon,
    required Color iconColor,
    required Color iconBgColor,
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Row(
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
        const SizedBox(width: 16),
        Expanded(
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        CupertinoSwitch(
          value: value,
          activeColor: Colors.black,
          onChanged: onChanged,
        ),
      ],
    );
  }
}
