import 'package:flutter/material.dart';
import 'package:unikwik_app/presentation/widgets/glass_dropdown_chip.dart';
import 'package:glass/glass.dart';
import 'package:unikwik_app/core/theme/app_colors.dart';

class ExamPrepScreen extends StatefulWidget {
  const ExamPrepScreen({super.key});

  @override
  State<ExamPrepScreen> createState() => _ExamPrepScreenState();
}

class _ExamPrepScreenState extends State<ExamPrepScreen> {
  final List<String> _languages = [
    'English', 'French', 'German', 'Spanish', 'Italian', 'Chinese', 'Japanese'
  ];
  String _selectedLanguage = 'English';

  // Mock data for exams by language
  final Map<String, List<ExamData>> _examsByLanguage = {
    'English': [
      ExamData(
        name: 'IELTS',
        fullName: 'International English Language Testing System',
        description: 'Most popular English proficiency test for study, work, and migration',
        duration: '2 hours 45 minutes',
        validity: '2 years',
        fee: '\$200-250',
        difficulty: 'Intermediate to Advanced',
        icon: '🇬🇧',
      ),
      ExamData(
        name: 'TOEFL',
        fullName: 'Test of English as a Foreign Language',
        description: 'Academic English test for university admissions',
        duration: '3 hours',
        validity: '2 years',
        fee: '\$180-300',
        difficulty: 'Intermediate to Advanced',
        icon: '🇺🇸',
      ),
      ExamData(
        name: 'PTE',
        fullName: 'Pearson Test of English',
        description: 'Computer-based English test with quick results',
        duration: '2 hours 15 minutes',
        validity: '2 years',
        fee: '\$150-200',
        difficulty: 'Intermediate to Advanced',
        icon: '🇬🇧',
      ),
      ExamData(
        name: 'Cambridge',
        fullName: 'Cambridge English Qualifications',
        description: 'Traditional English exams for different levels',
        duration: 'Varies by level',
        validity: 'Lifetime',
        fee: '\$150-250',
        difficulty: 'Beginner to Advanced',
        icon: '🇬🇧',
      ),
    ],
    'French': [
      ExamData(
        name: 'DELF',
        fullName: 'Diplôme d\'études en langue française',
        description: 'Official French proficiency diploma',
        duration: '1.5-4 hours',
        validity: 'Lifetime',
        fee: '€100-200',
        difficulty: 'Beginner to Advanced',
        icon: '🇫🇷',
      ),
      ExamData(
        name: 'DALF',
        fullName: 'Diplôme approfondi de langue française',
        description: 'Advanced French proficiency diploma',
        duration: '3-4 hours',
        validity: 'Lifetime',
        fee: '€200-300',
        difficulty: 'Advanced',
        icon: '🇫🇷',
      ),
      ExamData(
        name: 'TCF',
        fullName: 'Test de connaissance du français',
        description: 'French knowledge test for immigration',
        duration: '1.5 hours',
        validity: '2 years',
        fee: '€80-150',
        difficulty: 'All levels',
        icon: '🇫🇷',
      ),
    ],
    'German': [
      ExamData(
        name: 'TestDaF',
        fullName: 'Test Deutsch als Fremdsprache',
        description: 'German test for university admission',
        duration: '3 hours 10 minutes',
        validity: 'Unlimited',
        fee: '€195',
        difficulty: 'Advanced',
        icon: '🇩🇪',
      ),
      ExamData(
        name: 'Goethe',
        fullName: 'Goethe-Zertifikat',
        description: 'German language certificates',
        duration: 'Varies by level',
        validity: 'Lifetime',
        fee: '€80-200',
        difficulty: 'Beginner to Advanced',
        icon: '🇩🇪',
      ),
      ExamData(
        name: 'DSH',
        fullName: 'Deutsche Sprachprüfung für den Hochschulzugang',
        description: 'German language exam for university access',
        duration: '3-4 hours',
        validity: 'Unlimited',
        fee: '€100-150',
        difficulty: 'Advanced',
        icon: '🇩🇪',
      ),
    ],
    'Spanish': [
      ExamData(
        name: 'DELE',
        fullName: 'Diplomas de Español como Lengua Extranjera',
        description: 'Official Spanish proficiency diplomas',
        duration: '2-4 hours',
        validity: 'Lifetime',
        fee: '€100-200',
        difficulty: 'Beginner to Advanced',
        icon: '🇪🇸',
      ),
      ExamData(
        name: 'SIELE',
        fullName: 'Servicio Internacional de Evaluación de la Lengua Española',
        description: 'International Spanish evaluation service',
        duration: '2.5 hours',
        validity: '5 years',
        fee: '€120-150',
        difficulty: 'All levels',
        icon: '🇪🇸',
      ),
    ],
    'Italian': [
      ExamData(
        name: 'CELI',
        fullName: 'Certificato di Conoscenza della Lingua Italiana',
        description: 'Italian language knowledge certificate',
        duration: '2-4 hours',
        validity: 'Lifetime',
        fee: '€80-150',
        difficulty: 'Beginner to Advanced',
        icon: '🇮🇹',
      ),
      ExamData(
        name: 'CILS',
        fullName: 'Certificazione di Italiano come Lingua Straniera',
        description: 'Italian as foreign language certification',
        duration: '2-4 hours',
        validity: 'Lifetime',
        fee: '€80-150',
        difficulty: 'Beginner to Advanced',
        icon: '🇮🇹',
      ),
    ],
    'Chinese': [
      ExamData(
        name: 'HSK',
        fullName: 'Hanyu Shuiping Kaoshi',
        description: 'Chinese proficiency test',
        duration: '1-2 hours',
        validity: '2 years',
        fee: '¥200-600',
        difficulty: 'Beginner to Advanced',
        icon: '🇨🇳',
      ),
      ExamData(
        name: 'HSKK',
        fullName: 'Hanyu Shuiping Kouyu Kaoshi',
        description: 'Chinese speaking proficiency test',
        duration: '15-25 minutes',
        validity: '2 years',
        fee: '¥200-300',
        difficulty: 'Beginner to Advanced',
        icon: '🇨🇳',
      ),
    ],
    'Japanese': [
      ExamData(
        name: 'JLPT',
        fullName: 'Japanese Language Proficiency Test',
        description: 'Japanese proficiency test',
        duration: '1.5-3 hours',
        validity: 'Lifetime',
        fee: '¥5,500-7,500',
        difficulty: 'Beginner to Advanced',
        icon: '🇯🇵',
      ),
      ExamData(
        name: 'JFT',
        fullName: 'Japan Foundation Test',
        description: 'Japanese foundation test for work',
        duration: '1 hour',
        validity: '2 years',
        fee: 'Free',
        difficulty: 'Beginner to Intermediate',
        icon: '🇯🇵',
      ),
    ],
  };

  List<ExamData> get _filteredExams => _examsByLanguage[_selectedLanguage] ?? [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          // You can add your app's gradient or themed background here if needed
          Padding(
            padding: const EdgeInsets.only(top: 48, left: 24, right: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top row: Avatar and Exam Prep
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: AppColors.sand.withOpacity(0.5),
                        shape: BoxShape.circle,
                      ),
                      alignment: Alignment.center,
                      child: const Text('U', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22, color: Colors.white)),
                    ),
                    const SizedBox(width: 16),
                    const Text(
                      'Exam Prep',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                // Language dropdown
                GlassDropdownChip<String>(
                  options: _languages,
                  selectedValue: _selectedLanguage,
                  onChanged: (val) {
                    if (val != null) setState(() => _selectedLanguage = val);
                  },
                  labelBuilder: (l) => l,
                  placeholder: 'Select language',
                  blur: 12,
                  blurDropdown: 12,
                  chipTint: Colors.white.withOpacity(0.13),
                  dropdownTint: Colors.white.withOpacity(0.13),
                  isActive: true,
                ),
                const SizedBox(height: 32),
                // Exam cards grid
                Expanded(
                  child: _filteredExams.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.school, size: 80, color: Colors.white.withOpacity(0.5)),
                              const SizedBox(height: 16),
                              Text(
                                'No exams available for $_selectedLanguage',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.white.withOpacity(0.7),
                                ),
                              ),
                            ],
                          ),
                        )
                      : GridView.builder(
                          padding: EdgeInsets.zero,
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: 18,
                            crossAxisSpacing: 18,
                            childAspectRatio: 0.85,
                          ),
                          itemCount: _filteredExams.length,
                          itemBuilder: (context, i) {
                            final exam = _filteredExams[i];
                            return _buildExamCard(exam);
                          },
                        ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExamCard(ExamData exam) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Exam icon and name
          Row(
            children: [
              Text(
                exam.icon,
                style: const TextStyle(fontSize: 24),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  exam.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.white,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          // Full name
          Text(
            exam.fullName,
            style: TextStyle(
              fontSize: 12,
              color: Colors.white.withOpacity(0.8),
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 12),
          // Duration and fee
          _buildInfoRow('⏱️', exam.duration),
          const SizedBox(height: 4),
          _buildInfoRow('💰', exam.fee),
          const SizedBox(height: 4),
          _buildInfoRow('📅', exam.validity),
          const Spacer(),
          // Difficulty
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              exam.difficulty,
              style: const TextStyle(
                fontSize: 10,
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    ).asGlass(
      tintColor: AppColors.sand.withOpacity(0.18),
      blurX: 12,
      blurY: 12,
      clipBorderRadius: BorderRadius.circular(22),
    );
  }

  Widget _buildInfoRow(String icon, String text) {
    return Row(
      children: [
        Text(icon, style: const TextStyle(fontSize: 12)),
        const SizedBox(width: 4),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 11,
              color: Colors.white.withOpacity(0.7),
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}

class ExamData {
  final String name;
  final String fullName;
  final String description;
  final String duration;
  final String validity;
  final String fee;
  final String difficulty;
  final String icon;

  ExamData({
    required this.name,
    required this.fullName,
    required this.description,
    required this.duration,
    required this.validity,
    required this.fee,
    required this.difficulty,
    required this.icon,
  });
} 