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

class CommunityScreen extends StatefulWidget {
  @override
  State<CommunityScreen> createState() => _CommunityScreenState();
}

class _CommunityScreenState extends State<CommunityScreen> {
  int _selectedTab = 0;
  String _selectedCountry = 'Germany';
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
                        setState(() => _selectedCountry = country);
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(15),
                    child: Text(
                      'Channels',
                      style: TextStyle(
                        color: AppColors.deepTeal,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
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
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: FiltersWidget(onChanged: (f) {}),
                  ),
                  Expanded(
                    child: ListView.separated(
                      padding: const EdgeInsets.all(12),
                      itemCount: mockPeople.where((p) => p['country'] == _selectedCountry).length,
                      separatorBuilder: (_, __) => const SizedBox(height: 10),
                      itemBuilder: (context, i) {
                        final filtered = mockPeople.where((p) => p['country'] == _selectedCountry).toList();
                        final person = filtered[i];
                        return PersonCard(
                          person: person,
                          onConnect: () {
                            if ((person['personalDetailsComplete'] ?? false) && (person['socialLinked'] ?? false)) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Connection request sent!'), backgroundColor: Colors.blue),
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Complete personal details and link social account'), backgroundColor: Colors.red),
                              );
                            }
                          },
                          onAsk: () {
                            showDialog(
                              context: context,
                              builder: (ctx) => QuestionPopup(
                                personName: person['name'],
                                onSent: () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('Thanks for asking question to ${person['name']}'),
                                      backgroundColor: Colors.green,
                                    ),
                                  );
                                },
                              ),
                            );
                          },
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

