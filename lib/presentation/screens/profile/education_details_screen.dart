import 'package:flutter/material.dart';
import 'package:unikwik_app/core/theme/app_colors.dart';
import 'package:glass/glass.dart';
import 'package:unikwik_app/presentation/widgets/gradient_background.dart';

class EducationEntry {
  final String level;
  final String courseName;
  final String universityName;
  final String fromYear;
  final String? toYear;
  final bool pursuing;
  final String percentage;
  final String? documentNumber;
  final String? certificatePath;
  final bool verified;

  EducationEntry({
    required this.level,
    required this.courseName,
    required this.universityName,
    required this.fromYear,
    this.toYear,
    this.pursuing = false,
    required this.percentage,
    this.documentNumber,
    this.certificatePath,
    this.verified = false,
  });
}

class EducationDetailsScreen extends StatefulWidget {
  const EducationDetailsScreen({super.key});

  @override
  State<EducationDetailsScreen> createState() => _EducationDetailsScreenState();
}

class _EducationDetailsScreenState extends State<EducationDetailsScreen> {
  final List<EducationEntry> _entries = [];
  bool _showAddForm = false;
  EducationEntry? _editingEntry;
  int? _editingIndex;

  void _openAddEducation() {
    setState(() {
      _editingEntry = null;
      _editingIndex = null;
      _showAddForm = true;
    });
  }

  void _openEditEducation(EducationEntry entry, int index) {
    setState(() {
      _editingEntry = entry;
      _editingIndex = index;
      _showAddForm = true;
    });
  }

  void _closeAddEducation() {
    setState(() {
      _showAddForm = false;
      _editingEntry = null;
      _editingIndex = null;
    });
  }

  void _addOrEditEducation(EducationEntry entry) {
    setState(() {
      if (_editingIndex != null) {
        _entries[_editingIndex!] = entry;
      } else {
        _entries.add(entry);
      }
      _showAddForm = false;
      _editingEntry = null;
      _editingIndex = null;
    });
  }

  void _removeEducation(int index) {
    setState(() {
      _entries.removeAt(index);
    });
  }

  Future<void> _showCardMenu(BuildContext context, Offset tapPosition, int index) async {
    final selected = await showMenu<String>(
      context: context,
      position: RelativeRect.fromLTRB(
        tapPosition.dx,
        tapPosition.dy,
        tapPosition.dx + 1,
        tapPosition.dy + 1,
      ),
      items: [
        const PopupMenuItem(value: 'edit', child: Text('Edit')),
        const PopupMenuItem(value: 'remove', child: Text('Remove')),
      ],
    );
    if (selected == 'edit') {
      _openEditEducation(_entries[index], index);
    } else if (selected == 'remove') {
      _removeEducation(index);
    }
  }

  Offset? _tapPosition;

  @override
  Widget build(BuildContext context) {
    final double topPadding = MediaQuery.of(context).padding.top + kToolbarHeight;
    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBodyBehindAppBar: true,
      extendBody: true,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.sand),
          onPressed: () {
            Navigator.of(context).popUntil((route) => route.isFirst);
          },
        ),
        title: const Text('Education Details', style: TextStyle(color: AppColors.sand)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.sand),
      ),
      body: Stack(
        children: [
          const GradientBackground(),
          Column(
            children: [
              SizedBox(height: topPadding),
              Expanded(
                child: _entries.isEmpty
                    ? const Center(child: Text('No education details added yet.', style: TextStyle(color: AppColors.sand)))
                    : ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: _entries.length,
                        itemBuilder: (context, index) {
                          final entry = _entries[index];
                          return GestureDetector(
                            onTapDown: (details) {
                              _tapPosition = details.globalPosition;
                            },
                            onLongPress: () {
                              if (_tapPosition != null) {
                                _showCardMenu(context, _tapPosition!, index);
                              }
                            },
                            child: Card(
                              color: Colors.white.withOpacity(0.18),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                              margin: const EdgeInsets.symmetric(vertical: 8),
                              child: ListTile(
                                contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                                leading: Icon(Icons.school, color: AppColors.sand),
                                title: Text(
                                  '${entry.level} - ${entry.courseName}',
                                  style: const TextStyle(color: AppColors.sand, fontWeight: FontWeight.bold),
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    if (entry.universityName.isNotEmpty)
                                      Text(entry.universityName, style: const TextStyle(color: AppColors.sand)),
                                    Row(
                                      children: [
                                        Text('Years: ', style: const TextStyle(color: AppColors.sand, fontWeight: FontWeight.w600)),
                                        Text(
                                          entry.fromYear +
                                              (entry.pursuing
                                                  ? ' - Pursuing'
                                                  : (entry.toYear != null && entry.toYear!.isNotEmpty ? ' - ${entry.toYear}' : '')),
                                          style: const TextStyle(color: AppColors.sand),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Text('Percentage/CGPA: ', style: const TextStyle(color: AppColors.sand, fontWeight: FontWeight.w600)),
                                        Text(entry.percentage, style: const TextStyle(color: AppColors.sand)),
                                      ],
                                    ),
                                    if (entry.documentNumber != null && entry.documentNumber!.isNotEmpty)
                                      Row(
                                        children: [
                                          Text('Doc #: ', style: const TextStyle(color: AppColors.sand, fontWeight: FontWeight.w600)),
                                          Text(entry.documentNumber!, style: const TextStyle(color: AppColors.sand)),
                                        ],
                                      ),
                                    Row(
                                      children: [
                                        Text('Certificate: ', style: const TextStyle(color: AppColors.sand, fontWeight: FontWeight.w600)),
                                        if (entry.certificatePath != null)
                                          Text('Uploaded', style: const TextStyle(color: AppColors.sand))
                                        else
                                          Text('Not Uploaded', style: const TextStyle(color: AppColors.sand)),
                                      ],
                                    ),
                                  ],
                                ),
                                trailing: entry.verified && entry.certificatePath != null
                                    ? const Icon(Icons.check_circle, color: Colors.green)
                                    : null,
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
          if (_showAddForm)
            AddEducationOverlay(
              onClose: _closeAddEducation,
              onSave: _addOrEditEducation,
              entry: _editingEntry,
            ),
        ],
      ),
      floatingActionButton: _showAddForm
        ? null
        : FloatingActionButton(
            backgroundColor: AppColors.sand,
            foregroundColor: Colors.white,
            onPressed: _openAddEducation,
            child: const Icon(Icons.add),
          ),
    );
  }
}

class AddEducationOverlay extends StatefulWidget {
  final VoidCallback onClose;
  final Function(EducationEntry) onSave;
  final EducationEntry? entry;
  const AddEducationOverlay({super.key, required this.onClose, required this.onSave, this.entry});

  @override
  State<AddEducationOverlay> createState() => _AddEducationOverlayState();
}

class _AddEducationOverlayState extends State<AddEducationOverlay> {
  final _formKey = GlobalKey<FormState>();
  late String _level;
  late TextEditingController _courseController;
  late TextEditingController _universityController;
  late TextEditingController _fromYearController;
  late TextEditingController _toYearController;
  late bool _pursuing;
  late TextEditingController _percentageController;
  late TextEditingController _documentNumberController;
  String? _certificatePath;
  bool _verified = false;

  final List<String> _levels = [
    '10', '12', 'Bachelors', 'Masters', 'PhD', 'Diploma', 'Pg Diploma', 'CFA', 'CA', 'Other'
  ];

  @override
  void initState() {
    super.initState();
    final entry = widget.entry;
    _level = entry?.level ?? 'Bachelors';
    _courseController = TextEditingController(text: entry?.courseName ?? '');
    _universityController = TextEditingController(text: entry?.universityName ?? '');
    _fromYearController = TextEditingController(text: entry?.fromYear ?? '');
    _toYearController = TextEditingController(text: entry?.toYear ?? '');
    _pursuing = entry?.pursuing ?? false;
    _percentageController = TextEditingController(text: entry?.percentage ?? '');
    _documentNumberController = TextEditingController(text: entry?.documentNumber ?? '');
    _certificatePath = entry?.certificatePath;
    _verified = entry?.verified ?? false;
  }

  @override
  void dispose() {
    _courseController.dispose();
    _universityController.dispose();
    _fromYearController.dispose();
    _toYearController.dispose();
    _percentageController.dispose();
    _documentNumberController.dispose();
    super.dispose();
  }

  void _mockUploadCertificate() async {
    setState(() {
      _certificatePath = 'mock_certificate.png';
      _verified = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height * 0.95;
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
                          const SizedBox(height: 40),
                          Text(
                            widget.entry == null ? 'Add Education' : 'Edit Education',
                            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.sand),
                          ),
                          const SizedBox(height: 18),
                          SizedBox(
                            width: double.infinity,
                            child: DropdownButtonFormField<String>(
                              value: _level,
                              items: _levels.map((l) => DropdownMenuItem(value: l, child: Text(l))).toList(),
                              onChanged: (v) => setState(() => _level = v ?? 'Bachelors'),
                              decoration: InputDecoration(
                                labelText: 'Level',
                                labelStyle: const TextStyle(color: AppColors.sand),
                                filled: true,
                                fillColor: fieldFill,
                                border: border,
                                enabledBorder: border,
                                focusedBorder: border,
                                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          SizedBox(
                            width: double.infinity,
                            child: TextFormField(
                              controller: _courseController,
                              decoration: InputDecoration(
                                labelText: 'Course Name',
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
                          ),
                          const SizedBox(height: 12),
                          SizedBox(
                            width: double.infinity,
                            child: TextFormField(
                              controller: _universityController,
                              decoration: InputDecoration(
                                labelText: 'University/School Name',
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
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  controller: _fromYearController,
                                  decoration: InputDecoration(
                                    labelText: 'From Year',
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
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: _pursuing
                                    ? const SizedBox()
                                    : TextFormField(
                                        controller: _toYearController,
                                        decoration: InputDecoration(
                                          labelText: 'To Year',
                                          labelStyle: const TextStyle(color: AppColors.sand),
                                          filled: true,
                                          fillColor: fieldFill,
                                          border: border,
                                          enabledBorder: border,
                                          focusedBorder: border,
                                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                                        ),
                                      ),
                              ),
                              Checkbox(
                                value: _pursuing,
                                onChanged: (v) => setState(() => _pursuing = v ?? false),
                                activeColor: AppColors.sand,
                              ),
                              const Text('Pursuing', style: TextStyle(color: AppColors.sand)),
                            ],
                          ),
                          const SizedBox(height: 12),
                          SizedBox(
                            width: double.infinity,
                            child: TextFormField(
                              controller: _percentageController,
                              decoration: InputDecoration(
                                labelText: 'Percentage/CGPA',
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
                          ),
                          const SizedBox(height: 12),
                          SizedBox(
                            width: double.infinity,
                            child: TextFormField(
                              controller: _documentNumberController,
                              decoration: InputDecoration(
                                labelText: 'Document Number (optional)',
                                labelStyle: const TextStyle(color: AppColors.sand),
                                filled: true,
                                fillColor: fieldFill,
                                border: border,
                                enabledBorder: border,
                                focusedBorder: border,
                                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                              ),
                            ),
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
                                onPressed: _mockUploadCertificate,
                                icon: const Icon(Icons.upload_file),
                                label: const Text('Upload Certificate'),
                              ),
                              if (_certificatePath != null) ...[
                                const SizedBox(width: 12),
                                const Icon(Icons.check_circle, color: AppColors.sand),
                                const SizedBox(width: 4),
                                const Text('Uploaded', style: TextStyle(color: AppColors.sand)),
                              ]
                            ],
                          ),
                          const SizedBox(height: 18),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.sand,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                padding: const EdgeInsets.symmetric(vertical: 18),
                              ),
                              onPressed: () {
                                if (_formKey.currentState?.validate() ?? false) {
                                  widget.onSave(EducationEntry(
                                    level: _level,
                                    courseName: _courseController.text,
                                    universityName: _universityController.text,
                                    fromYear: _fromYearController.text,
                                    toYear: _pursuing ? null : _toYearController.text,
                                    pursuing: _pursuing,
                                    percentage: _percentageController.text,
                                    documentNumber: _documentNumberController.text.isEmpty ? null : _documentNumberController.text,
                                    certificatePath: _certificatePath,
                                    verified: _verified,
                                  ));
                                }
                              },
                              child: Text(
                                widget.entry == null ? 'Save' : 'Update',
                                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                              ),
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
