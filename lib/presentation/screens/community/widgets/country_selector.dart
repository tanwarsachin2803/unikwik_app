import 'package:flutter/material.dart';
import 'package:unikwik_app/presentation/widgets/glass_dropdown_chip.dart';

class CountrySelector extends StatelessWidget {
  final List<String> countries;
  final String selectedCountry;
  final ValueChanged<String> onChanged;
  const CountrySelector({super.key, required this.countries, required this.selectedCountry, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return GlassDropdownChip<String>(
      options: countries,
      selectedValue: selectedCountry,
      onChanged: (val) {
        if (val != null) onChanged(val);
      },
      labelBuilder: (c) => c,
      placeholder: 'Select a country',
      blur: 12,
      blurDropdown: 12,
      chipTint: Colors.white.withOpacity(0.13),
      dropdownTint: Colors.white.withOpacity(0.13),
      isActive: true,
    );
  }
} 