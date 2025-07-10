import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

import 'visa_service_screen.dart';
import 'loan_service_screen.dart';
import 'universities_screen.dart';
import 'community_screen.dart';
import 'profile_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _page = 2; // Center tab selected by default
  late final List<Widget> _screens;

  final GlobalKey<CurvedNavigationBarState> _bottomNavKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _screens = const [
      VisaServiceScreen(),
      LoanServiceScreen(),
      UniversityScreen(),
      CommunityScreen(),
      ProfileScreen(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true, // Ensures nav bar floats above background
      body: _screens[_page],
      bottomNavigationBar: CurvedNavigationBar(
        key: _bottomNavKey,
        index: _page,
        height: 70.0,
        items: const <Widget>[
          Icon(Icons.public, size: 30),            // Visa
          Icon(Icons.account_balance_wallet, size: 30), // Loan
          Icon(Icons.school, size: 36),            // University (center, larger)
          Icon(Icons.group, size: 30),             // Community
          Icon(Icons.person, size: 30),            // Profile
        ],
        color: Colors.white,
        buttonBackgroundColor: Colors.blueAccent,
        backgroundColor: Colors.transparent,
        animationCurve: Curves.easeInOut,
        animationDuration: const Duration(milliseconds: 400),
        onTap: (index) {
          setState(() => _page = index);
        },
        letIndexChange: (index) => true,
      ),
    );
  }
} 