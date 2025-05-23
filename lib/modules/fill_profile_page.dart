import 'package:flutter/material.dart';
import 'package:tracker/layout/auth_layout.dart';
import 'package:tracker/models/registration_data.dart';
import 'package:tracker/shared/network/remote/user_service.dart';
import 'package:tracker/shared/styles/colors.dart';
import 'package:tracker/shared/styles/fonts.dart';
import 'package:tracker/layout/onboarding_layout.dart';
import 'package:tracker/shared/components/components.dart';
import 'package:tracker/modules/health_dashboard.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FillProfilePage extends StatefulWidget {
  final RegistrationData? registrationData;
  final VoidCallback? onBackPressed;

  const FillProfilePage({
    super.key,
    this.registrationData,
    this.onBackPressed,
  });

  @override
  State<FillProfilePage> createState() => _FillProfilePageState();
}

class _FillProfilePageState extends State<FillProfilePage> {
  final _fullNameController = TextEditingController();
  final _nicknameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final UserService _userService = UserService();
  bool _isLoading = false;
  late RegistrationData _registrationData;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();

    // Initialize registration data
    _registrationData = widget.registrationData ?? RegistrationData();

    // Pre-fill form fields with existing registration data
    if (_registrationData.fullName != null) {
      _fullNameController.text = _registrationData.fullName!;
    }

    if (_registrationData.nickname != null) {
      _nicknameController.text = _registrationData.nickname!;
    }

    if (_registrationData.email != null) {
      _emailController.text = _registrationData.email!;
    }

    if (_registrationData.password != null) {
      _passwordController.text = _registrationData.password!;
    }
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _nicknameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _registerUser() async {
    try {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      // Create the user in Firebase
      final userId = await _userService.registerUser(
        email: _emailController.text,
        password: _passwordController.text,
        fullName: _fullNameController.text,
        age: _registrationData.age ?? 0,
        gender: _registrationData.gender ?? 'male',
        height: _registrationData.height ?? 170,
        weight: _registrationData.weight ?? 70,
        nickname: _nicknameController.text,
        // No profile image needed
      );

      // Registration successful, save user ID and navigate to health dashboard
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('current_user_id', userId);

      if (mounted) {
        setState(() {
          _isLoading = false;
        });

        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => HealthDashboardScreen(userId: userId),
          ),
          (route) => false,
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _errorMessage = 'Registration failed: ${e.toString()}';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AuthLayout(
      title: 'Fill Your Profile',
      subtitle: 'Please fill in your details below to complete your profile.',
      children: [
        // Form Fields
        CustomTextField(
          label: 'Full Name',
          hintText: 'Enter your full name',
          controller: _fullNameController,
        ),
        const SizedBox(height: 16),
        CustomTextField(
          label: 'Nickname',
          hintText: 'Enter a nickname (optional)',
          controller: _nicknameController,
        ),
        const SizedBox(height: 16),
        CustomTextField(
          label: 'Email',
          hintText: 'Enter your email',
          controller: _emailController,
        ),
        const SizedBox(height: 16),
        CustomTextField(
          label: 'Password',
          hintText: '*******',
          obscureText: true,
          controller: _passwordController,
        ),
        const SizedBox(height: 16),
        // Display weight and height
        if (_registrationData.weight != null &&
            _registrationData.height != null)
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.backgroundGrey,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    Text(
                      '${_registrationData.weight}',
                      style: AppTextStyles.numberLarge,
                    ),
                    const Text(
                      'Weight (kg)',
                      style: AppTextStyles.bodySmall,
                    ),
                  ],
                ),
                Column(
                  children: [
                    Text(
                      '${_registrationData.height}',
                      style: AppTextStyles.numberLarge,
                    ),
                    const Text(
                      'Height (cm)',
                      style: AppTextStyles.bodySmall,
                    ),
                  ],
                ),
              ],
            ),
          ),
      ],
      bottomButton: _isLoading
          ? const CircularProgressIndicator()
          : CustomButton(
              text: 'Register',
              onPressed: _registerUser,
            ),
    );
  }
}

class CustomTextField extends StatelessWidget {
  final String label;
  final String hintText;
  final bool obscureText;
  final TextEditingController? controller;

  const CustomTextField({
    super.key,
    required this.label,
    required this.hintText,
    this.obscureText = false,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.inputLabel,
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: hintText,
            filled: true,
            fillColor: AppColors.backgroundGrey,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
          ),
          obscureText: obscureText,
        ),
      ],
    );
  }
}
