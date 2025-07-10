import 'package:flutter/material.dart';

class FiltersWidget extends StatelessWidget {
  final ValueChanged<Map<String, dynamic>> onChanged;
  const FiltersWidget({super.key, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    // Stub: Replace with actual filter chips and dropdowns
    return Row(
      children: [
        FilterChip(label: const Text('Employed'), selected: false, onSelected: (_) {}),
        const SizedBox(width: 8),
        FilterChip(label: const Text('Student'), selected: false, onSelected: (_) {}),
        const SizedBox(width: 8),
        FilterChip(label: const Text('Not Employed'), selected: false, onSelected: (_) {}),
      ],
    );
  }
} 