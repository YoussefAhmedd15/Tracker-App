import 'package:flutter/material.dart';

class HeaderSection extends StatelessWidget {
  final String title;
  final String? subtitle;
  final Widget? rightWidget;

  const HeaderSection({
    super.key,
    required this.title,
    this.subtitle,
    this.rightWidget,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (subtitle != null)
                Text(
                  subtitle!,
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
            ],
          ),
        ),
        if (rightWidget != null) rightWidget!,
      ],
    );
  }
}
