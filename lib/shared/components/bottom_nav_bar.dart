import 'package:flutter/material.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemSelected;

  const CustomBottomNavBar({
    super.key,
    required this.selectedIndex,
    required this.onItemSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildNavItem(Icons.home_rounded, 0),
              _buildNavItem(Icons.emoji_events_rounded, 1),
              _buildNavItem(Icons.favorite_rounded, 2),
              _buildNavItem(Icons.person_rounded, 3),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, int index) {
    final bool isSelected = selectedIndex == index;

    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0, end: isSelected ? 1.0 : 0.0),
      curve: Curves.elasticOut,
      duration: const Duration(milliseconds: 600),
      builder: (context, value, child) {
        return Transform.scale(
          scale: 1.0 + (value * 0.2),
          child: InkWell(
            onTap: () => onItemSelected(index),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  icon,
                  color: isSelected
                      ? Color.lerp(Colors.grey, Colors.black, value)
                      : Colors.grey,
                  size: 24 + (value * 4),
                ),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.only(top: 4),
                  width: isSelected ? 5 : 0,
                  height: isSelected ? 5 : 0,
                  decoration: const BoxDecoration(
                    color: Colors.black,
                    shape: BoxShape.circle,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
