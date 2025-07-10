import 'package:flutter/material.dart';
import 'package:unikwik_app/presentation/widgets/gradient_background.dart';
import 'package:unikwik_app/core/theme/app_colors.dart';
import 'dart:ui';

class PersonalDetailsScreen extends StatefulWidget {
  const PersonalDetailsScreen({super.key});

  @override
  State<PersonalDetailsScreen> createState() => _PersonalDetailsScreenState();
}

class _PersonalDetailsScreenState extends State<PersonalDetailsScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _passportController = TextEditingController();
  final TextEditingController _panController = TextEditingController();
  final TextEditingController _emailController = TextEditingController(text: 'user@email.com');
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _countryCodeController = TextEditingController(text: '+91');
  final TextEditingController _otpController = TextEditingController();

  bool _passportVerified = false;
  bool _panVerified = false;
  bool _otpSent = false;
  bool _phoneVerified = false;

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _dobController.dispose();
    _passportController.dispose();
    _panController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _countryCodeController.dispose();
    _otpController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2000, 1, 1),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      _dobController.text = '${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}';
    }
  }

  void _mockVerifyPassport() {
    setState(() {
      _passportVerified = true;
    });
  }

  void _mockVerifyPan() {
    setState(() {
      _panVerified = true;
    });
  }

  void _mockSendOtp() {
    setState(() {
      _otpSent = true;
    });
  }

  void _mockVerifyOtp() {
    setState(() {
      _phoneVerified = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: Stack(
        children: [
          const GradientBackground(),
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(32),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                    child: Container(
                      width: 380,
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.18),
                        borderRadius: BorderRadius.circular(32),
                        border: Border.all(color: AppColors.sand.withOpacity(0.3)),
                      ),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Personal Details', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.sand)),
                            const SizedBox(height: 24),
                            Row(
                              children: [
                                Expanded(
                                  child: TextFormField(
                                    controller: _firstNameController,
                                    decoration: const InputDecoration(
                                      labelText: 'First Name',
                                      labelStyle: TextStyle(color: AppColors.sand),
                                    ),
                                    validator: (v) => v == null || v.isEmpty ? 'Required' : null,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: TextFormField(
                                    controller: _lastNameController,
                                    decoration: const InputDecoration(
                                      labelText: 'Last Name',
                                      labelStyle: TextStyle(color: AppColors.sand),
                                    ),
                                    validator: (v) => v == null || v.isEmpty ? 'Required' : null,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            TextFormField(
                              controller: _dobController,
                              readOnly: true,
                              decoration: InputDecoration(
                                labelText: 'Date of Birth',
                                labelStyle: const TextStyle(color: AppColors.sand),
                                suffixIcon: IconButton(
                                  icon: const Icon(Icons.calendar_today, color: AppColors.sand),
                                  onPressed: _pickDate,
                                ),
                              ),
                              validator: (v) => v == null || v.isEmpty ? 'Required' : null,
                            ),
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                Expanded(
                                  child: TextFormField(
                                    controller: _passportController,
                                    decoration: InputDecoration(
                                      labelText: 'Passport Number (optional)',
                                      labelStyle: const TextStyle(color: AppColors.sand),
                                      suffixIcon: _passportVerified
                                          ? const Icon(Icons.check_circle, color: AppColors.sand)
                                          : IconButton(
                                              icon: const Icon(Icons.verified, color: AppColors.sand),
                                              onPressed: _mockVerifyPassport,
                                            ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: TextFormField(
                                    controller: _panController,
                                    decoration: InputDecoration(
                                      labelText: 'PAN Card (optional)',
                                      labelStyle: const TextStyle(color: AppColors.sand),
                                      suffixIcon: _panVerified
                                          ? const Icon(Icons.check_circle, color: AppColors.sand)
                                          : IconButton(
                                              icon: const Icon(Icons.verified, color: AppColors.sand),
                                              onPressed: _mockVerifyPan,
                                            ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            TextFormField(
                              controller: _emailController,
                              readOnly: true,
                              decoration: const InputDecoration(
                                labelText: 'Email',
                                labelStyle: TextStyle(color: AppColors.sand),
                              ),
                            ),
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                SizedBox(
                                  width: 100,
                                  child: TextFormField(
                                    controller: _countryCodeController,
                                    readOnly: true, // For now, make it static; can add picker later
                                    decoration: const InputDecoration(
                                      labelText: 'Country Code',
                                      labelStyle: TextStyle(color: AppColors.sand),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: TextFormField(
                                    controller: _phoneController,
                                    keyboardType: TextInputType.phone,
                                    decoration: InputDecoration(
                                      labelText: 'Phone Number',
                                      labelStyle: const TextStyle(color: AppColors.sand),
                                      suffixIcon: _phoneVerified
                                          ? const Icon(Icons.check_circle, color: AppColors.sand)
                                          : _otpSent
                                              ? IconButton(
                                                  icon: const Icon(Icons.verified, color: AppColors.sand),
                                                  onPressed: _mockVerifyOtp,
                                                )
                                              : IconButton(
                                                  icon: const Icon(Icons.send, color: AppColors.sand),
                                                  onPressed: _mockSendOtp,
                                                ),
                                    ),
                                    validator: (v) => v == null || v.isEmpty ? 'Required' : null,
                                  ),
                                ),
                              ],
                            ),
                            if (_otpSent && !_phoneVerified) ...[
                              const SizedBox(height: 12),
                              TextFormField(
                                controller: _otpController,
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                  labelText: 'Enter OTP',
                                  labelStyle: TextStyle(color: AppColors.sand),
                                ),
                              ),
                            ],
                            const SizedBox(height: 32),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.sand,
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                  padding: const EdgeInsets.symmetric(vertical: 16),
                                ),
                                onPressed: () {
                                  if (_formKey.currentState?.validate() ?? false) {
                                    // Save or publish logic here
                                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Details saved!')));
                                  }
                                },
                                child: const Text('Save', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
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