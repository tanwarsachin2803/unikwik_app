import 'package:flutter/material.dart';
import 'package:unikwik_app/core/theme/app_colors.dart';
import 'package:glass/glass.dart';
import 'package:unikwik_app/presentation/widgets/gradient_background.dart';

class CertificationEntry {
  final String type; // e.g. IELTS, TOEFL, Other
  final String? customType; // if type == 'Other'
  final String? grade;
  final String date;
  final String candidateName;
  final String? certificatePath;
  final String? fileName;

  CertificationEntry({
    required this.type,
    this.customType,
    this.grade,
    required this.date,
    required this.candidateName,
    this.certificatePath,
    this.fileName,
  });
}

class CertificationsDetailsScreen extends StatefulWidget {
  const CertificationsDetailsScreen({super.key});

  @override
  State<CertificationsDetailsScreen> createState() => _CertificationsDetailsScreenState();
}

class _CertificationsDetailsScreenState extends State<CertificationsDetailsScreen> {
  final List<CertificationEntry> _entries = [];
  bool _showAddForm = false;
  CertificationEntry? _editingEntry;
  int? _editingIndex;

  void _openAddCertification() {
    setState(() {
      _editingEntry = null;
      _editingIndex = null;
      _showAddForm = true;
    });
  }

  void _openEditCertification(CertificationEntry entry, int index) {
    setState(() {
      _editingEntry = entry;
      _editingIndex = index;
      _showAddForm = true;
    });
  }

  void _closeAddCertification() {
    setState(() {
      _showAddForm = false;
      _editingEntry = null;
      _editingIndex = null;
    });
  }

  void _addOrEditCertification(CertificationEntry entry) {
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

  void _removeCertification(int index) {
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
      _openEditCertification(_entries[index], index);
    } else if (selected == 'remove') {
      _removeCertification(index);
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
            Navigator.of(context).pop();
          },
        ),
        title: const Text('Certifications', style: TextStyle(color: AppColors.sand)),
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
                    ? const Center(child: Text('No certifications added yet.', style: TextStyle(color: AppColors.sand)))
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
                                leading: Icon(Icons.workspace_premium, color: AppColors.sand),
                                title: Text(
                                  entry.type == 'Other' ? (entry.customType ?? 'Other') : entry.type,
                                  style: const TextStyle(color: AppColors.sand, fontWeight: FontWeight.bold),
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Name: ${entry.candidateName}', style: const TextStyle(color: AppColors.sand)),
                                    if (entry.grade != null && entry.grade!.isNotEmpty)
                                      Text('Grade: ${entry.grade}', style: const TextStyle(color: AppColors.sand)),
                                    Text('Date: ${entry.date}', style: const TextStyle(color: AppColors.sand)),
                                    if (entry.fileName != null)
                                      Text('File: ${entry.fileName}', style: const TextStyle(color: AppColors.sand)),
                                  ],
                                ),
                                trailing: entry.certificatePath != null
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
            AddCertificationOverlay(
              onClose: _closeAddCertification,
              onSave: _addOrEditCertification,
              entry: _editingEntry,
            ),
        ],
      ),
      floatingActionButton: _showAddForm
        ? null
        : FloatingActionButton(
            backgroundColor: AppColors.sand,
            foregroundColor: Colors.white,
            onPressed: _openAddCertification,
            child: const Icon(Icons.add),
          ),
    );
  }
}

class AddCertificationOverlay extends StatefulWidget {
  final VoidCallback onClose;
  final Function(CertificationEntry) onSave;
  final CertificationEntry? entry;
  const AddCertificationOverlay({super.key, required this.onClose, required this.onSave, this.entry});

  @override
  State<AddCertificationOverlay> createState() => _AddCertificationOverlayState();
}

class _AddCertificationOverlayState extends State<AddCertificationOverlay> {
  final _formKey = GlobalKey<FormState>();
  final List<String> _certTypes = [
    'IELTS', 'TOEFL', 'GRE', 'GMAT', 'SAT', 'ACT', 'PTE', 'Duolingo', 'LSAT', 'MCAT', 'Other'
  ];
  String _type = 'IELTS';
  late TextEditingController _customTypeController;
  late TextEditingController _gradeController;
  late TextEditingController _dateController;
  late TextEditingController _nameController;
  String? _certificatePath;
  String? _fileName;

  @override
  void initState() {
    super.initState();
    final entry = widget.entry;
    _type = entry?.type ?? 'IELTS';
    _customTypeController = TextEditingController(text: entry?.customType ?? '');
    _gradeController = TextEditingController(text: entry?.grade ?? '');
    _dateController = TextEditingController(text: entry?.date ?? '');
    _nameController = TextEditingController(text: entry?.candidateName ?? '');
    _certificatePath = entry?.certificatePath;
    _fileName = entry?.fileName;
  }

  @override
  void dispose() {
    _customTypeController.dispose();
    _gradeController.dispose();
    _dateController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _pickDate(TextEditingController controller) async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: DateTime(1970),
      lastDate: DateTime(now.year + 10),
    );
    if (picked != null) {
      controller.text = '${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}';
    }
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
        _certificatePath = 'mock_certificate.pdf';
        _fileName = 'certificate.pdf';
      });
    } else if (result == 'camera') {
      setState(() {
        _certificatePath = 'mock_certificate_camera.jpg';
        _fileName = 'certificate_camera.jpg';
      });
    }
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
                            widget.entry == null ? 'Add Certification' : 'Edit Certification',
                            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.sand),
                          ),
                          const SizedBox(height: 18),
                          DropdownButtonFormField<String>(
                            value: _type,
                            items: _certTypes.map((type) => DropdownMenuItem(value: type, child: Text(type))).toList(),
                            onChanged: (v) => setState(() => _type = v ?? 'IELTS'),
                            decoration: InputDecoration(
                              labelText: 'Certification Type',
                              labelStyle: const TextStyle(color: AppColors.sand),
                              filled: true,
                              fillColor: fieldFill,
                              border: border,
                              enabledBorder: border,
                              focusedBorder: border,
                              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                            ),
                          ),
                          if (_type == 'Other') ...[
                            const SizedBox(height: 12),
                            TextFormField(
                              controller: _customTypeController,
                              decoration: InputDecoration(
                                labelText: 'Custom Certification Name',
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
                          ],
                          const SizedBox(height: 12),
                          TextFormField(
                            controller: _gradeController,
                            decoration: InputDecoration(
                              labelText: 'Grade (optional)',
                              labelStyle: const TextStyle(color: AppColors.sand),
                              filled: true,
                              fillColor: fieldFill,
                              border: border,
                              enabledBorder: border,
                              focusedBorder: border,
                              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                            ),
                          ),
                          const SizedBox(height: 12),
                          TextFormField(
                            controller: _dateController,
                            readOnly: true,
                            onTap: () => _pickDate(_dateController),
                            decoration: InputDecoration(
                              labelText: 'Date',
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
                          TextFormField(
                            controller: _nameController,
                            decoration: InputDecoration(
                              labelText: 'Candidate Name',
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
                                  widget.onSave(CertificationEntry(
                                    type: _type,
                                    customType: _type == 'Other' ? _customTypeController.text : null,
                                    grade: _gradeController.text.isEmpty ? null : _gradeController.text,
                                    date: _dateController.text,
                                    candidateName: _nameController.text,
                                    certificatePath: _certificatePath,
                                    fileName: _fileName,
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