import 'package:flutter/material.dart';
import 'package:tracker/layout/auth_layout.dart';
import 'package:tracker/models/registration_data.dart';
import 'package:tracker/shared/network/remote/user_service.dart';
import 'package:tracker/shared/styles/colors.dart';
import 'package:tracker/shared/styles/fonts.dart';
import 'package:tracker/layout/onboarding_layout.dart';
import 'package:tracker/shared/components/components.dart';
import 'package:tracker/modules/health_dashboard.dart';

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
    if (_fullNameController.text.isEmpty ||
        _emailController.text.isEmpty ||
        _passwordController.text.isEmpty) {
      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill in all required fields'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Update registration data with any changes
      _registrationData.fullName = _fullNameController.text;
      _registrationData.nickname = _nicknameController.text;
      _registrationData.email = _emailController.text;
      _registrationData.password = _passwordController.text;

      // Register user in Firebase
      final userId = await _userService.registerUser(
        email: _registrationData.email!,
        password: _registrationData.password,
        fullName: _registrationData.fullName!,
        age: _registrationData.age!,
        gender: _registrationData.gender!,
        height: _registrationData.height!,
        weight: _registrationData.weight!,
        nickname: _registrationData.nickname ?? '',
        profileImage: _registrationData.profileImage ?? '',
      );

      // Navigate to the dashboard on success
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => HealthDashboardScreen(userId: userId),
          ),
        );
      }
    } catch (e) {
      // Show error
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error registering user: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
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
        // Profile Picture Section
        Container(
          height: 140,
          width: double.infinity,
          decoration: BoxDecoration(
            color: AppColors.avatarBackground,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Center(
            child: Stack(
              alignment: Alignment.center,
              clipBehavior: Clip.none,
              children: [
                const CircleAvatar(
                  radius: 45,
                  backgroundImage: AssetImage('images/pp.jpg'),
                ),
                Positioned(
                  bottom: -4,
                  right: -4,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: AppColors.background,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.shadow,
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.edit,
                      size: 18,
                      color: AppColors.iconColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 30),
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
