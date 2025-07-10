import 'package:flutter/material.dart';
import 'package:unikwik_app/presentation/widgets/gradient_background.dart';
import 'package:unikwik_app/core/theme/app_colors.dart';
import 'dart:ui';
import 'package:unikwik_app/presentation/screens/profile/personal_details_screen.dart';
import 'package:unikwik_app/presentation/screens/profile/education_details_screen.dart';
import 'package:unikwik_app/presentation/screens/profile/professional_details_screen.dart';
import 'package:unikwik_app/presentation/screens/profile/certifications_details_screen.dart';
import 'package:glass/glass.dart';

class ProfileDrawer extends StatefulWidget {
  final String firstName;
  final String lastName;
  final bool personalComplete;
  final bool educationComplete;
  final bool professionalComplete;
  final bool certificationsComplete;
  final VoidCallback? onRaiseBug; // <-- Add this

  const ProfileDrawer({
    super.key,
    required this.firstName,
    required this.lastName,
    required this.personalComplete,
    required this.educationComplete,
    required this.professionalComplete,
    required this.certificationsComplete,
    this.onRaiseBug, // <-- Add this
  });

  @override
  State<ProfileDrawer> createState() => _ProfileDrawerState();
}

class _ProfileDrawerState extends State<ProfileDrawer> {
  bool _showBugOverlay = false;

  void _openBugOverlay() {
    setState(() => _showBugOverlay = true);
  }
  void _closeBugOverlay() {
    setState(() => _showBugOverlay = false);
  }

  Widget _buildSectionTile(String title, IconData icon, bool complete, {VoidCallback? onTap}) {
    return ListTile(
      leading: Icon(icon, color: AppColors.sand, size: 28),
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16, color: AppColors.sand),
      ),
      trailing: complete
          ? CircleAvatar(
              backgroundColor: AppColors.sand,
              radius: 16,
              child: const Icon(Icons.check, color: Colors.white, size: 20),
            )
          : null,
      onTap: onTap,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Stack(
        children: [
          const GradientBackground(),
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topRight: Radius.circular(40),
              bottomRight: Radius.circular(40),
            ),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 25, sigmaY: 25),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.12),
                  borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(40),
                    bottomRight: Radius.circular(40),
                  ),
                  border: Border.all(color: Colors.white.withOpacity(0.2)),
                ),
                child: SafeArea(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
                        child: Row(
                          children: [
                            const Icon(Icons.account_circle, size: 48, color: AppColors.sand),
                            const SizedBox(width: 16),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.firstName,
                                  style: const TextStyle(
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.sand,
                                  ),
                                ),
                                Text(
                                  widget.lastName,
                                  style: const TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.sand,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const Divider(thickness: 1, color: AppColors.sand),
                      _buildSectionTile(
                        'Personal Details',
                        Icons.perm_identity,
                        widget.personalComplete,
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => const PersonalDetailsScreen(),
                            ),
                          );
                        },
                      ),
                      _buildSectionTile(
                        'Educational Details',
                        Icons.school,
                        widget.educationComplete,
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => const EducationDetailsScreen(),
                            ),
                          );
                        },
                      ),
                      _buildSectionTile(
                        'Professional Details',
                        Icons.work_outline,
                        widget.professionalComplete,
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => const ProfessionalDetailsScreen(),
                            ),
                          );
                        },
                      ),
                      _buildSectionTile(
                        'Certifications',
                        Icons.workspace_premium_outlined,
                        widget.certificationsComplete,
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => const CertificationsDetailsScreen(),
                            ),
                          );
                        },
                      ),
                      const Spacer(),
                      Padding(
                        padding: const EdgeInsets.only(left: 24, right: 24, bottom: 24),
                        child: Center(
                          child: GestureDetector(
                            onTap: () {
                              if (widget.onRaiseBug != null) {
                                widget.onRaiseBug!();
                              }
                            },
                            child: Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(18),
                                color: AppColors.deepTeal, // Changed from glassy white to deepTeal
                                border: Border.all(color: Colors.white.withOpacity(0.2)),
                              ),
                              child: const Center(
                                child: Text(
                                  'Raise Bug',
                                  style: TextStyle(
                                    color: Colors.white, // Changed from AppColors.sand to white
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ).asGlass(
                              tintColor: Colors.white,
                              blurX: 16,
                              blurY: 16,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
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
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _descController = TextEditingController();
  String? _screenshotPath;
  String? _fileName;
  bool _canSend = false;

  @override
  void initState() {
    super.initState();
    _descController.addListener(_onDescChanged);
    _canSend = _descController.text.isNotEmpty;
  }

  void _onDescChanged() {
    if (_canSend != _descController.text.isNotEmpty) {
      setState(() {
        _canSend = _descController.text.isNotEmpty;
      });
    }
  }

  @override
  void dispose() {
    _descController.removeListener(_onDescChanged);
    _descController.dispose();
    super.dispose();
  }

  void _showUploadOptions() async {
    final result = await showModalBottomSheet<String>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.upload_file),
                title: const Text('Upload from device'),
                onTap: () => Navigator.pop(context, 'upload'),
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Use Camera'),
                onTap: () => Navigator.pop(context, 'camera'),
              ),
            ],
          ),
        );
      },
    );
    if (result == 'upload') {
      setState(() {
        _screenshotPath = 'mock_screenshot.png';
        _fileName = 'screenshot.png';
      });
    } else if (result == 'camera') {
      setState(() {
        _screenshotPath = 'mock_screenshot_camera.jpg';
        _fileName = 'screenshot_camera.jpg';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height * 0.85;
    final width = MediaQuery.of(context).size.width * 0.95;
    final fieldFill = Colors.white.withOpacity(0.18);
    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(20),
      borderSide: BorderSide(color: AppColors.sand.withOpacity(0.5)),
    );
    return Stack(
      children: [
        Center(
          child: Stack(
            children: [
              Container(
                width: width,
                height: height,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(32),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.12),
                      blurRadius: 32,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.10),
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 32),
                          const Text('Raise a Bug', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.sand)),
                          const SizedBox(height: 18),
                          TextFormField(
                            controller: _descController,
                            maxLines: 5,
                            decoration: InputDecoration(
                              labelText: 'Description',
                              labelStyle: const TextStyle(color: AppColors.sand),
                              filled: true,
                              fillColor: fieldFill,
                              border: border,
                              enabledBorder: border,
                              focusedBorder: border,
                              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                            ),
                            validator: (v) => v == null || v.isEmpty ? 'Required' : null,
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.sand,
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                                ),
                                onPressed: _showUploadOptions,
                                icon: const Icon(Icons.upload_file),
                                label: const Text('Upload/Camera'),
                              ),
                              if (_fileName != null) ...[
                                const SizedBox(width: 12),
                                const Icon(Icons.check_circle, color: AppColors.sand),
                                const SizedBox(width: 4),
                                Text(_fileName!, style: const TextStyle(color: AppColors.sand)),
                              ]
                            ],
                          ),
                          const SizedBox(height: 24),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.sand,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                padding: const EdgeInsets.symmetric(vertical: 18),
                              ),
                              onPressed: _canSend
                                  ? () {
                                      if (_formKey.currentState?.validate() ?? false) {
                                        // Mock send logic
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(content: Text('Bug report sent!')),
                                        );
                                        widget.onClose();
                                      }
                                    }
                                  : null,
                              child: const Text('Send', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ).asGlass(
                  tintColor: Colors.white.withOpacity(0.18),
                  clipBorderRadius: BorderRadius.circular(32),
                  blurX: 20,
                  blurY: 20,
                ),
              ),
              // Cross button
              Positioned(
                top: 16,
                right: 16,
                child: GestureDetector(
                  onTap: widget.onClose,
                  child: Container(
                    padding: const EdgeInsets.all(15),
                    child: const Icon(Icons.close, color: AppColors.sand, size: 32),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
