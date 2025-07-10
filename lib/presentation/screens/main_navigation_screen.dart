import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:unikwik_app/presentation/widgets/glass_container.dart';
import 'package:unikwik_app/core/theme/app_colors.dart';
import 'package:unikwik_app/presentation/widgets/gradient_background.dart';
import 'package:unikwik_app/presentation/widgets/sand_glass_container.dart';
import 'package:unikwik_app/presentation/screens/university/universities_screen.dart';
import 'package:unikwik_app/presentation/widgets/profile_drawer.dart';
import 'package:unikwik_app/presentation/screens/community/community_screen.dart';
import 'package:unikwik_app/presentation/screens/travel_explorer_screen.dart';

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