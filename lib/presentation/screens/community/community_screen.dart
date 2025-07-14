import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:unikwik_app/core/theme/app_colors.dart';
import 'package:glass/glass.dart';
import 'package:unikwik_app/presentation/screens/community/widgets/feeds_widget.dart';
import 'package:unikwik_app/presentation/screens/community/widgets/top_nav_bar.dart';
import 'package:unikwik_app/presentation/screens/community/widgets/questions_widget.dart';
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
import 'package:unikwik_app/presentation/screens/community/widgets/community_widget.dart';


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
          // Main headline
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.groups, color: Colors.lightBlueAccent, size: 32),
              const SizedBox(width: 10),
              Text(
                'Community',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white.withOpacity(0.9),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          TopNavBar(
            selectedIndex: _selectedTab,
            onTabSelected: (index) {
              setState(() {
                _selectedTab = index;
              });
            },
          ),
          if (_selectedTab == 0)
            Expanded(
              child: FeedsWidget(),
            ),
          if (_selectedTab == 1)
            const Expanded(child: CommunityWidget()),
          if (_selectedTab == 2)
            const Expanded(child: QuestionsWidget()),
          if (_selectedTab == 3)
            // TODO: Add FAQ page widget here
            const Expanded(child: SizedBox()),
        ],
      ),
    );
  }
}



