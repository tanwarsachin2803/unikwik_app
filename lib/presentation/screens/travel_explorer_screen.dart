import 'dart:ui';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart' show rootBundle;
import 'package:unikwik_app/core/theme/app_colors.dart';
import 'package:unikwik_app/presentation/widgets/glass_dropdown_chip.dart';

class TravelExplorerScreen extends StatefulWidget {
  @override
  State<TravelExplorerScreen> createState() => _TravelExplorerScreenState();
}

class _TravelExplorerScreenState extends State<TravelExplorerScreen>
    with TickerProviderStateMixin {
  // API Configuration
  static const String baseUrl = 'http://10.0.2.2:3001/api/visa';
  
  // State variables
  String? selectedVisaType;
  String? selectedCountry;
  Map<String, dynamic>? visaData;
  bool isLoading = false;
  String? errorMessage;
  
  // Animation controllers
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late AnimationController _pulseController;
  
  // Available visa types
  final List<Map<String, dynamic>> visaTypes = [
    {
      'key': 'tourist',
      'name': 'Tourist Visa',
      'description': 'For leisure travel and sightseeing',
      'icon': '🏖️',
      'color': Colors.blue
    },
    {
      'key': 'study',
      'name': 'Student Visa',
      'description': 'For educational purposes and academic programs',
      'icon': '🎓',
      'color': Colors.green
    },
    {
      'key': 'work',
      'name': 'Work Visa',
      'description': 'For employment and professional opportunities',
      'icon': '💼',
      'color': Colors.orange
    },
    {
      'key': 'medical',
      'name': 'Medical Visa',
      'description': 'For healthcare treatment and medical procedures',
      'icon': '🏥',
      'color': Colors.red
    }
  ];

  // Available countries (will be populated from assets)
  List<Map<String, dynamic>> availableCountries = [];

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _loadCountriesFromAssets();
  }

  void _initializeAnimations() {
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    
    // Start animations
    _fadeController.forward();
    _slideController.forward();
    _pulseController.repeat(reverse: true);
  }

  Future<void> _loadCountriesFromAssets() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });
    try {
      final String response = await rootBundle.loadString('assets/countries.json');
      final List<dynamic> data = json.decode(response);
      setState(() {
        availableCountries = List<Map<String, dynamic>>.from(data);
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = 'Failed to load countries list.';
        isLoading = false;
      });
    }
  }

  Future<void> _loadVisaData(String visaType, String country) async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final response = await http.get(Uri.parse('$baseUrl/$visaType/$country'));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success']) {
          setState(() {
            visaData = data;
            isLoading = false;
          });
        }
      } else {
        final errorData = json.decode(response.body);
        setState(() {
          errorMessage = errorData['error'] ?? 'Failed to load visa data';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Network error: $e';
        isLoading = false;
      });
    }
  }

  void _onVisaTypeChanged(Map<String, dynamic>? visaType) {
    setState(() {
      selectedVisaType = visaType?['key'];
      selectedCountry = null;
      visaData = null;
    });
  }

  void _onCountryChanged(Map<String, dynamic>? country) {
    setState(() {
      selectedCountry = country?['key'];
      visaData = null;
    });
    
    if (selectedVisaType != null && selectedCountry != null) {
      _loadVisaData(selectedVisaType!, selectedCountry!);
    }
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Animated Header
                _buildAnimatedHeader(),
                const SizedBox(height: 32),
                
                // Visa Type Selection
                _buildVisaTypeSection(),
                const SizedBox(height: 24),
                
                // Country Selection
                if (selectedVisaType != null) _buildCountrySection(),
                const SizedBox(height: 24),
                
                // Loading Indicator
                if (isLoading) _buildLoadingIndicator(),
                
                // Error Message
                if (errorMessage != null) _buildErrorMessage(),
                
                // Visa Details
                if (visaData != null) _buildVisaDetails(),
                
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAnimatedHeader() {
    return Column(
      children: [
        // Main Title with Animation
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '🌍',
              style: TextStyle(fontSize: 36),
            ).animate(controller: _pulseController)
              .scale(duration: 1500.ms, begin: Offset(1.0, 1.0), end: Offset(1.1, 1.1))
              .then()
              .scale(duration: 1500.ms, begin: Offset(1.1, 1.1), end: Offset(1.0, 1.0)),
            const SizedBox(width: 12),
            Text(
              'Visa Service',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: AppColors.sand,
              ),
            ).animate(controller: _fadeController)
              .fadeIn(duration: 800.ms)
              .slideX(begin: -0.3, end: 0),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          'Find the perfect visa for your journey',
          style: TextStyle(
            fontSize: 16,
            color: AppColors.sand.withOpacity(0.8),
            fontWeight: FontWeight.w500,
          ),
        ).animate(controller: _fadeController)
          .fadeIn(delay: 200.ms, duration: 600.ms)
          .slideY(begin: 0.3, end: 0),
      ],
    );
  }

  Widget _buildVisaTypeSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Select Visa Type',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: AppColors.sand,
          ),
        ).animate(controller: _slideController)
          .fadeIn(delay: 400.ms)
          .slideX(begin: -0.2, end: 0),
        const SizedBox(height: 12),
        
        // Visa Type Cards Grid
        GridView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.2,
          ),
          itemCount: visaTypes.length,
          itemBuilder: (context, index) {
            final visaType = visaTypes[index];
            final isSelected = selectedVisaType == visaType['key'];
            
            return _buildVisaTypeCard(visaType, isSelected);
          },
        ),
      ],
    );
  }

  Widget _buildVisaTypeCard(Map<String, dynamic> visaType, bool isSelected) {
    return GestureDetector(
      onTap: () => _onVisaTypeChanged(visaType),
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        decoration: BoxDecoration(
          color: isSelected 
            ? visaType['color'].withOpacity(0.2)
            : Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected 
              ? visaType['color']
              : Colors.white.withOpacity(0.2),
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected ? [
            BoxShadow(
              color: visaType['color'].withOpacity(0.3),
              blurRadius: 8,
              offset: Offset(0, 4),
            )
          ] : null,
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                visaType['icon'],
                style: TextStyle(fontSize: 32),
              ),
              const SizedBox(height: 8),
              Text(
                visaType['name'],
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: isSelected ? visaType['color'] : AppColors.sand,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Text(
                visaType['description'],
                style: TextStyle(
                  fontSize: 11,
                  color: AppColors.sand.withOpacity(0.7),
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ).animate()
        .fadeIn(delay: (100 * visaTypes.indexOf(visaType)).ms)
        .slideY(begin: 0.3, end: 0),
    );
  }

  Widget _buildCountrySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Select Destination Country',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: AppColors.sand,
          ),
        ),
        const SizedBox(height: 12),
        
        if (availableCountries.isEmpty && !isLoading)
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white.withOpacity(0.2)),
            ),
            child: Row(
              children: [
                Icon(Icons.info_outline, color: Colors.orange),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'No countries available for this visa type',
                    style: TextStyle(color: AppColors.sand),
                  ),
                ),
              ],
            ),
          )
        else
          GlassDropdownChip<Map<String, dynamic>>(
            options: availableCountries,
            selectedValue: selectedCountry == null ? null 
              : availableCountries.firstWhere(
                  (c) => c['key'] == selectedCountry,
                  orElse: () => availableCountries.first,
                ),
            labelBuilder: (country) => country['name'],
            leadingBuilder: (country) => Text(
              country['flag'],
              style: TextStyle(fontSize: 20),
            ),
            placeholder: 'Select Country',
            onChanged: _onCountryChanged,
          ),
      ],
    ).animate()
      .fadeIn(delay: 200.ms)
      .slideY(begin: 0.2, end: 0);
  }

  Widget _buildLoadingIndicator() {
    return Container(
      padding: EdgeInsets.all(24),
            child: Column(
              children: [
          SpinKitFadingCircle(
            color: AppColors.sand,
            size: 40,
          ),
          SizedBox(height: 16),
          Text(
            'Loading visa information...',
            style: TextStyle(
              color: AppColors.sand,
              fontSize: 14,
            ),
          ),
      ],
      ),
    ).animate()
      .fadeIn()
      .scale(begin: Offset(0.8, 0.8), end: Offset(1.0, 1.0));
  }

  Widget _buildErrorMessage() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 16),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.red.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.red.withOpacity(0.3)),
      ),
              child: Row(
                children: [
          Icon(Icons.error_outline, color: Colors.red),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              errorMessage!,
              style: TextStyle(color: Colors.red[100]),
            ),
          ),
        ],
      ),
    ).animate()
      .fadeIn()
      .shake(duration: 600.ms);
  }

  Widget _buildVisaDetails() {
    if (visaData == null) return SizedBox.shrink();
    
    final country = visaData!['country'];
    final generalRequirements = visaData!['general_requirements'] as List;
    final commonFees = visaData!['common_fees'];
    final processingTimes = visaData!['processing_times'];
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Country Header
        Container(
          padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.blue.withOpacity(0.2),
                Colors.purple.withOpacity(0.2),
              ],
            ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white.withOpacity(0.2)),
          ),
          child: Row(
            children: [
              Text(
                country['flag'],
                style: TextStyle(fontSize: 48),
              ),
              SizedBox(width: 16),
              Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                    Text(
                      country['name'],
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppColors.sand,
                      ),
                    ),
                    Text(
                      '${visaData!['visa_type'].toString().toUpperCase()} VISA',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.sand,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        
        SizedBox(height: 20),
        
        // Requirements Section
        _buildExpandableSection(
          title: 'Requirements',
          icon: Icons.checklist,
          color: Colors.green,
          children: [
            ...country['requirements'].map<Widget>((req) => 
              ListTile(
                leading: Icon(Icons.check_circle, color: Colors.green, size: 20),
                title: Text(
                  req,
                  style: TextStyle(fontSize: 14,color: AppColors.sand),
                ),
                dense: true,
                contentPadding: EdgeInsets.symmetric(horizontal: 16),
              ),
            ),
          ],
        ),
        
        SizedBox(height: 16),
        
        // Fees Section
        _buildExpandableSection(
          title: 'Fees & Processing',
          icon: Icons.payment,
          color: Colors.orange,
          children: [
            _buildInfoRow('Visa Fee', '${country['fees']['visa_fee']} ${country['fees']['currency']}'),
            _buildInfoRow('Service Fee', '${country['fees']['service_fee']} ${country['fees']['currency']}'),
            _buildInfoRow('Processing Time', country['processing_time']),
            _buildInfoRow('Validity', country['validity']),
            _buildInfoRow('Max Stay', country['max_stay']),
          ],
        ),
        
        SizedBox(height: 16),
        
        // General Requirements
        if (generalRequirements.isNotEmpty)
          _buildExpandableSection(
            title: 'General Requirements',
            icon: Icons.info,
            color: Colors.blue,
            children: [
              ...generalRequirements.map<Widget>((req) => 
                ListTile(
                  leading: Icon(Icons.arrow_right, color: Colors.blue, size: 20),
                  title: Text(
                    req,
                    style: TextStyle(fontSize: 14,color: AppColors.sand),
                  ),
                  dense: true,
                  contentPadding: EdgeInsets.symmetric(horizontal: 16),
                ),
              ),
            ],
          ),
        
        SizedBox(height: 20),
        
        // Action Buttons
        Row(
              children: [
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () {
                  // TODO: Implement application process
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Application process coming soon!')),
                  );
                },
                icon: Icon(Icons.assignment),
                label: Text('Start Application'),
                  style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.sand,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () {
                  // TODO: Implement save/bookmark
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Saved to favorites!')),
                  );
                },
                icon: Icon(Icons.bookmark_border),
                label: Text('Save'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.sand,
                  side: BorderSide(color: AppColors.sand),
                  padding: EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    ).animate()
      .fadeIn(delay: 300.ms)
      .slideY(begin: 0.3, end: 0);
  }

  Widget _buildExpandableSection({
    required String title,
    required IconData icon,
    required Color color,
    required List<Widget> children,
  }) {
    return ExpansionTile(
      leading: Icon(icon, color: color),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.w600,
          color: AppColors.sand,
        ),
      ),
      children: children,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      backgroundColor: Colors.white.withOpacity(0.05),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: AppColors.sand.withOpacity(0.8),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.sand,
            ),
          ),
        ],
      ),
    );
  }
} 