import 'package:flutter/material.dart';

class ActivityTabs extends StatelessWidget {
  const ActivityTabs({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _ActivityTab(
            icon: Icons.directions_run,
            label: 'Running',
            isSelected: true,
          ),
          const SizedBox(width: 12),
          _ActivityTab(
            icon: Icons.directions_bike,
            label: 'Cycling',
            isSelected: false,
          ),
          const SizedBox(width: 12),
          _ActivityTab(
            icon: Icons.pool,
            label: 'Swimming',
            isSelected: false,
          ),
        ],
      ),
    );
  }
}

class _ActivityTab extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;

  const _ActivityTab({
    Key? key,
    required this.icon,
    required this.label,
    required this.isSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isSelected ? Colors.blue.shade50 : Colors.transparent,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isSelected ? Colors.blue.shade100 : Colors.grey.shade300,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            size: 20,
            color: isSelected ? Colors.blue : Colors.grey,
          ),
          const SizedBox(width: 8),
          Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.blue : Colors.grey,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
