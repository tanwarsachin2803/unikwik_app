import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:unikwik_app/presentation/widgets/glass_container.dart';
import 'package:unikwik_app/core/theme/app_colors.dart';
import 'package:unikwik_app/presentation/widgets/gradient_background.dart';
import 'package:unikwik_app/presentation/widgets/sand_glass_container.dart';
import 'package:unikwik_app/presentation/screens/university/universities_screen.dart';
import 'package:unikwik_app/presentation/widgets/profile_drawer.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int _selectedIndex = 2; // Universities tab (account_balance) is selected by default

  final List<IconData> _icons = [
    Icons.travel_explore, // Travel Explorer tab (first tab)
    Icons.attach_money,   // Loans tab
    Icons.account_balance, // Universities tab
    Icons.group,          // Community tab
    Icons.auto_stories,   // Profile/Exam Prep tab
  ];

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  Widget _buildCurrentScreen() {
    switch (_selectedIndex) {
      case 0:
        return TravelExplorerScreen();
      case 1:
        return const Center(child: Text('Loans Screen', style: TextStyle(fontSize: 22)));
      case 2:
        return UniversityScreen();
      case 3:
        return CommunityScreen();
      case 4:
        return const Center(child: Text('Profile Screen', style: TextStyle(fontSize: 22)));
      default:
        return TravelExplorerScreen();
    }
  }

  Widget _buildLoansContent() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.attach_money, size: 80, color: AppColors.deepTeal),
          const SizedBox(height: 20),
          Text(
            'Loans & Financial Aid',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.deepTeal,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Coming Soon',
            style: TextStyle(
              fontSize: 16,
              color: AppColors.deepTeal.withOpacity(0.7),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCommunityContent() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.group, size: 80, color: AppColors.deepTeal),
          const SizedBox(height: 20),
          Text(
            'Community',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.deepTeal,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Coming Soon',
            style: TextStyle(
              fontSize: 16,
              color: AppColors.deepTeal.withOpacity(0.7),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileContent() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.account_circle, size: 80, color: AppColors.deepTeal),
          const SizedBox(height: 20),
          Text(
            'Profile',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.deepTeal,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Coming Soon',
            style: TextStyle(
              fontSize: 16,
              color: AppColors.deepTeal.withOpacity(0.7),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: AppColors.bgGradientStart,
      extendBody: true, // This is important for curved navigation bar
      drawer: const ProfileDrawer(
        firstName: 'Sachin',
        lastName: 'Tanwar',
        personalComplete: true,
        educationComplete: false,
        professionalComplete: false,
        certificationsComplete: true,
      ),
      body: Stack(
        children: [
          const GradientBackground(),
          SafeArea(
            child: Column(
              children: [
                // Top bar with profile icon (only show on non-university screens)
                if (_selectedIndex != 2) // Hide top bar on universities screen
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            _scaffoldKey.currentState?.openDrawer();
                          },
                          child: GlassContainer(
                            padding: const EdgeInsets.all(8),
                            blurX: 30,
                            blurY: 30,
                            borderRadius: 40,
                            tintColor: Colors.white.withOpacity(0.18),
                            child: CircleAvatar(
                              radius: 22,
                              backgroundColor: Colors.transparent,
                              child: Text(
                                'U',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                  color: AppColors.deepTeal,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const Spacer(),
                      ],
                    ),
                  ),
                // Fill the area between top and bottom nav
                Expanded(
                  child: _buildCurrentScreen(),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: Colors.transparent,
        color: AppColors.deepTeal.withOpacity(0.9),
        buttonBackgroundColor: AppColors.steelBlue,
        height: 75,
        animationDuration: const Duration(milliseconds: 300),
        index: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: _icons.map((icon) => Icon(icon, size: 30, color: Colors.white)).toList(),
      ),
    );
  }
}

class _BugOverlay extends StatefulWidget {
  final VoidCallback onClose;
  const _BugOverlay({required this.onClose});

  @override
  State<_BugOverlay> createState() => _BugOverlayState();
}

class _BugOverlayState extends State<_BugOverlay> {
  final TextEditingController _descController = TextEditingController();
  bool _canSend = false;

  @override
  void initState() {
    super.initState();
    _descController.addListener(() {
      setState(() {
        _canSend = _descController.text.trim().isNotEmpty;
      });
    });
  }

  @override
  void dispose() {
    _descController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: GestureDetector(
        onTap: widget.onClose,
        child: Container(
          color: Colors.black.withOpacity(0.18),
          child: Center(
            child: GestureDetector(
              onTap: () {},
              child: Container(
                width: MediaQuery.of(context).size.width * 0.85,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(32),
                  color: Colors.white.withOpacity(0.12),
                  border: Border.all(color: Colors.white.withOpacity(0.2)),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Raise a Bug', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.sand)),
                        IconButton(
                          icon: const Icon(Icons.close, color: AppColors.sand),
                          onPressed: widget.onClose,
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _descController,
                      maxLines: 4,
                      decoration: InputDecoration(
                        hintText: 'Description',
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.10),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(18),
                          borderSide: BorderSide.none,
                        ),
                        hintStyle: const TextStyle(color: AppColors.sand),
                      ),
                      style: const TextStyle(color: AppColors.sand),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.sand,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      onPressed: () {},
                      icon: const Icon(Icons.upload_file, color: Colors.white),
                      label: const Text('Upload/Camera', style: TextStyle(color: Colors.white)),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _canSend ? AppColors.sand : AppColors.sand.withOpacity(0.4),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      onPressed: _canSend ? () {} : null,
                      child: const Text('Send', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _VisaServiceForm extends StatefulWidget {
  @override
  State<_VisaServiceForm> createState() => _VisaServiceFormState();
}

class _VisaServiceFormState extends State<_VisaServiceForm> {
  final List<String> _countries = [
    'United States', 'Canada', 'United Kingdom', 'Australia', 'Germany', 'France', 'Italy', 'India', 'China', 'Japan', 'Singapore', 'UAE', 'New Zealand', 'South Africa', 'Brazil', 'Other',
  ];

  final Map<String, List<String>> _visaTypes = {
    'United States': ['Tourist Visa (B2)', 'Business Visa (B1)', 'Student Visa (F1)', 'Work Visa (H1B)', 'Exchange Visitor (J1)', 'Other'],
    'Canada': ['Visitor Visa', 'Study Permit', 'Work Permit', 'Express Entry', 'Other'],
    'United Kingdom': ['Standard Visitor', 'Student Visa', 'Skilled Worker', 'Youth Mobility', 'Other'],
    'Australia': ['Visitor Visa', 'Student Visa', 'Working Holiday', 'Skilled Migration', 'Other'],
    'Germany': ['Schengen Visa', 'Student Visa', 'Job Seeker', 'Work Visa', 'Other'],
    'France': ['Schengen Visa', 'Student Visa', 'Work Visa', 'Au Pair', 'Other'],
    'Italy': ['Schengen Visa', 'Student Visa', 'Work Visa', 'Family Reunion', 'Other'],
    'India': ['Tourist Visa', 'Business Visa', 'Student Visa', 'Employment Visa', 'Other'],
    'China': ['Tourist (L)', 'Business (M)', 'Student (X)', 'Work (Z)', 'Other'],
    'Japan': ['Tourist Visa', 'Business Visa', 'Student Visa', 'Working Holiday', 'Other'],
    'Singapore': ['Tourist Visa', 'Student Pass', 'Work Pass', 'EntrePass', 'Other'],
    'UAE': ['Tourist Visa', 'Student Visa', 'Work Visa', 'Investor Visa', 'Other'],
    'New Zealand': ['Visitor Visa', 'Student Visa', 'Work Visa', 'Working Holiday', 'Other'],
    'South Africa': ['Visitor Visa', 'Study Visa', 'Work Visa', 'Relative Visa', 'Other'],
    'Brazil': ['Tourist Visa', 'Business Visa', 'Student Visa', 'Work Visa', 'Other'],
    'Other': ['Tourist Visa', 'Business Visa', 'Student Visa', 'Work Visa', 'Other'],
  };

  String? _selectedCountry;
  String? _selectedVisaType;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          'Visa Services',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: AppColors.deepTeal,
          ),
        ),
        const SizedBox(height: 10),
        const Text(
          'Get information and assistance for your visa application. Select your destination country and visa type to get started.',
          style: TextStyle(
            fontSize: 16,
            color: AppColors.steelBlue,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 28),
        Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.13),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: Colors.white.withOpacity(0.18)),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 6),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: _selectedCountry,
              hint: const Text('Select Country', style: TextStyle(color: AppColors.deepTeal)),
              isExpanded: true,
              icon: const Icon(Icons.arrow_drop_down, color: AppColors.deepTeal),
              items: _countries.map((country) {
                return DropdownMenuItem<String>(
                  value: country,
                  child: Text(country, style: const TextStyle(color: AppColors.deepTeal)),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedCountry = value;
                  _selectedVisaType = null;
                });
              },
            ),
          ),
        ),
        const SizedBox(height: 20),
        if (_selectedCountry != null)
          AnimatedOpacity(
            opacity: 1.0,
            duration: const Duration(milliseconds: 300),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.13),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: Colors.white.withOpacity(0.18)),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 6),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: _selectedVisaType,
                  hint: const Text('Select Visa Type', style: TextStyle(color: AppColors.deepTeal)),
                  isExpanded: true,
                  icon: const Icon(Icons.arrow_drop_down, color: AppColors.deepTeal),
                  items: (_visaTypes[_selectedCountry] ?? _visaTypes['Other']!).map((type) {
                    return DropdownMenuItem<String>(
                      value: type,
                      child: Text(type, style: const TextStyle(color: AppColors.deepTeal)),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedVisaType = value;
                    });
                  },
                ),
              ),
            ),
          ),
        const SizedBox(height: 32),
        if (_selectedCountry != null && _selectedVisaType != null)
          GlassContainer(
            borderRadius: 18,
            blurX: 16,
            blurY: 16,
            tintColor: AppColors.deepTeal.withOpacity(0.08),
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Selected:',
                  style: TextStyle(
                    color: AppColors.deepTeal.withOpacity(0.8),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Icon(Icons.flag, color: AppColors.deepTeal, size: 20),
                    const SizedBox(width: 8),
                    Text(_selectedCountry!, style: const TextStyle(color: AppColors.deepTeal, fontWeight: FontWeight.w600)),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.assignment_turned_in, color: AppColors.deepTeal, size: 20),
                    const SizedBox(width: 8),
                    Text(_selectedVisaType!, style: const TextStyle(color: AppColors.deepTeal, fontWeight: FontWeight.w600)),
                  ],
                ),
              ],
            ),
          ),
      ],
    );
  }
}

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
    return Stack(
      children: [
        // Blurred world map background
        Positioned.fill(
          child: Image.network(
            'https://upload.wikimedia.org/wikipedia/commons/thumb/8/80/World_map_-_low_resolution.svg/2000px-World_map_-_low_resolution.svg.png',
            fit: BoxFit.cover,
            color: Colors.black.withOpacity(0.18),
            colorBlendMode: BlendMode.darken,
          ),
        ),
        Positioned.fill(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
            child: Container(
              color: Colors.white.withOpacity(0.08),
            ),
          ),
        ),
        SingleChildScrollView(
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
                    Text('Visa Services', style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: AppColors.sand)),
                  ],
                ),
                const SizedBox(height: 6),
                const Text('Find the right visa and start your journey today!', style: TextStyle(fontSize: 16, color: AppColors.sand, fontWeight: FontWeight.w500)),
                const SizedBox(height: 28),
                // Country Dropdown
                const Text('Select Destination Country', style: TextStyle(fontWeight: FontWeight.w600, color: AppColors.deepTeal)),
                const SizedBox(height: 8),
                _CountryDropdown(
                  countries: _sortedCountries,
                  selected: _selectedCountry,
                  onChanged: (name, flag) {
                    setState(() {
                      _selectedCountry = name;
                      _selectedCountryFlag = flag;
                      _selectedVisaType = null;
                      _showDetails = false;
                    });
                  },
                ),
                const SizedBox(height: 20),
                // Visa Type Dropdown
                const Text('Select Visa Type', style: TextStyle(fontWeight: FontWeight.w600, color: AppColors.deepTeal)),
                const SizedBox(height: 8),
                _VisaTypeDropdown(
                  types: _visaTypeList,
                  selected: _selectedVisaType,
                  onChanged: (type) {
                    setState(() {
                      _selectedVisaType = type;
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
      ],
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

// --- Community Screen Implementation ---

class CommunityScreen extends StatefulWidget {
  @override
  State<CommunityScreen> createState() => _CommunityScreenState();
}

class _CommunityScreenState extends State<CommunityScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _showAskDialog = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _openAskDialog() => setState(() => _showAskDialog = true);
  void _closeAskDialog() => setState(() => _showAskDialog = false);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Blurred background
        Positioned.fill(
          child: Image.network(
            'https://images.unsplash.com/photo-1506744038136-46273834b3fb?auto=format&fit=crop&w=800&q=80',
            fit: BoxFit.cover,
            color: Colors.black.withOpacity(0.18),
            colorBlendMode: BlendMode.darken,
          ),
        ),
        Positioned.fill(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
            child: Container(
              color: Colors.white.withOpacity(0.08),
            ),
          ),
        ),
        Column(
          children: [
            const SizedBox(height: 36),
            // TabBar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.13),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: TabBar(
                  controller: _tabController,
                  indicator: BoxDecoration(
                    color: AppColors.sand.withOpacity(0.7),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  labelColor: AppColors.deepTeal,
                  unselectedLabelColor: AppColors.sand,
                  tabs: const [
                    Tab(icon: Icon(Icons.campaign), text: 'Feeds'),
                    Tab(icon: Icon(Icons.people), text: 'Connections'),
                    Tab(icon: Icon(Icons.question_answer), text: 'Questions'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _FeedsSection(),
                  _ConnectionsSection(),
                  _QuestionsSection(onAsk: _openAskDialog),
                ],
              ),
            ),
          ],
        ),
        // FAB for Questions tab
        if (_tabController.index == 2)
          Positioned(
            bottom: 32,
            right: 24,
            child: FloatingActionButton(
              backgroundColor: AppColors.deepTeal,
              onPressed: _openAskDialog,
              child: const Icon(Icons.add, color: Colors.white),
            ),
          ),
        if (_showAskDialog)
          _AskQuestionDialog(onClose: _closeAskDialog),
      ],
    );
  }
}

// --- Feeds Section ---
class _FeedsSection extends StatelessWidget {
  final List<Map<String, dynamic>> _feeds = const [
    {
      'author': 'Amit Sharma',
      'avatar': '🧑‍🎓',
      'text': 'Just got my Canada visa approved! 🇨🇦 #visa',
      'likes': 12,
      'comments': 3,
      'views': 120,
      'tag': '#visa',
      'emoji': '🎉',
    },
    {
      'author': 'Sara Lee',
      'avatar': '👩‍💼',
      'text': 'Looking for accommodation near TU Munich. Any tips? #housing',
      'likes': 7,
      'comments': 2,
      'views': 80,
      'tag': '#housing',
      'emoji': '🏠',
    },
    {
      'author': 'John Doe',
      'avatar': '🧑‍💻',
      'text': 'Pro tip: Always double-check your SOP before submitting! #study',
      'likes': 15,
      'comments': 5,
      'views': 200,
      'tag': '#study',
      'emoji': '💡',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 220,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 24),
        itemCount: _feeds.length,
        separatorBuilder: (_, __) => const SizedBox(width: 18),
        itemBuilder: (context, i) {
          final feed = _feeds[i];
          return GestureDetector(
            onTap: () {
              showDialog(
                context: context,
                builder: (_) => AlertDialog(
                  backgroundColor: Colors.white.withOpacity(0.95),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                  title: Row(
                    children: [
                      Text(feed['avatar'], style: const TextStyle(fontSize: 28)),
                      const SizedBox(width: 10),
                      Text(feed['author'], style: const TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
                  content: Text(feed['text']),
                  actions: [
                    TextButton(onPressed: () => Navigator.pop(context), child: const Text('Close')),
                  ],
                ),
              );
            },
            child: Container(
              width: 260,
              decoration: BoxDecoration(
                color: AppColors.sand.withOpacity(0.85),
                borderRadius: BorderRadius.circular(22),
                boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 8)],
              ),
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(feed['avatar'], style: const TextStyle(fontSize: 24)),
                      const SizedBox(width: 8),
                      Expanded(child: Text(feed['author'], style: const TextStyle(fontWeight: FontWeight.bold))),
                      if (feed['tag'] != null) ...[
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.4),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(feed['tag'], style: const TextStyle(fontSize: 12)),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(feed['text'], maxLines: 3, overflow: TextOverflow.ellipsis),
                  const Spacer(),
                  Row(
                    children: [
                      Text(feed['emoji'], style: const TextStyle(fontSize: 18)),
                      const Spacer(),
                      Icon(Icons.thumb_up, size: 18, color: Colors.deepOrange),
                      const SizedBox(width: 4),
                      Text(feed['likes'].toString()),
                      const SizedBox(width: 12),
                      Icon(Icons.comment, size: 18, color: Colors.blue),
                      const SizedBox(width: 4),
                      Text(feed['comments'].toString()),
                      const SizedBox(width: 12),
                      Icon(Icons.remove_red_eye, size: 18, color: Colors.green),
                      const SizedBox(width: 4),
                      Text(feed['views'].toString()),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

// --- Connections Section ---
class _ConnectionsSection extends StatefulWidget {
  @override
  State<_ConnectionsSection> createState() => _ConnectionsSectionState();
}

class _ConnectionsSectionState extends State<_ConnectionsSection> {
  final List<Map<String, dynamic>> _users = [
    {
      'name': 'Amit Sharma',
      'avatar': '🧑‍🎓',
      'university': 'IIT Delhi',
      'location': 'Delhi, India',
      'job': 'Student',
      'messaged': false,
    },
    {
      'name': 'Sara Lee',
      'avatar': '👩‍💼',
      'university': 'TU Munich',
      'location': 'Munich, Germany',
      'job': 'Intern',
      'messaged': true,
    },
    {
      'name': 'John Doe',
      'avatar': '🧑‍💻',
      'university': 'MIT',
      'location': 'Boston, USA',
      'job': 'Researcher',
      'messaged': false,
    },
  ];
  String? _selectedUniversity;
  int _connections = 6;
  final List<String> _universities = ['IIT Delhi', 'TU Munich', 'MIT', 'Stanford', 'Oxford'];

  @override
  Widget build(BuildContext context) {
    final filtered = _selectedUniversity == null
        ? _users
        : _users.where((u) => u['university'] == _selectedUniversity).toList();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: _selectedUniversity,
              hint: const Text('Filter by University'),
              isExpanded: true,
              items: _universities.map((u) => DropdownMenuItem(value: u, child: Text(u))).toList(),
              onChanged: (val) => setState(() => _selectedUniversity = val),
            ),
          ),
        ),
        if (_connections > 0)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 4),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.sand.withOpacity(0.7),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text("You've connected with $_connections/10 people", style: const TextStyle(fontWeight: FontWeight.w600)),
            ),
          ),
        Expanded(
          child: filtered.isEmpty
              ? Center(child: Text('No one found from your selected university'))
              : ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                  itemCount: filtered.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, i) {
                    final user = filtered[i];
                    return Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.13),
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(color: Colors.white.withOpacity(0.18)),
                      ),
                      padding: const EdgeInsets.all(14),
                      child: Row(
                        children: [
                          Text(user['avatar'], style: const TextStyle(fontSize: 28)),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(user['name'], style: const TextStyle(fontWeight: FontWeight.bold)),
                                Text(user['university'], style: const TextStyle(fontSize: 13, color: Colors.blueGrey)),
                                Text(user['location'], style: const TextStyle(fontSize: 13, color: Colors.blueGrey)),
                                if (user['job'] != null) Text(user['job'], style: const TextStyle(fontSize: 13)),
                              ],
                            ),
                          ),
                          const SizedBox(width: 12),
                          user['messaged']
                              ? ElevatedButton.icon(
                                  onPressed: null,
                                  icon: const Icon(Icons.check, color: Colors.white),
                                  label: const Text('Messaged'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.green,
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                  ),
                                )
                              : ElevatedButton(
                                  onPressed: () {
                                    setState(() => user['messaged'] = true);
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.deepTeal,
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                  ),
                                  child: const Text('Message'),
                                ),
                        ],
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }
}

// --- Questions Section ---
class _QuestionsSection extends StatelessWidget {
  final VoidCallback onAsk;
  _QuestionsSection({required this.onAsk});
  final List<Map<String, dynamic>> _questions = const [
    {
      'text': "What's the visa type for UK study?",
      'tags': ['#visa', '#UK'],
      'answered': true,
      'time': '2h ago',
      'status': '✅ Answered',
    },
    {
      'text': "How to find affordable housing in Berlin?",
      'tags': ['#housing', '#Germany'],
      'answered': false,
      'time': '1d ago',
      'status': '⏳ Awaiting response',
    },
    {
      'text': "Can I work part-time on a student visa in Canada?",
      'tags': ['#work', '#Canada'],
      'answered': false,
      'time': '3d ago',
      'status': '⏳ Awaiting response',
    },
    {
      'text': "What are the best banks for students in Australia?",
      'tags': ['#banking', '#Australia'],
      'answered': true,
      'time': '5d ago',
      'status': '✅ Answered',
    },
    {
      'text': "How long does it take to get a Schengen visa?",
      'tags': ['#visa', '#Europe'],
      'answered': false,
      'time': '1w ago',
      'status': '⏳ Awaiting response',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
      itemCount: _questions.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, i) {
        final q = _questions[i];
        return Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.13),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: Colors.white.withOpacity(0.18)),
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(q['text'], style: const TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: q['tags'].map<Widget>((t) => Chip(label: Text(t))).toList(),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Text(q['status'], style: TextStyle(fontWeight: FontWeight.w600, color: q['answered'] ? Colors.green : Colors.orange)),
                  const Spacer(),
                  Text(q['time'], style: const TextStyle(fontSize: 12, color: Colors.blueGrey)),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

// --- Ask Question Dialog ---
class _AskQuestionDialog extends StatefulWidget {
  final VoidCallback onClose;
  const _AskQuestionDialog({required this.onClose});
  @override
  State<_AskQuestionDialog> createState() => _AskQuestionDialogState();
}

class _AskQuestionDialogState extends State<_AskQuestionDialog> {
  final TextEditingController _questionController = TextEditingController();
  final List<String> _allTags = ['#visa', '#job', '#accommodation', '#study', '#work', '#banking', '#housing'];
  final List<String> _selectedTags = [];
  bool get _canSend => _questionController.text.trim().isNotEmpty;

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: GestureDetector(
        onTap: widget.onClose,
        child: Container(
          color: Colors.black.withOpacity(0.18),
          child: Center(
            child: GestureDetector(
              onTap: () {},
              child: Container(
                width: MediaQuery.of(context).size.width * 0.92,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(32),
                  color: Colors.white.withOpacity(0.12),
                  border: Border.all(color: Colors.white.withOpacity(0.2)),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Ask a Question', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.sand)),
                        IconButton(
                          icon: const Icon(Icons.close, color: AppColors.sand),
                          onPressed: widget.onClose,
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _questionController,
                      maxLines: 4,
                      maxLength: 300,
                      decoration: const InputDecoration(
                        hintText: 'Type your question...',
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(18)),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      children: _allTags.map((tag) => FilterChip(
                        label: Text(tag),
                        selected: _selectedTags.contains(tag),
                        onSelected: (selected) {
                          setState(() {
                            if (selected) {
                              _selectedTags.add(tag);
                            } else {
                              _selectedTags.remove(tag);
                            }
                          });
                        },
                      )).toList(),
                    ),
                    const SizedBox(height: 18),
                    ElevatedButton(
                      onPressed: _canSend ? () {} : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _canSend ? AppColors.deepTeal : AppColors.deepTeal.withOpacity(0.4),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: const Text('Send', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
} 