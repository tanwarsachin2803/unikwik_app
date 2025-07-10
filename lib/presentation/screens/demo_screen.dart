import 'package:flutter/material.dart';
import 'package:unikwik_app/presentation/widgets/widgets.dart';
import 'package:unikwik_app/core/theme/app_colors.dart';

class DemoScreen extends StatelessWidget {
  const DemoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Reusable gradient background
          const GradientBackground(),
          
          // Content with multiple glass containers
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  const SizedBox(height: 40),
                  
                  // Example 1: Simple glass container
                  GlassContainer(
                    padding: const EdgeInsets.all(20),
                    child: const Text(
                      'Simple Glass Container',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.deepTeal,
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 20),
                  
                  // Example 2: Glass container with custom blur
                  GlassContainer(
                    padding: const EdgeInsets.all(20),
                    blurX: 30,
                    blurY: 30,
                    tintColor: Colors.white.withOpacity(0.2),
                    child: const Text(
                      'Custom Blur Glass Container',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.deepTeal,
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 20),
                  
                  // Example 3: Glass container with different border radius
                  GlassContainer(
                    padding: const EdgeInsets.all(20),
                    borderRadius: 50,
                    child: const Text(
                      'Rounded Glass Container',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.deepTeal,
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 20),
                  
                  // Example 4: Glass container with form-like content
                  GlassContainer(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Text(
                          'Form Example',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: AppColors.deepTeal,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        TextField(
                          decoration: InputDecoration(
                            hintText: 'Enter your name',
                            filled: true,
                            fillColor: Colors.white.withOpacity(0.6),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.steelBlue,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text('Submit'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
} 