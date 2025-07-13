import 'package:flutter/material.dart';
import 'glass_profile_popup.dart';

class AppScaffold extends StatelessWidget {
  final Widget body;
  final String firstName;
  final String lastName;
  final bool personalComplete;
  final bool educationComplete;
  final bool professionalComplete;
  final bool certificationsComplete;
  final PreferredSizeWidget? appBar;
  final Widget? bottomNavigationBar;

  const AppScaffold({
    super.key,
    required this.body,
    required this.firstName,
    required this.lastName,
    required this.personalComplete,
    required this.educationComplete,
    required this.professionalComplete,
    required this.certificationsComplete,
    this.appBar,
    this.bottomNavigationBar,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      body: Stack(
        children: [
          body,
          Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: const EdgeInsets.only(top: 32.0, right: 16.0), // Lowered below status bar
              child: GestureDetector(
                onTap: () => showDialog(
                  context: context,
                  builder: (context) => GlassProfilePopup(
                    firstName: firstName,
                    lastName: lastName,
                    personalComplete: personalComplete,
                    educationComplete: educationComplete,
                    professionalComplete: professionalComplete,
                    certificationsComplete: certificationsComplete,
                  ),
                ),
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.white.withOpacity(0.7),
                        Colors.blue.shade100.withOpacity(0.7),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 8,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: CircleAvatar(
                    radius: 24, // Decreased from 32
                    backgroundColor: Colors.transparent,
                    child: Text(
                      firstName.isNotEmpty ? firstName[0] : 'U',
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.deepPurple), // Adjusted font size
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: bottomNavigationBar,
    );
  }
} 