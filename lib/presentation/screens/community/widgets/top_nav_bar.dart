import 'package:flutter/material.dart';

class TopNavBar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onTabSelected;
  const TopNavBar({super.key, required this.selectedIndex, required this.onTabSelected});

  static const List<_NavBarItemData> _items = [
    _NavBarItemData(icon: Icons.campaign, label: 'Feeds'),
    _NavBarItemData(icon: Icons.people, label: 'Connections'),
    _NavBarItemData(icon: Icons.question_answer, label: 'Questions'),
    _NavBarItemData(icon: Icons.help_outline, label: 'FAQ'),
  ];

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(_items.length, (index) {
        final selected = selectedIndex == index;
        return Expanded(
          child: GestureDetector(
            onTap: () => onTabSelected(index),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  curve: Curves.easeInOut,
                  width: selected ? 48 : 0,
                  height: selected ? 48 : 0,
                  decoration: BoxDecoration(
                    color: selected ? Colors.white.withOpacity(0.2) : Colors.transparent,
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: selected
                      ? Icon(_items[index].icon, color: Colors.blue)
                      : const SizedBox.shrink(),
                ),
                if (!selected)
                  Icon(_items[index].icon, color: Colors.white),
                const SizedBox(height: 4),
                Text(
                  _items[index].label,
                  style: TextStyle(
                    color: selected ? Colors.blue : Colors.white,
                    fontWeight: selected ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}

class _NavBarItemData {
  final IconData icon;
  final String label;
  const _NavBarItemData({required this.icon, required this.label});
} 