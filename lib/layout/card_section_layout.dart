import 'package:flutter/material.dart';

class CardSectionLayout extends StatelessWidget {
  final String? title;
  final Widget content;
  final Widget? actionButton;
  final EdgeInsets padding;
  final double borderRadius;
  final Color backgroundColor;
  final VoidCallback? onTap;

  const CardSectionLayout({
    Key? key,
    this.title,
    required this.content,
    this.actionButton,
    this.padding = const EdgeInsets.all(20),
    this.borderRadius = 24,
    this.backgroundColor = Colors.white,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cardContent = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != null || actionButton != null)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (title != null)
                Text(
                  title!,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              if (actionButton != null) actionButton!,
            ],
          ),
        if (title != null || actionButton != null) const SizedBox(height: 20),
        content,
      ],
    );

    final card = Container(
      padding: padding,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: cardContent,
    );

    if (onTap != null) {
      return GestureDetector(
        onTap: onTap,
        child: card,
      );
    }

    return card;
  }
}
