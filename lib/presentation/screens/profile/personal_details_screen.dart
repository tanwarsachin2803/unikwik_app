import 'package:flutter/material.dart';
import 'package:unikwik_app/presentation/widgets/gradient_background.dart';
import 'package:unikwik_app/core/theme/app_colors.dart';
import 'dart:ui';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:glass/glass.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

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

  String? _selectedEmoticon;
  File? _profileImage;
  final List<String> _emoticons = ['😀','😎','🤩','🥳','🦄','👽','🐱','🐶','🐼','🦊','🐸','🐵','🦁','🐯','🐨','🐻','🐷','🐧','🐤','🐙','🦋','🌸','🍕','🍔','🍦','⚽','🏀','🎸','🎮','🚗','✈️','🚀','🌈','⭐','🔥','💎','🎉'];
  String? _selectedSocialApp;
  bool _showSocialToOthers = true;
  final List<Map<String, dynamic>> _socialApps = [
    {'name': 'Snapchat', 'icon': Icons.snapchat},
    {'name': 'Instagram', 'icon': Icons.camera_alt},
    {'name': 'WhatsApp', 'icon': FontAwesomeIcons.whatsapp},
    {'name': 'LinkedIn', 'icon': Icons.business_center},
  ];
  bool _connectingSocial = false;

  bool socialVisible = true;
  Map<String, bool> socialConnected = {
    'LinkedIn': true,
    'Instagram': false,
    'WhatsApp': false,
  };

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

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        _profileImage = File(picked.path);
        _selectedEmoticon = null;
      });
    }
  }

  void _showEmoticonPicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        height: 320,
        padding: const EdgeInsets.all(18),
        child: GridView.count(
          crossAxisCount: 6,
          children: _emoticons.map((e) => GestureDetector(
            onTap: () {
              setState(() {
                _selectedEmoticon = e;
                _profileImage = null;
              });
              Navigator.pop(context);
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: _selectedEmoticon == e ? Colors.white.withOpacity(0.2) : Colors.transparent,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: _selectedEmoticon == e ? Colors.amber : Colors.transparent, width: 2),
              ),
              child: Center(child: Text(e, style: const TextStyle(fontSize: 28))),
            ),
          )).toList(),
        ),
      ).asGlass(blurX: 18, blurY: 18, tintColor: Colors.white.withOpacity(0.18), clipBorderRadius: BorderRadius.circular(24)),
    );
  }

  void _showSocialConnect() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setModalState) => Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Connect Social App', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.white)),
              const SizedBox(height: 18),
              DropdownButtonFormField<String>(
                value: _selectedSocialApp,
                decoration: const InputDecoration(
                  labelText: 'Select the social app',
                  labelStyle: TextStyle(color: Colors.white70),
                  filled: true,
                  fillColor: Colors.white10,
                  border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
                ),
                dropdownColor: Colors.white,
                items: _socialApps.map((app) => DropdownMenuItem<String>(
                  value: app['name'],
                  child: Row(
                    children: [Icon(app['icon'], color: Colors.black), const SizedBox(width: 8), Text(app['name'], style: const TextStyle(color: Colors.black))],
                  ),
                )).toList(),
                onChanged: (val) => setModalState(() => _selectedSocialApp = val),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Switch(
                    value: _showSocialToOthers,
                    onChanged: (val) => setModalState(() => _showSocialToOthers = val),
                    activeColor: Colors.greenAccent,
                  ),
                  const SizedBox(width: 8),
                  Text(_showSocialToOthers ? 'Visible to others' : 'Hidden', style: const TextStyle(color: Colors.white)),
                ],
              ),
              const SizedBox(height: 18),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _selectedSocialApp == null || _connectingSocial
                      ? null
                      : () async {
                          setModalState(() => _connectingSocial = true);
                          await Future.delayed(const Duration(seconds: 2));
                          setModalState(() => _connectingSocial = false);
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Connected to $_selectedSocialApp!'), backgroundColor: Colors.green),
                          );
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _selectedSocialApp != null ? Colors.blueAccent : Colors.grey,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: _connectingSocial
                      ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                      : const Text('Connect', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ).asGlass(blurX: 18, blurY: 18, tintColor: Colors.white.withOpacity(0.18), clipBorderRadius: BorderRadius.circular(24)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: AppColors.deepTeal,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.sand),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('Personal Details', style: TextStyle(color: AppColors.sand)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.sand),
      ),
      body: SafeArea(
            child: Center(
              child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 32),
                // Profile Avatar Section
                AnimatedContainer(
                  duration: const Duration(milliseconds: 400),
                  padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(colors: [Colors.amber, Colors.pinkAccent, Colors.blueAccent]),
                  ),
                  child: CircleAvatar(
                    radius: 54,
                    backgroundColor: Colors.white.withOpacity(0.2),
                    backgroundImage: _profileImage != null ? FileImage(_profileImage!) : null,
                    child: _profileImage == null && _selectedEmoticon != null
                        ? Text(_selectedEmoticon!, style: const TextStyle(fontSize: 48))
                        : _profileImage == null
                            ? const Icon(Icons.person, size: 48, color: Colors.white70)
                            : null,
                  ),
                ),
                const SizedBox(height: 18),
                const Text('Choose your avatar', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
                const SizedBox(height: 6),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Tooltip(
                      message: 'Pick Emoticon',
                      child: ElevatedButton.icon(
                        onPressed: _showEmoticonPicker,
                        icon: const Icon(Icons.emoji_emotions, color: Colors.amber),
                        label: const Text('Use Emoticon'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white.withOpacity(0.18),
                          foregroundColor: Colors.amber,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Tooltip(
                      message: 'Pick Image',
                      child: ElevatedButton.icon(
                        onPressed: _pickImage,
                        icon: const Icon(Icons.image, color: Colors.blueAccent),
                        label: const Text('Use Image'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white.withOpacity(0.18),
                          foregroundColor: Colors.blueAccent,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                // Glassmorphic Form
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                        _glassField(
                          child: Row(
                              children: [
                                Expanded(
                                  child: TextFormField(
                                    controller: _firstNameController,
                                    decoration: const InputDecoration(
                                      labelText: 'First Name',
                                      labelStyle: TextStyle(color: AppColors.sand),
                                    border: InputBorder.none,
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
                                    border: InputBorder.none,
                                    ),
                                    validator: (v) => v == null || v.isEmpty ? 'Required' : null,
                                  ),
                                ),
                              ],
                          ),
                            ),
                            const SizedBox(height: 16),
                        _glassField(
                          child: TextFormField(
                              controller: _dobController,
                              readOnly: true,
                              decoration: InputDecoration(
                                labelText: 'Date of Birth',
                                labelStyle: const TextStyle(color: AppColors.sand),
                              border: InputBorder.none,
                                suffixIcon: IconButton(
                                  icon: const Icon(Icons.calendar_today, color: AppColors.sand),
                                  onPressed: _pickDate,
                                ),
                              ),
                              validator: (v) => v == null || v.isEmpty ? 'Required' : null,
                          ),
                            ),
                            const SizedBox(height: 16),
                        _glassField(
                          child: Row(
                              children: [
                                Expanded(
                                  child: TextFormField(
                                    controller: _passportController,
                                    decoration: InputDecoration(
                                      labelText: 'Passport Number (optional)',
                                      labelStyle: const TextStyle(color: AppColors.sand),
                                    border: InputBorder.none,
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
                                    border: InputBorder.none,
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
                            ),
                            const SizedBox(height: 16),
                        _glassField(
                          child: TextFormField(
                              controller: _emailController,
                              readOnly: true,
                              decoration: const InputDecoration(
                                labelText: 'Email',
                                labelStyle: TextStyle(color: AppColors.sand),
                              border: InputBorder.none,
                            ),
                              ),
                            ),
                            const SizedBox(height: 16),
                        _glassField(
                          child: Row(
                              children: [
                                SizedBox(
                                  width: 100,
                                  child: TextFormField(
                                    controller: _countryCodeController,
                                  readOnly: true,
                                    decoration: const InputDecoration(
                                      labelText: 'Country Code',
                                      labelStyle: TextStyle(color: AppColors.sand),
                                    border: InputBorder.none,
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
                                    border: InputBorder.none,
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
                            ),
                            if (_otpSent && !_phoneVerified) ...[
                              const SizedBox(height: 12),
                          _glassField(
                            child: TextFormField(
                                controller: _otpController,
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                  labelText: 'Enter OTP',
                                  labelStyle: TextStyle(color: AppColors.sand),
                                border: InputBorder.none,
                              ),
                                ),
                              ),
                            ],
                        const SizedBox(height: 24),
                        // Social Section
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Social', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.white)),
                              Row(
                                children: [
                                  const Text('Visible to others?', style: TextStyle(color: Colors.white)),
                                  Switch(
                                    value: socialVisible,
                                    onChanged: (val) => setState(() => socialVisible = val),
                                    activeColor: Colors.blueAccent,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: Column(
                            children: [
                              _buildSocialRow('LinkedIn', FontAwesomeIcons.linkedin, socialConnected['LinkedIn']!),
                              const SizedBox(height: 10),
                              _buildSocialRow('Instagram', FontAwesomeIcons.instagram, socialConnected['Instagram']!),
                              const SizedBox(height: 10),
                              _buildSocialRow('WhatsApp', FontAwesomeIcons.whatsapp, socialConnected['WhatsApp']!),
                            ],
                          ),
                        ),
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
                const SizedBox(height: 48),
              ],
                  ),
                ),
              ),
            ),
    );
  }

  Widget _glassField({required Widget child}) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 2),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.13),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white.withOpacity(0.18)),
      ),
      child: child,
    ).asGlass(
      blurX: 18,
      blurY: 18,
      tintColor: Colors.white.withOpacity(0.13),
      clipBorderRadius: BorderRadius.circular(18),
    );
  }

  Widget _buildSocialRow(String name, IconData icon, bool connected) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.12),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.18)),
      ),
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      child: Row(
        children: [
          FaIcon(icon, color: Colors.white, size: 28),
          const SizedBox(width: 16),
          Expanded(
            child: Text(name, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500)),
          ),
          if (connected)
            TextButton(
              onPressed: () => setState(() => socialConnected[name] = false),
              style: TextButton.styleFrom(
                foregroundColor: Colors.redAccent,
                backgroundColor: Colors.white.withOpacity(0.08),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: const Text('Disconnect (connected)'),
            )
          else
            TextButton(
              onPressed: () => setState(() => socialConnected[name] = true),
              style: TextButton.styleFrom(
                foregroundColor: Colors.blueAccent,
                backgroundColor: Colors.white.withOpacity(0.08),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: const Text('Connect'),
          ),
        ],
      ),
    ).asGlass(
      blurX: 12,
      blurY: 12,
      tintColor: Colors.white.withOpacity(0.18),
      clipBorderRadius: BorderRadius.circular(16),
    );
  }
} 