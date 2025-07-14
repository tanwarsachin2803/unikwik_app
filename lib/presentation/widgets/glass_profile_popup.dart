import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:glass/glass.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:unikwik_app/core/theme/app_colors.dart';
import 'package:unikwik_app/presentation/screens/profile/personal_details_screen.dart';
import 'package:unikwik_app/presentation/screens/profile/education_details_screen.dart';
import 'package:unikwik_app/presentation/screens/profile/professional_details_screen.dart';
import 'package:unikwik_app/presentation/screens/profile/certifications_details_screen.dart';
import 'package:unikwik_app/presentation/screens/auth/auth_screen.dart';
// Assume ProfilePage exists and is imported
import 'package:unikwik_app/presentation/screens/profile/profile_page.dart';

class GlassProfilePopup extends StatelessWidget {
  final String firstName;
  final String lastName;
  final bool personalComplete;
  final bool educationComplete;
  final bool professionalComplete;
  final bool certificationsComplete;

  const GlassProfilePopup({
    super.key,
    required this.firstName,
    required this.lastName,
    required this.personalComplete,
    required this.educationComplete,
    required this.professionalComplete,
    required this.certificationsComplete,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 32, vertical: 80),
      alignment: Alignment.center,
      child: Center(
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(32),
            border: Border.all(color: Colors.white.withOpacity(0.25), width: 2),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.18),
                blurRadius: 40,
                offset: const Offset(0, 16),
              ),
              BoxShadow(
                color: AppColors.sand.withOpacity(0.18),
                blurRadius: 12,
                spreadRadius: 2,
              ),
            ],
            gradient: LinearGradient(
              colors: [Colors.white.withOpacity(0.18), AppColors.sand.withOpacity(0.10)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(32),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 36, horizontal: 32),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.18),
                  borderRadius: BorderRadius.circular(32),
                  border: Border.all(color: Colors.white.withOpacity(0.10)),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Avatar with glow
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.sand.withOpacity(0.5),
                            blurRadius: 32,
                            spreadRadius: 2,
                          ),
                        ],
                        gradient: LinearGradient(
                          colors: [AppColors.sand.withOpacity(0.7), Colors.white.withOpacity(0.2)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                      child: const CircleAvatar(
                        radius: 38,
                        backgroundColor: Colors.transparent,
                        child: Icon(Icons.account_circle, size: 64, color: AppColors.sand),
                      ),
                    ),
                    const SizedBox(height: 18),
                    // Name with shimmer effect
                    ShaderMask(
                      shaderCallback: (Rect bounds) {
                        return LinearGradient(
                          colors: [AppColors.sand, Colors.white, AppColors.sand],
                          stops: const [0.1, 0.5, 0.9],
                        ).createShader(bounds);
                      },
                      child: Text(
                        '$firstName $lastName',
                        style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Divider(thickness: 1, color: AppColors.sand),
                    const SizedBox(height: 8),
                    // Main options
                    _buildPopupOption(context, Icons.person, 'Profile', () {
                      Navigator.of(context).push(MaterialPageRoute(builder: (context) => const ProfilePage()));
                    }),
                    _buildPopupOption(context, Icons.favorite, 'Favourites', () {
                      // TODO: Implement navigation to Favourites page
                    }),
                    _buildPopupOption(context, Icons.assignment_turned_in, 'Applied', () {
                      // TODO: Implement navigation to Applied page
                    }),
                    const SizedBox(height: 18),
                    // Sign out
                    ListTile(
                      leading: const Icon(Icons.logout, color: Colors.red),
                      title: const Text('Sign Out', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
                      onTap: () async {
                        await FirebaseAuth.instance.signOut();
                        Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(builder: (_) => const AuthScreen()),
                          (route) => false,
                        );
                      },
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

  Widget _buildPopupOption(BuildContext context, IconData icon, String label, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: LinearGradient(
                colors: [Colors.white.withOpacity(0.10), AppColors.sand.withOpacity(0.10)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Row(
              children: [
                Icon(icon, color: AppColors.sand, size: 28),
                const SizedBox(width: 16),
                Text(label, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 18, color: AppColors.sand)),
                const Spacer(),
                const Icon(Icons.arrow_forward_ios, color: AppColors.sand, size: 18),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTile(BuildContext context, String title, IconData icon, bool complete, Widget screen) {
    return ListTile(
      leading: Icon(icon, color: AppColors.sand, size: 28),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16, color: AppColors.sand)),
      trailing: complete
          ? const CircleAvatar(
              backgroundColor: AppColors.sand,
              radius: 16,
              child: Icon(Icons.check, color: Colors.white, size: 20),
            )
          : null,
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => screen));
      },
    );
  }
} 