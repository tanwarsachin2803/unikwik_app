import 'package:flutter/material.dart';
import 'package:unikwik_app/core/theme/app_colors.dart';
import 'personal_details_screen.dart';
import 'education_details_screen.dart';
import 'professional_details_screen.dart';
import 'certifications_details_screen.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  // Simulate completion state for demo
  bool personalComplete = true;
  bool educationComplete = false;
  bool professionalComplete = false;
  bool certificationsComplete = false;

  // Resume upload state
  String? resumePath;
  String? resumeFileName;

  void _uploadResume() async {
    // TODO: Integrate real file picker
    setState(() {
      resumePath = 'mock_resume.pdf';
      resumeFileName = 'Sachin_Resume.pdf';
    });
  }

  void _removeResume() {
    setState(() {
      resumePath = null;
      resumeFileName = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: AppColors.deepTeal,
      appBar: AppBar(
        title: const Text('Profile', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            // Glassmorphic background
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppColors.deepTeal, AppColors.seafoam],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),
            ListView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 32),
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 0, bottom: 16),
                  child: _ProfileNavTile(
                    icon: Icons.person,
                    label: 'Personal Details',
                    completed: personalComplete,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const PersonalDetailsScreen()),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: _ProfileNavTile(
                    icon: Icons.school,
                    label: 'Education Details',
                    completed: educationComplete,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const EducationDetailsScreen()),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: _ProfileNavTile(
                    icon: Icons.business_center,
                    label: 'Professional Details',
                    completed: professionalComplete,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const ProfessionalDetailsScreen()),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 24),
                  child: _ProfileNavTile(
                    icon: Icons.verified,
                    label: 'Certifications',
                    completed: certificationsComplete,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const CertificationsDetailsScreen()),
                    ),
                  ),
                ),
                Card(
                  color: Colors.white.withOpacity(0.10),
                  elevation: 0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  child: ExpansionTile(
                    leading: const Icon(Icons.picture_as_pdf, color: Colors.deepOrange, size: 32),
                    title: const Text('Resume', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 18)),
                    subtitle: Text(
                      resumeFileName ?? 'Add your resume (PDF)',
                      style: TextStyle(color: resumeFileName != null ? Colors.white : Colors.white70, fontSize: 15),
                    ),
                    children: [
                      if (resumePath == null)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.seafoam,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                            ),
                            onPressed: _uploadResume,
                            icon: const Icon(Icons.upload_file),
                            label: const Text('Upload Resume (PDF)'),
                          ),
                        )
                      else
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          child: Row(
                            children: [
                              const Icon(Icons.check_circle, color: Colors.greenAccent, size: 28),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  resumeFileName!,
                                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 16),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete, color: Colors.redAccent),
                                onPressed: _removeResume,
                                tooltip: 'Remove Resume',
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfileNavTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool completed;
  final VoidCallback onTap;
  const _ProfileNavTile({
    required this.icon,
    required this.label,
    required this.completed,
    required this.onTap,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white.withOpacity(0.10),
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
          child: Row(
            children: [
              Icon(icon, color: AppColors.seafoam, size: 32),
              const SizedBox(width: 20),
              Expanded(
                child: Text(
                  label,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 400),
                transitionBuilder: (child, anim) => ScaleTransition(scale: anim, child: child),
                child: completed
                    ? const Icon(Icons.check_circle, color: Colors.greenAccent, size: 28, key: ValueKey('done'))
                    : const Icon(Icons.radio_button_unchecked, color: Colors.white54, size: 28, key: ValueKey('blank')),
              ),
              const SizedBox(width: 8),
              const Icon(Icons.arrow_forward_ios, color: Colors.white54, size: 20),
            ],
          ),
        ),
      ),
    );
  }
} 