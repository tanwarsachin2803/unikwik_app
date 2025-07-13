import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:unikwik_app/presentation/widgets/glass_container.dart';
import 'package:unikwik_app/core/theme/app_colors.dart';
import 'package:unikwik_app/presentation/widgets/gradient_background.dart';
import 'package:unikwik_app/presentation/widgets/sand_glass_container.dart';
import 'package:unikwik_app/presentation/screens/university/universities_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  // For demo, use a hardcoded email
  final String userEmail = 'demo.student@gmail.com';
  int _selectedIndex = 2; // Universities tab (account_balance) is selected by default

  final List<IconData> _icons = [
    Icons.travel_explore,
    Icons.attach_money,
    Icons.group,
    Icons.account_circle,
  ];

  String getInitials(String email) {
    final name = email.split('@').first;
    if (name.length >= 2) {
      return name.substring(0, 2).toUpperCase();
    } else if (name.isNotEmpty) {
      return name[0].toUpperCase();
    }
    return '';
  }

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  Widget _buildCurrentScreen() {
    switch (_selectedIndex) {
      case 0: // Travel Explore
        return _buildHomeContent();
      case 1: // Attach Money (Loans)
        return _buildLoansContent();
      case 2: // Account Balance (Universities)
        return const UniversityScreen();
      case 3: // Group (Community)
        return _buildCommunityContent();
      case 4: // Account Circle (Profile)
        return _buildProfileContent();
      default:
        return _buildHomeContent();
    }
  }

  Widget _buildHomeContent() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Main glass card
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18),
          child: GestureDetector(
            onTap: () {
              setState(() {
                _selectedIndex = 2; // Switch to universities tab
              });
            },
            child: GlassContainer(
            borderRadius: 28,
            blurX: 30,
            blurY: 30,
            tintColor: Colors.white.withOpacity(0.18),
            padding: const EdgeInsets.all(24),
            child: Row(
              children: [
                SandGlassContainer(
                  padding: const EdgeInsets.all(16),
                  child: Icon(Icons.account_balance, size: 40, color: AppColors.deepTeal),
                ),
                const SizedBox(width: 18),
                Expanded(
                  child: Text(
                    'Universities',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: AppColors.deepTeal,
                    ),
                  ),
                ),
              ],
            ),
          ),
          ),
        ),
        const SizedBox(height: 32),
        // Service cards row (Visa, Loan)
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.only(bottom: 8.0),
                child: Text(
                  'Find the right visa for your destination and get started on your journey!',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => _showSnackBar(context, 'Visa Service tapped'),
                      child: GlassContainer(
                        borderRadius: 22,
                        blurX: 30,
                        blurY: 30,
                        tintColor: Colors.white.withOpacity(0.18),
                        padding: const EdgeInsets.symmetric(vertical: 28),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SandGlassContainer(
                              padding: const EdgeInsets.all(12),
                              child: Icon(Icons.public, size: 36, color: AppColors.deepTeal),
                            ),
                            const SizedBox(height: 10),
                            const Text('Visa Service', style: TextStyle(fontWeight: FontWeight.w600, color: AppColors.deepTeal)),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 18),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => _showSnackBar(context, 'Loan Service tapped'),
                      child: GlassContainer(
                        borderRadius: 22,
                        blurX: 30,
                        blurY: 30,
                        tintColor: Colors.white.withOpacity(0.18),
                        padding: const EdgeInsets.symmetric(vertical: 28),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SandGlassContainer(
                              padding: const EdgeInsets.all(12),
                              child: Icon(Icons.attach_money, size: 36, color: AppColors.deepTeal),
                            ),
                            const SizedBox(height: 10),
                            const Text('Loan Service', style: TextStyle(fontWeight: FontWeight.w600, color: AppColors.deepTeal)),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 18),
        // Exam Prep card (full width)
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18),
          child: GestureDetector(
            onTap: () => _showSnackBar(context, 'Exam Prep tapped'),
            child: GlassContainer(
              borderRadius: 28,
              blurX: 30,
              blurY: 30,
              tintColor: Colors.white.withOpacity(0.18),
              padding: const EdgeInsets.all(24),
              child: Row(
                children: [
                  SandGlassContainer(
                    padding: const EdgeInsets.all(16),
                    child: Icon(Icons.menu_book, size: 40, color: AppColors.deepTeal),
                  ),
                  const SizedBox(width: 18),
                  const Expanded(
                    child: Text('Exam Prep', style: TextStyle(fontWeight: FontWeight.w600, color: AppColors.deepTeal, fontSize: 20)),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
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
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: AppColors.bgGradientStart,
      extendBody: true, // This is important for curved navigation bar
      body: Stack(
        children: [
          const GradientBackground(),
          SafeArea(
            child: Column(
              children: [
                // Top bar with profile icon
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () => _showSnackBar(context, 'Profile tapped'),
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
                              getInitials(userEmail),
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