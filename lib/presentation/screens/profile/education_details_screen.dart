import 'package:flutter/material.dart';
import 'package:unikwik_app/core/theme/app_colors.dart';
import 'package:glass/glass.dart';
import 'package:unikwik_app/presentation/widgets/gradient_background.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:confetti/confetti.dart';

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

class _EducationDetailsScreenState extends State<EducationDetailsScreen> with TickerProviderStateMixin {
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  final List<EducationEntry> _entries = [];
  bool _showAddForm = false;
  EducationEntry? _editingEntry;
  int? _editingIndex;
  Offset? _tapPosition;
  late AnimationController _fabController;

  @override
  void initState() {
    super.initState();
    _fabController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _fabController.forward();
  }

  @override
  void dispose() {
    _fabController.dispose();
    super.dispose();
  }

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
        _editingIndex = null;
      } else {
        _entries.add(entry);
        _listKey.currentState?.insertItem(_entries.length - 1);
      }
      _showAddForm = false;
      _editingEntry = null;
    });
  }

  void _removeEducation(int index) {
    final removed = _entries.removeAt(index);
    _listKey.currentState?.removeItem(
      index,
      (context, animation) => _buildAnimatedTile(removed, index, animation),
      duration: const Duration(milliseconds: 400),
    );
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

  Widget _buildAnimatedTile(EducationEntry entry, int index, Animation<double> animation) {
    return SizeTransition(
      sizeFactor: animation,
      child: _buildEducationTile(entry, index),
    );
  }

  Widget _buildEducationTile(EducationEntry entry, int index) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTapDown: (details) => _tapPosition = details.globalPosition,
        onLongPress: () {
          if (_tapPosition != null) _showCardMenu(context, _tapPosition!, index);
        },
        child: ExpansionTile(
          tilePadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          backgroundColor: Colors.white.withOpacity(0.18),
          collapsedBackgroundColor: Colors.white.withOpacity(0.12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          collapsedShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          leading: Animate(
            effects: [ShimmerEffect(duration: 800.ms)],
            child: Icon(Icons.school, color: AppColors.sand),
          ),
          title: Row(
            children: [
              Text(
                '${entry.level} - ${entry.courseName}',
                style: const TextStyle(color: AppColors.sand, fontWeight: FontWeight.bold),
              ),
              if (entry.pursuing)
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Chip(
                    label: const Text('Pursuing'),
                    backgroundColor: Colors.blueAccent.withOpacity(0.2),
                    labelStyle: const TextStyle(color: Colors.blueAccent),
                  ),
                ),
            ],
          ),
          subtitle: Text(
            '${entry.universityName} | ${entry.fromYear}${entry.toYear != null ? ' - ${entry.toYear}' : ''}',
            style: const TextStyle(color: AppColors.sand),
          ),
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.percent, size: 18, color: Colors.deepPurpleAccent),
                      const SizedBox(width: 6),
                      Text('Percentage: ', style: const TextStyle(color: AppColors.sand, fontWeight: FontWeight.w600)),
                      Text(entry.percentage, style: const TextStyle(color: AppColors.sand)),
                    ],
                  ),
                  if (entry.documentNumber != null && entry.documentNumber!.isNotEmpty)
                    Row(
                      children: [
                        const Icon(Icons.description, size: 18, color: Colors.teal),
                        const SizedBox(width: 6),
                        Text('Doc #: ', style: const TextStyle(color: AppColors.sand, fontWeight: FontWeight.w600)),
                        Text(entry.documentNumber!, style: const TextStyle(color: AppColors.sand)),
                      ],
                    ),
                  Row(
                    children: [
                      const Icon(Icons.verified, size: 18, color: Colors.green),
                      const SizedBox(width: 6),
                      Text('Certificate: ', style: const TextStyle(color: AppColors.sand, fontWeight: FontWeight.w600)),
                      if (entry.certificatePath != null)
                        GestureDetector(
                          onTap: () {
                            // Show hero animation for certificate
                            showDialog(
                              context: context,
                              builder: (_) => Dialog(
                                backgroundColor: Colors.transparent,
                                child: Hero(
                                  tag: 'cert_${index}',
                                  child: Image.asset('assets/certificates/${entry.certificatePath!}', fit: BoxFit.contain),
                                ),
                              ),
                            );
                          },
                          child: Hero(
                            tag: 'cert_${index}',
                            child: Chip(
                              label: const Text('View'),
                              backgroundColor: Colors.green.withOpacity(0.2),
                              labelStyle: const TextStyle(color: Colors.green),
                            ),
                          ),
                        )
                      else
                        const Text('Not Uploaded', style: TextStyle(color: AppColors.sand)),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ).asGlass(
          blurX: 18,
          blurY: 18,
          tintColor: Colors.white.withOpacity(0.18),
          clipBorderRadius: BorderRadius.circular(20),
        ),
      ),
    );
  }

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
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 400),
                child: _entries.isEmpty
                    ? const Center(child: Text('No education details added yet.', style: TextStyle(color: AppColors.sand)))
                      : AnimatedList(
                          key: _listKey,
                        padding: const EdgeInsets.all(16),
                          initialItemCount: _entries.length,
                          itemBuilder: (context, index, animation) {
                            return _buildAnimatedTile(_entries[index], index, animation);
                          },
                        ),
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
          : ScaleTransition(
              scale: CurvedAnimation(parent: _fabController, curve: Curves.elasticOut),
              child: FloatingActionButton(
            backgroundColor: AppColors.sand,
            foregroundColor: Colors.white,
            onPressed: _openAddEducation,
                child: Animate(
                  effects: [ShakeEffect(duration: 800.ms)],
            child: const Icon(Icons.add),
                ),
              ),
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

class _AddEducationOverlayState extends State<AddEducationOverlay> with SingleTickerProviderStateMixin {
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
  bool _showErrors = false;
  late AnimationController _animController;
  late ConfettiController _confettiController;

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
    _animController = AnimationController(vsync: this, duration: const Duration(milliseconds: 600));
    _animController.forward();
    _confettiController = ConfettiController(duration: const Duration(seconds: 1));
  }

  @override
  void dispose() {
    _courseController.dispose();
    _universityController.dispose();
    _fromYearController.dispose();
    _toYearController.dispose();
    _percentageController.dispose();
    _documentNumberController.dispose();
    _animController.dispose();
    _confettiController.dispose();
    super.dispose();
  }

  void _mockUploadCertificate() async {
    setState(() {
      _certificatePath = 'mock_certificate.png';
      _verified = true;
    });
  }

  void _trySave() {
    setState(() => _showErrors = true);
    if (_formKey.currentState?.validate() ?? false) {
      _confettiController.play();
      Future.delayed(const Duration(milliseconds: 900), () {
        widget.onSave(EducationEntry(
          level: _level,
          courseName: _courseController.text.trim(),
          universityName: _universityController.text.trim(),
          fromYear: _fromYearController.text.trim(),
          toYear: _pursuing ? null : _toYearController.text.trim(),
          pursuing: _pursuing,
          percentage: _percentageController.text.trim(),
          documentNumber: _documentNumberController.text.trim(),
          certificatePath: _certificatePath,
          verified: _verified,
        ));
      });
    }
  }

  String? _validateYear(String? value) {
    if (value == null || value.isEmpty) return 'Required';
    if (value.length != 4 || int.tryParse(value) == null) return 'YYYY';
    return null;
  }

  Widget _animatedError(String? error) {
    if (error == null) return const SizedBox.shrink();
    return AnimatedOpacity(
      opacity: 1.0,
      duration: 300.ms,
      child: Padding(
        padding: const EdgeInsets.only(left: 8.0, top: 2.0),
        child: Text(error, style: const TextStyle(color: Colors.redAccent, fontSize: 13, fontWeight: FontWeight.w600)),
      ),
    );
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
    return FadeTransition(
      opacity: CurvedAnimation(parent: _animController, curve: Curves.easeIn),
      child: ScaleTransition(
        scale: CurvedAnimation(parent: _animController, curve: Curves.elasticOut),
        child: Center(
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
                    autovalidateMode: _showErrors ? AutovalidateMode.always : AutovalidateMode.disabled,
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.10),
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  const Icon(Icons.school, color: AppColors.sand, size: 32),
                                  const SizedBox(width: 10),
                          Text(
                            widget.entry == null ? 'Add Education' : 'Edit Education',
                            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.sand),
                                  ),
                                ],
                              ),
                              GestureDetector(
                                onTap: widget.onClose,
                                child: Animate(
                                  effects: [ShakeEffect(duration: 600.ms)],
                                  child: const Icon(Icons.close, color: AppColors.sand, size: 32),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 18),
                          DropdownButtonFormField<String>(
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
                          const SizedBox(height: 12),
                          TextFormField(
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
                              prefixIcon: const Icon(Icons.menu_book, color: AppColors.sand),
                            ),
                            validator: (v) => v == null || v.trim().isEmpty ? 'Required' : null,
                          ),
                          const SizedBox(height: 12),
                          TextFormField(
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
                              prefixIcon: const Icon(Icons.location_city, color: AppColors.sand),
                            ),
                            validator: (v) => v == null || v.trim().isEmpty ? 'Required' : null,
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  controller: _fromYearController,
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    labelText: 'From Year',
                                    labelStyle: const TextStyle(color: AppColors.sand),
                                    filled: true,
                                    fillColor: fieldFill,
                                    border: border,
                                    enabledBorder: border,
                                    focusedBorder: border,
                                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                                    prefixIcon: const Icon(Icons.calendar_today, color: AppColors.sand),
                                  ),
                                  validator: _validateYear,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: AnimatedOpacity(
                                  opacity: _pursuing ? 0.4 : 1.0,
                                  duration: 300.ms,
                                  child: TextFormField(
                                        controller: _toYearController,
                                    enabled: !_pursuing,
                                    keyboardType: TextInputType.number,
                                        decoration: InputDecoration(
                                          labelText: 'To Year',
                                          labelStyle: const TextStyle(color: AppColors.sand),
                                          filled: true,
                                          fillColor: fieldFill,
                                          border: border,
                                          enabledBorder: border,
                                          focusedBorder: border,
                                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                                      prefixIcon: const Icon(Icons.calendar_today, color: AppColors.sand),
                                    ),
                                    validator: (v) {
                                      if (_pursuing) return null;
                                      return _validateYear(v);
                                    },
                                        ),
                                      ),
                              ),
                              const SizedBox(width: 8),
                              Column(
                                children: [
                              Checkbox(
                                value: _pursuing,
                                onChanged: (v) => setState(() => _pursuing = v ?? false),
                                    activeColor: Colors.blueAccent,
                                  ),
                                  const Text('Pursuing', style: TextStyle(color: AppColors.sand, fontSize: 12)),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          TextFormField(
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
                              prefixIcon: const Icon(Icons.percent, color: AppColors.sand),
                            ),
                            validator: (v) => v == null || v.trim().isEmpty ? 'Required' : null,
                          ),
                          const SizedBox(height: 12),
                          TextFormField(
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
                              prefixIcon: const Icon(Icons.description, color: AppColors.sand),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Expanded(
                                child: ElevatedButton.icon(
                                  onPressed: _mockUploadCertificate,
                                  icon: const Icon(Icons.upload_file, color: AppColors.sand),
                                  label: Text(_certificatePath == null ? 'Upload Certificate' : 'Uploaded', style: const TextStyle(color: AppColors.sand)),
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.sand.withOpacity(0.3),
                                    foregroundColor: AppColors.sand,
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                    elevation: 0,
                                    padding: const EdgeInsets.symmetric(vertical: 14),
                                  ),
                                ),
                              ),
                              if (_certificatePath != null)
                                Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: Icon(Icons.check_circle, color: Colors.greenAccent, size: 28),
                                ),
                            ],
                          ),
                          const SizedBox(height: 24),
                          Center(
                            child: ElevatedButton(
                              onPressed: _trySave,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.sand,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                                elevation: 0,
                                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 18),
                              ),
                              child: Animate(
                                effects: [FadeEffect(duration: 400.ms)],
                                child: const Text('Save', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                              ),
                            ),
                          ),
                        ],
                      ),
                      ),
                    ),
                  ),
                ).asGlass(
                  tintColor: Colors.white.withOpacity(0.18),
                  clipBorderRadius: BorderRadius.circular(32),
                  blurX: 20,
                  blurY: 20,
                ),
              // Cross button (already handled in header)
            ],
          ),
        ),
      ),
    );
  }
}
