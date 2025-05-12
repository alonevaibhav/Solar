import 'package:flutter/material.dart';
import 'package:get/get.dart';

class InspectorBottomNavigation extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const InspectorBottomNavigation({
    Key? key,
    required this.currentIndex,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Container(
        height: 60,
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildNavItem(
              icon: Icons.description,
              index: 0,
              label: 'Reports',
            ),
            _buildNavItem(
              icon: Icons.assignment,
              index: 1,
              label: 'Tasks',
            ),
            _buildNavItem(
              icon: Icons.home,
              index: 2,
              label: 'Home',
            ),
            _buildNavItem(
              icon: Icons.warning,
              index: 3,
              label: 'Alerts',
            ),
            _buildNavItem(
              icon: Icons.person,
              index: 4,
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required int index,
    required String label,
  }) {
    final isSelected = currentIndex == index;

    return GestureDetector(
      onTap: () => onTap(index),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected ? Colors.white : Colors.white.withOpacity(0.6),
              size: 35,
            ),

          ],
        ),
      ),
    );
  }
}