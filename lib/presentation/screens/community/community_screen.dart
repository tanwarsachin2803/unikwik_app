import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:unikwik_app/core/theme/app_colors.dart';
import 'package:glass/glass.dart';
import 'package:unikwik_app/presentation/screens/community/widgets/feeds_widget.dart';
import 'package:unikwik_app/presentation/screens/community/widgets/top_nav_bar.dart';
import 'package:unikwik_app/presentation/screens/community/widgets/channel_card.dart';
import 'package:unikwik_app/presentation/screens/community/widgets/person_card.dart';
import 'package:unikwik_app/presentation/screens/community/widgets/filters_widget.dart';
import 'package:unikwik_app/presentation/screens/community/widgets/country_selector.dart';
import 'package:unikwik_app/data/mock/mock_channel_data.dart';
import 'package:unikwik_app/data/mock/mock_person_data.dart';
import 'package:unikwik_app/presentation/screens/community/widgets/question_popup.dart';
import 'package:unikwik_app/presentation/screens/community/widgets/channel_modal.dart';
import 'package:unikwik_app/presentation/screens/community/widgets/channel_creation_popup.dart';
import 'package:unikwik_app/presentation/widgets/glass_dropdown_chip.dart';
import 'dart:convert';
import 'package:flutter/services.dart';

class CommunityScreen extends StatefulWidget {
  @override
  State<CommunityScreen> createState() => _CommunityScreenState();
}

class _CommunityScreenState extends State<CommunityScreen> {
  int _selectedTab = 0;
  String _selectedCountry = 'Germany';
  String? _selectedUniversity;
  List<String> _universities = [];
  List<Map<String, dynamic>> _students = [];

  // Mock data for fallback
  static const List<String> _mockUniversities = [
    'RWTH Aachen', 'TU Munich', 'Heidelberg University'
  ];
  static const List<Map<String, dynamic>> _mockStudents = [
    {
      'name': 'Sara Mehta',
      'emoji': '🧑‍🎓',
      'university': 'RWTH Aachen',
      'course': 'MSc Computer Science',
    },
    {
      'name': 'Ali Khan',
      'emoji': '🧑‍🎓',
      'university': 'TU Munich',
      'course': 'MBA',
    },
    {
      'name': 'John Doe',
      'emoji': '🧑‍🎓',
      'university': 'Heidelberg University',
      'course': 'BSc Physics',
    },
  ];

  @override
  void initState() {
    super.initState();
    _loadUniversities(_selectedCountry);
  }

  Future<void> _loadUniversities(String country) async {
    final csv = await rootBundle.loadString('assets/Ranking - Sheet1.csv');
    final lines = LineSplitter.split(csv).toList();
    final header = lines[0].split(',');
    final countryIndex = header.indexOf('Country');
    final universityIndex = header.indexOf('University');
    final courseIndex = header.contains('Course') ? header.indexOf('Course') : -1;
    final universities = <String>{};
    final students = <Map<String, dynamic>>[];
    for (var i = 1; i < lines.length; i++) {
      final row = lines[i].split(',');
      if (row.length > countryIndex && row[countryIndex] == country) {
        universities.add(row[universityIndex]);
        students.add({
          'name': 'Student $i',
          'emoji': '🧑‍🎓',
          'university': row[universityIndex],
          'course': (courseIndex != -1 && row.length > courseIndex) ? row[courseIndex] : 'Course',
        });
      }
    }
    setState(() {
      _universities = universities.isNotEmpty ? universities.toList() : List<String>.from(_mockUniversities);
      _students = students.isNotEmpty ? students : List<Map<String, dynamic>>.from(_mockStudents);
      _selectedUniversity = _universities.isNotEmpty ? _universities[0] : null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          const SizedBox(height: 32),
          CommunityTopNavBar(
            selectedIndex: _selectedTab,
            onChanged: (index) {
              setState(() {
                _selectedTab = index;
              });
            },
          ),
          if (_selectedTab == 0)
            const Expanded(child: FeedsWidget()),
          if (_selectedTab == 1)
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: CountrySelector(
                      countries: const ['Germany', 'Canada', 'USA'],
                      selectedCountry: _selectedCountry,
                      onChanged: (country) {
                        setState(() {
                          _selectedCountry = country;
                        });
                        _loadUniversities(country);
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Channels',
                          style: TextStyle(
                            color: AppColors.deepTeal,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: Colors.transparent,
                            border: Border.all(color: AppColors.sand, width: 2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: IconButton(
                            icon: Icon(Icons.add, color: AppColors.deepTeal, size: 26),
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (ctx) => ChannelCreationPopup(
                                  onAdd: (name) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text('Channel "$name" added!'),
                                        backgroundColor: Colors.green,
                                      ),
                                    );
                                  },
                                ),
                              );
                            },
                            splashRadius: 24,
                            tooltip: 'Add Channel',
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 140,
                    child: ListView.separated(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      scrollDirection: Axis.horizontal,
                      itemCount: mockChannels.where((c) => c['country'] == _selectedCountry).length,
                      separatorBuilder: (_, __) => const SizedBox(width: 10),
                      itemBuilder: (context, i) {
                        final filtered = mockChannels.where((c) => c['country'] == _selectedCountry).toList();
                        final channel = filtered[i];
                        return ChannelCard(
                          channel: channel,
                          joined: channel['joined'] ?? false,
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (ctx) => ChannelModal(
                                channel: channel,
                                joined: channel['joined'] ?? false,
                                onJoin: () {
                                  Navigator.of(ctx).pop();
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('Join request sent for ${channel['name']}'), backgroundColor: Colors.blue),
                                  );
                                },
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                    child: Text(
                      'Connections',
                      style: TextStyle(
                        color: AppColors.deepTeal,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  if (_universities.isEmpty)
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                      child: Text('No universities found for this country.', style: TextStyle(color: Colors.white70)),
                    ),
                  if (_universities.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                      child: GlassDropdownChip<String>(
                        options: _universities,
                        selectedValue: _selectedUniversity,
                        onChanged: (val) {
                          setState(() => _selectedUniversity = val);
                        },
                        labelBuilder: (u) => u,
                        placeholder: 'Select a university',
                        blur: 12,
                        blurDropdown: 12,
                        chipTint: Colors.white.withOpacity(0.13),
                        dropdownTint: Colors.white.withOpacity(0.13),
                        isActive: true,
                      ),
                    ),
                  if (_selectedUniversity == null || _students.where((s) => s['university'] == _selectedUniversity).isEmpty)
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                      child: Text('No students found for this university.', style: TextStyle(color: Colors.white70)),
                    ),
                  if (_selectedUniversity != null && _students.where((s) => s['university'] == _selectedUniversity).isNotEmpty)
                    Expanded(
                      child: ListView.separated(
                        padding: const EdgeInsets.all(15),
                        itemCount: _students.where((s) => s['university'] == _selectedUniversity).length,
                        separatorBuilder: (_, __) => const SizedBox(height: 12),
                        itemBuilder: (context, i) {
                          final filtered = _students.where((s) => s['university'] == _selectedUniversity).toList();
                          final student = filtered[i];
                          return Container(
                            padding: const EdgeInsets.all(18),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(18),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(student['emoji'], style: const TextStyle(fontSize: 32)),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(student['name'], style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 18)),
                                      Text(student['university'], style: const TextStyle(color: Colors.white70, fontSize: 15)),
                                      Text(student['course'], style: const TextStyle(color: Colors.white54, fontSize: 14)),
                                      const SizedBox(height: 10),
                                      Row(
                                        children: [
                                          ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: AppColors.sand,
                                              foregroundColor: AppColors.deepTeal,
                                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                                            ),
                                            onPressed: () {
                                              showDialog(
                                                context: context,
                                                builder: (ctx) => QuestionPopup(
                                                  personName: student['name'],
                                                  onSent: () {
                                                    ScaffoldMessenger.of(context).showSnackBar(
                                                      SnackBar(
                                                        content: Text('Thanks for asking question to ${student['name']}'),
                                                        backgroundColor: Colors.green,
                                                      ),
                                                    );
                                                  },
                                                ),
                                              );
                                            },
                                            child: const Text('Ask Question'),
                                          ),
                                          const SizedBox(width: 10),
                                          ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: AppColors.sand,
                                              foregroundColor: AppColors.deepTeal,
                                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                                            ),
                                            onPressed: () {
                                              ScaffoldMessenger.of(context).showSnackBar(
                                                SnackBar(
                                                  content: Text('Connection request sent to ${student['name']}!'),
                                                  backgroundColor: Colors.blue,
                                                ),
                                              );
                                            },
                                            child: const Text('Connect'),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ).asGlass(
                            tintColor: Colors.white.withOpacity(0.13),
                            blurX: 12,
                            blurY: 12,
                            clipBorderRadius: BorderRadius.circular(18),
                          );
                        },
                      ),
                    ),
                ],
              ),
            ),
          if (_selectedTab == 2)
            const Expanded(child: SizedBox()),
        ],
      ),
    );
  }
}

//upper navigation bar with animated selection indicator
class CommunityTopNavBar extends StatefulWidget {
  final int selectedIndex;
  final ValueChanged<int>? onChanged;

  const CommunityTopNavBar({
    Key? key,
    this.selectedIndex = 0,
    this.onChanged,
  }) : super(key: key);

  @override
  State<CommunityTopNavBar> createState() => _CommunityTopNavBarState();
}

class _CommunityTopNavBarState extends State<CommunityTopNavBar> with SingleTickerProviderStateMixin {
  late int _selectedIndex;

  final List<_NavBarItemData> _items = const [
    _NavBarItemData(icon: Icons.campaign, label: 'Feeds'),
    _NavBarItemData(icon: Icons.people, label: 'Connections'),
    _NavBarItemData(icon: Icons.question_answer, label: 'Questions'),
  ];

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.selectedIndex;
  }

  void _onTap(int index) {
    setState(() {
      _selectedIndex = index;
    });
    widget.onChanged?.call(index);
  }

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      widthFactor: 0.95,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: List.generate(_items.length, (index) {
            final selected = _selectedIndex == index;
            return Expanded(
              child: GestureDetector(
                onTap: () => _onTap(index),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      curve: Curves.easeInOut,
                      width: selected ? 48 : 0,
                      height: selected ? 48 : 0,
                      decoration: BoxDecoration(
                        color: selected ? AppColors.sand : Colors.transparent,
                        shape: BoxShape.circle,
                      ),
                      alignment: Alignment.center,
                      child: selected
                          ? Icon(_items[index].icon, color: AppColors.deepTeal)
                          : const SizedBox.shrink(),
                    ),
                    if (!selected)
                      Icon(_items[index].icon, color: Colors.white),
                    const SizedBox(height: 4),
                    Text(
                      _items[index].label,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: selected ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}

class _NavBarItemData {
  final IconData icon;
  final String label;
  const _NavBarItemData({required this.icon, required this.label});
}

