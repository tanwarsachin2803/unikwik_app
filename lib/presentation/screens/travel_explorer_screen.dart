import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:unikwik_app/core/theme/app_colors.dart';
import 'package:unikwik_app/presentation/widgets/glass_dropdown_chip.dart';

// --- Travel Explorer Screen Implementation ---

class TravelExplorerScreen extends StatefulWidget {
  @override
  State<TravelExplorerScreen> createState() => _TravelExplorerScreenState();
}

class _TravelExplorerScreenState extends State<TravelExplorerScreen> {
  // Mock country data (would be fetched from API in real app)
  final List<Map<String, String>> _allCountries = [
    {"name": "India", "code": "IN", "flag": "🇮🇳"},
    {"name": "United States", "code": "US", "flag": "🇺🇸"},
    {"name": "Canada", "code": "CA", "flag": "🇨🇦"},
    {"name": "Germany", "code": "DE", "flag": "🇩🇪"},
    {"name": "United Arab Emirates", "code": "AE", "flag": "🇦🇪"},
    {"name": "Australia", "code": "AU", "flag": "🇦🇺"},
    {"name": "United Kingdom", "code": "GB", "flag": "🇬🇧"},
    {"name": "France", "code": "FR", "flag": "🇫🇷"},
    {"name": "Japan", "code": "JP", "flag": "🇯🇵"},
    {"name": "China", "code": "CN", "flag": "🇨🇳"},
    {"name": "Brazil", "code": "BR", "flag": "🇧🇷"},
    {"name": "South Africa", "code": "ZA", "flag": "🇿🇦"},
    {"name": "Other", "code": "OT", "flag": "🌐"},
  ];
  final List<String> _popular = ["India", "United States", "Canada", "Germany", "United Arab Emirates"];
  String? _selectedCountry;
  String? _selectedCountryFlag;
  String? _selectedVisaType;
  bool _showDetails = false;

  final Map<String, List<Map<String, String>>> _visaTypes = {
    "India": [
      {"type": "Tourist Visa", "desc": "For leisure travel and tourism."},
      {"type": "Student Visa", "desc": "For pursuing education."},
      {"type": "Business Visa", "desc": "For business meetings and conferences."},
      {"type": "Work Visa", "desc": "For employment in the country."},
      {"type": "Medical Visa", "desc": "For medical treatment."},
      {"type": "Family/Reunion Visa", "desc": "For visiting family or relatives."},
      {"type": "Transit Visa", "desc": "For passing through the country."},
    ],
    // ...repeat for other countries, or use same for demo
  };

  List<Map<String, String>> get _sortedCountries {
    final popular = _allCountries.where((c) => _popular.contains(c["name"])).toList();
    final rest = _allCountries.where((c) => !_popular.contains(c["name"])).toList()
      ..sort((a, b) => a["name"]!.compareTo(b["name"]!));
    return [...popular, ...rest];
  }

  List<Map<String, String>> get _visaTypeList {
    if (_selectedCountry == null) return [];
    return _visaTypes[_selectedCountry!] ?? _visaTypes["India"]!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        width: double.infinity,
        height: double.infinity,

        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Header
                Row(
                  children: [
                    const Text('🌍', style: TextStyle(fontSize: 36)),
                    const SizedBox(width: 10),
                    Text('Travel Explorer', style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: AppColors.sand)),
                  ],
                ),
                const SizedBox(height: 6),
                const Text('Find the right visa and start your journey today!', style: TextStyle(fontSize: 16, color: AppColors.sand, fontWeight: FontWeight.w500)),
                const SizedBox(height: 28),
                // Country Dropdown
                const Text('Select Destination Country', style: TextStyle(fontWeight: FontWeight.w600, color: AppColors.deepTeal)),
                const SizedBox(height: 8),
                GlassDropdownChip<Map<String, String>>(
                  options: _sortedCountries,
                  selectedValue: _selectedCountry == null ? null : _sortedCountries.firstWhere((c) => c["name"] == _selectedCountry),
                  labelBuilder: (country) => country["name"]!,
                  leadingBuilder: (country) => Text(country["flag"]!, style: const TextStyle(fontSize: 22)),
                  placeholder: 'Select Country',
                  onChanged: (country) {
                    setState(() {
                      _selectedCountry = country?["name"];
                      _selectedCountryFlag = country?["flag"];
                      _selectedVisaType = null;
                      _showDetails = false;
                    });
                  },
                ),
                const SizedBox(height: 20),
                // Visa Type Dropdown
                const Text('Select Visa Type', style: TextStyle(fontWeight: FontWeight.w600, color: AppColors.deepTeal)),
                const SizedBox(height: 8),
                GlassDropdownChip<Map<String, String>>(
                  options: _visaTypeList,
                  selectedValue: _selectedVisaType == null ? null : _visaTypeList.firstWhere((v) => v["type"] == _selectedVisaType),
                  labelBuilder: (type) => type["type"]!,
                  placeholder: 'Select Visa Type',
                  onChanged: (type) {
                    setState(() {
                      _selectedVisaType = type?["type"];
                      _showDetails = true;
                    });
                  },
                ),
                const SizedBox(height: 28),
                // Visa Details Card
                if (_showDetails && _selectedCountry != null && _selectedVisaType != null)
                  _VisaDetailsCard(
                    country: _selectedCountry!,
                    flag: _selectedCountryFlag ?? '',
                    visaType: _selectedVisaType!,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// --- Country Dropdown Widget ---
class _CountryDropdown extends StatefulWidget {
  final List<Map<String, String>> countries;
  final String? selected;
  final void Function(String name, String flag) onChanged;
  const _CountryDropdown({required this.countries, required this.selected, required this.onChanged});

  @override
  State<_CountryDropdown> createState() => _CountryDropdownState();
}

class _CountryDropdownState extends State<_CountryDropdown> {
  late List<Map<String, String>> _filtered;
  final TextEditingController _controller = TextEditingController();
  bool _dropdownOpen = false;

  @override
  void initState() {
    super.initState();
    _filtered = widget.countries;
  }

  void _onSearch(String value) {
    setState(() {
      _filtered = widget.countries.where((c) => c["name"]!.toLowerCase().contains(value.toLowerCase())).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        GestureDetector(
          onTap: () => setState(() => _dropdownOpen = !_dropdownOpen),
          child: Container(
            height: 56,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.13),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: Colors.white.withOpacity(0.18)),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 18),
            child: Row(
              children: [
                widget.selected != null
                  ? Text(widget.countries.firstWhere((c) => c["name"] == widget.selected)["flag"]!, style: const TextStyle(fontSize: 22))
                  : const Icon(Icons.flag, color: AppColors.deepTeal),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    widget.selected ?? 'Select Country',
                    style: const TextStyle(fontSize: 16, color: AppColors.deepTeal),
                  ),
                ),
                Icon(_dropdownOpen ? Icons.arrow_drop_up : Icons.arrow_drop_down, color: AppColors.deepTeal),
              ],
            ),
          ),
        ),
        if (_dropdownOpen)
          Container(
            margin: const EdgeInsets.only(top: 4),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.95),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: Colors.white.withOpacity(0.18)),
              boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 8)],
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  child: TextField(
                    controller: _controller,
                    onChanged: _onSearch,
                    decoration: const InputDecoration(
                      hintText: 'Search country...',
                      border: InputBorder.none,
                      isDense: true,
                    ),
                  ),
                ),
                SizedBox(
                  height: 180,
                  child: ListView.builder(
                    itemCount: _filtered.length,
                    itemBuilder: (context, i) {
                      final c = _filtered[i];
                      return ListTile(
                        leading: Text(c["flag"]!, style: const TextStyle(fontSize: 22)),
                        title: Text(c["name"]!, style: const TextStyle(fontSize: 16)),
                        onTap: () {
                          widget.onChanged(c["name"]!, c["flag"]!);
                          setState(() => _dropdownOpen = false);
                          _controller.clear();
                          _filtered = widget.countries;
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

// --- Visa Type Dropdown Widget ---
class _VisaTypeDropdown extends StatelessWidget {
  final List<Map<String, String>> types;
  final String? selected;
  final void Function(String type) onChanged;
  const _VisaTypeDropdown({required this.types, required this.selected, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.13),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white.withOpacity(0.18)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: selected,
          hint: const Text('Select Visa Type', style: TextStyle(color: AppColors.deepTeal)),
          isExpanded: true,
          icon: const Icon(Icons.arrow_drop_down, color: AppColors.deepTeal),
          items: types.map((type) {
            return DropdownMenuItem<String>(
              value: type["type"],
              child: Row(
                children: [
                  const Icon(Icons.assignment_turned_in, color: AppColors.deepTeal, size: 18),
                  const SizedBox(width: 8),
                  Text(type["type"]!, style: const TextStyle(color: AppColors.deepTeal)),
                  if (type["desc"] != null) ...[
                    const SizedBox(width: 8),
                    Text('(${type["desc"]})', style: const TextStyle(color: AppColors.steelBlue, fontSize: 12)),
                  ]
                ],
              ),
            );
          }).toList(),
          onChanged: (value) {
            if (value != null) onChanged(value);
          },
        ),
      ),
    );
  }
}

// --- Visa Details Card Widget ---
class _VisaDetailsCard extends StatefulWidget {
  final String country;
  final String flag;
  final String visaType;
  const _VisaDetailsCard({required this.country, required this.flag, required this.visaType});

  @override
  State<_VisaDetailsCard> createState() => _VisaDetailsCardState();
}

class _VisaDetailsCardState extends State<_VisaDetailsCard> {
  bool _expanded = false;
  @override
  Widget build(BuildContext context) {
    // Mock details for demo
    final details = {
      "where": "Nearest embassy, VFS center, or online portal.",
      "how": ["Fill application form", "Pay fees", "Book appointment", "Biometric/Interview"],
      "requirements": ["Passport", "Photo", "Proof of funds", "Travel insurance"],
      "optional": ["Cover letter", "Flight booking"],
      "eligibility": ["18+ years", "Sufficient funds"],
      "validity": "90 days, multiple entry",
      "processing": "7-15 business days",
    };
    // Dynamic CTA
    String ctaMsg = '';
    IconData ctaIcon = Icons.info_outline;
    if (widget.visaType.contains('Tourist')) {
      ctaMsg = '🔒 Please complete your personal details to continue with the Tourist Visa process.';
      ctaIcon = Icons.lock_outline;
    } else if (widget.visaType.contains('Student')) {
      ctaMsg = '📚 In addition to personal details, please provide your education background.';
      ctaIcon = Icons.school_outlined;
    } else if (widget.visaType.contains('Work')) {
      ctaMsg = '💼 Personal + Professional experience is required for this visa.';
      ctaIcon = Icons.work_outline;
    } else {
      ctaMsg = 'Please complete your details to continue.';
    }
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.ease,
      margin: const EdgeInsets.only(bottom: 18),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.13),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: Colors.white.withOpacity(0.18)),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 8)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ListTile(
            leading: Text(widget.flag, style: const TextStyle(fontSize: 28)),
            title: Text('${widget.visaType} for ${widget.country}', style: const TextStyle(fontWeight: FontWeight.bold)),
            trailing: IconButton(
              icon: Icon(_expanded ? Icons.expand_less : Icons.expand_more),
              onPressed: () => setState(() => _expanded = !_expanded),
            ),
          ),
          AnimatedCrossFade(
            duration: const Duration(milliseconds: 300),
            crossFadeState: _expanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
            firstChild: const SizedBox.shrink(),
            secondChild: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Where to Apply', style: TextStyle(fontWeight: FontWeight.w600)),
                  Text(details["where"] as String),
                  const SizedBox(height: 10),
                  const Text('How to Apply', style: TextStyle(fontWeight: FontWeight.w600)),
                  ...(details["how"] as List<String>).map<Widget>((s) => Row(children: [const Icon(Icons.arrow_right, size: 18), Text(s)])).toList(),
                  const SizedBox(height: 10),
                  const Text('Requirements', style: TextStyle(fontWeight: FontWeight.w600)),
                  ...(details["requirements"] as List<String>).map<Widget>((s) => Row(children: [const Icon(Icons.check, size: 18, color: Colors.green), Text(s)])).toList(),
                  if (details["optional"] != null) ...[
                    const SizedBox(height: 6),
                    const Text('Optional', style: TextStyle(fontWeight: FontWeight.w600)),
                    ...(details["optional"] as List<String>).map<Widget>((s) => Row(children: [const Icon(Icons.info_outline, size: 18, color: Colors.blue), Text(s)])).toList(),
                  ],
                  if (details["eligibility"] != null) ...[
                    const SizedBox(height: 6),
                    const Text('Eligibility', style: TextStyle(fontWeight: FontWeight.w600)),
                    ...(details["eligibility"] as List<String>).map<Widget>((s) => Row(children: [const Icon(Icons.verified_user, size: 18, color: Colors.orange), Text(s)])).toList(),
                  ],
                  const SizedBox(height: 10),
                  Text('Validity: ${details["validity"]}'),
                  Text('Processing Time: ${details["processing"]}'),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
            child: Row(
              children: [
                Icon(ctaIcon, color: AppColors.deepTeal),
                const SizedBox(width: 8),
                Expanded(child: Text(ctaMsg)),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.deepTeal,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  child: const Text('Complete My Details'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
} 