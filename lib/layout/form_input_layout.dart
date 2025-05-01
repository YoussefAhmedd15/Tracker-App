import 'package:flutter/material.dart';

class FormInputLayout extends StatelessWidget {
  final String title;
  final String? subtitle;
  final Widget inputSection;
  final VoidCallback? onBackPressed;
  final VoidCallback? onContinue;
  final String continueButtonText;
  final Color backgroundColor;
  final Color buttonColor;

  const FormInputLayout({
    Key? key,
    required this.title,
    this.subtitle,
    required this.inputSection,
    this.onBackPressed,
    this.onContinue,
    this.continueButtonText = 'Continue',
    this.backgroundColor = Colors.white,
    this.buttonColor = Colors.blue,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 16.0, bottom: 32.0),
                child: IconButton(
                  onPressed: onBackPressed ?? () => Navigator.pop(context),
                  icon: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.arrow_back,
                      color: Colors.grey.shade800,
                      size: 24,
                    ),
                  ),
                ),
              ),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (subtitle != null) ...[
                const SizedBox(height: 16),
                Text(
                  subtitle!,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
              const SizedBox(height: 40),
              Expanded(child: inputSection),
              if (onContinue != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 32.0),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: onContinue,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: buttonColor,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        continueButtonText,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
