// auth_screen.dart — Pixel-perfect glass-morphic sign-in
// Drop this file into /lib and set as home in main.dart to get
// the exact visual shown in the reference mock.

import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:unikwik_app/core/theme/app_colors.dart';
import 'package:unikwik_app/presentation/widgets/widgets.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'dart:io' show Platform;

void main() => runApp(const MaterialApp(debugShowCheckedModeBanner: false, home: AuthScreen()));

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool isSignIn = true;

  // GoogleSignIn instance
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<void> _handleGoogleSignIn() async {
    try {
      final account = await _googleSignIn.signIn();
      if (account != null) {
        // For now, just show a success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Signed in as: ${account.email}')),
        );
      } else {
        // User cancelled
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Google sign-in cancelled.')),
        );
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Google sign-in failed: ${error.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final cardWidth = size.width * 0.9 > 500 ? 500.0 : size.width * 0.9;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          const GradientBackground(),
          Center(
            child: GlassContainer(
              padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
              constraints: BoxConstraints(maxWidth: cardWidth),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(isSignIn ? 'Sign In' : 'Sign Up',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                            color: AppColors.deepTeal.withOpacity(.9),
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.3,
                          )),
                  const SizedBox(height: 28),
                  _buildInputField(hint: 'Email address'),
                  const SizedBox(height: 16),
                  _buildInputField(hint: 'Password', obscure: true),
                  const SizedBox(height: 24),
                  SizedBox(
                    height: 52,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.steelBlue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                      ),
                      onPressed: () {},
                      child: Text(isSignIn ? 'Sign in' : 'Sign up', style: const TextStyle(fontSize: 18)),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(children: [
                    Expanded(child: Divider(color: AppColors.deepTeal.withOpacity(.3))),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text('or', style: TextStyle(letterSpacing: 1)),
                    ),
                    Expanded(child: Divider(color: AppColors.deepTeal.withOpacity(.3))),
                  ]),
                  const SizedBox(height: 20),
                  _SocialButton(
                      label: 'Sign in with Google',
                      assetName: 'assets/svg/google_logo.svg',
                      onTap: _handleGoogleSignIn),
                  const SizedBox(height: 12),
                  ...Platform.isIOS
                      ? [
                          _SocialButton(
                            label: 'Sign in with Apple',
                            assetName: 'assets/svg/apple_logo.svg',
                            onTap: () {}),
                          const SizedBox(height: 12),
                        ]
                      : [],
                  _SocialButton(
                      label: 'Sign in with Microsoft',
                      assetName: 'assets/svg/ms_logo.svg',
                      onTap: () {}),
                  const SizedBox(height: 24),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        isSignIn = !isSignIn;
                      });
                    },
                    child: Text(
                      isSignIn ? 'Create new account' : 'Login',
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputField({required String hint, bool obscure = false}) {
    return TextField(
      obscureText: obscure,
      style: const TextStyle(color: Colors.black87),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.black54),
        filled: true,
        fillColor: Colors.white.withOpacity(0.6),
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}

class _SocialButton extends StatelessWidget {
  const _SocialButton({required this.label, this.icon, this.assetName, required this.onTap});

  final String label;
  final IconData? icon;
  final String? assetName; // for SVG logo
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          elevation: 0,
          foregroundColor: AppColors.deepTeal,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
        onPressed: onTap,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (assetName != null) ...[
              SizedBox(
                height: 20,
                width: 20,
                child: SvgPicture.asset(assetName!, fit: BoxFit.contain),
              ),
              const SizedBox(width: 12),
            ],
            Text(label,
                style: const TextStyle(
                    fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.deepTeal)),
          ],
        ),
      ),
    );
  }
}