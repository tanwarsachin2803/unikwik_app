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
      insetPadding: const EdgeInsets.only(top: 60, right: 16, left: 100, bottom: 200),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: Colors.white.withOpacity(0.2)),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.13),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.account_circle, size: 48, color: AppColors.sand),
                      const SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(firstName, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.sand)),
                          Text(lastName, style: const TextStyle(fontSize: 16, color: AppColors.sand)),
                        ],
                      ),
                    ],
                  ),
                  const Divider(thickness: 1, color: AppColors.sand),
                  _buildSectionTile(context, 'Personal Details', Icons.perm_identity, personalComplete, const PersonalDetailsScreen()),
                  _buildSectionTile(context, 'Educational Details', Icons.school, educationComplete, const EducationDetailsScreen()),
                  _buildSectionTile(context, 'Professional Details', Icons.work_outline, professionalComplete, const ProfessionalDetailsScreen()),
                  _buildSectionTile(context, 'Certifications', Icons.workspace_premium_outlined, certificationsComplete, const CertificationsDetailsScreen()),
                  const SizedBox(height: 16),
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