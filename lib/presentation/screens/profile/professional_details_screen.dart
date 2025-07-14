import 'package:flutter/material.dart';
import 'package:unikwik_app/core/theme/app_colors.dart';
import 'package:glass/glass.dart';
import 'package:unikwik_app/presentation/widgets/gradient_background.dart';
import 'package:confetti/confetti.dart';

class ProfessionalEntry {
  final String companyName;
  final String profileName;
  final List<String> roles;
  final List<String> techStacks;
  final String fromTime;
  final String? toTime;
  final bool serving;
  final String location;
  final String employmentType;
  final String? reference;
  final String? achievements;

  ProfessionalEntry({
    required this.companyName,
    required this.profileName,
    required this.roles,
    required this.techStacks,
    required this.fromTime,
    this.toTime,
    this.serving = false,
    required this.location,
    required this.employmentType,
    this.reference,
    this.achievements,
  });
}

class ProfessionalDetailsScreen extends StatefulWidget {
  const ProfessionalDetailsScreen({super.key});

  @override
  State<ProfessionalDetailsScreen> createState() => _ProfessionalDetailsScreenState();
}

class _ProfessionalDetailsScreenState extends State<ProfessionalDetailsScreen> with TickerProviderStateMixin {
  final List<ProfessionalEntry> _entries = [];
  bool _showAddForm = false;
  ProfessionalEntry? _editingEntry;
  int? _editingIndex;
  Offset? _tapPosition;
  String? _resumePath;
  String? _resumeFileName;
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

  void _openAddProfessional() {
    setState(() {
      _editingEntry = null;
      _editingIndex = null;
      _showAddForm = true;
    });
  }

  void _openEditProfessional(ProfessionalEntry entry, int index) {
    setState(() {
      _editingEntry = entry;
      _editingIndex = index;
      _showAddForm = true;
    });
  }

  void _closeAddProfessional() {
    setState(() {
      _showAddForm = false;
      _editingEntry = null;
      _editingIndex = null;
    });
  }

  void _addOrEditProfessional(ProfessionalEntry entry) {
    setState(() {
      if (_editingIndex != null) {
        _entries[_editingIndex!] = entry;
        _editingIndex = null;
      } else {
        _entries.add(entry);
      }
      _showAddForm = false;
      _editingEntry = null;
    });
  }

  void _removeProfessional(int index) {
    setState(() {
      _entries.removeAt(index);
    });
  }

  void _uploadResume() async {
    // Mock PDF upload
    setState(() {
      _resumePath = 'mock_resume.pdf';
      _resumeFileName = 'Sachin_Resume.pdf';
    });
  }

  void _removeResume() {
    setState(() {
      _resumePath = null;
      _resumeFileName = null;
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
      _openEditProfessional(_entries[index], index);
    } else if (selected == 'remove') {
      _removeProfessional(index);
    }
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
            Navigator.of(context).pop();
          },
        ),
        title: const Text('Professional Details', style: TextStyle(color: AppColors.sand)),
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
              // Resume section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16),
                child: _resumePath == null
                    ? GestureDetector(
                        onTap: _uploadResume,
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(vertical: 18),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.12),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: Colors.white.withOpacity(0.18)),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Icon(Icons.picture_as_pdf, color: Colors.deepOrange, size: 32),
                              SizedBox(width: 12),
                              Text('Add Resume (PDF)', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 16)),
                            ],
                          ),
                        ),
                      )
                    : Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.white.withOpacity(0.18)),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.picture_as_pdf, color: Colors.deepOrange, size: 32),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(_resumeFileName ?? '', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 16), overflow: TextOverflow.ellipsis),
                            ),
                            const SizedBox(width: 12),
                            const Icon(Icons.check_circle, color: Colors.greenAccent, size: 28),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.redAccent),
                              onPressed: _removeResume,
                              tooltip: 'Remove Resume',
                            ),
                          ],
                        ),
                      ),
              ),
              // Work Experience heading
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8),
                child: Row(
                  children: const [
                    Icon(Icons.work, color: Colors.white),
                    SizedBox(width: 10),
                    Text('Work Experience', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
                  ],
                ),
              ),
              // Work Experience list
              Expanded(
                child: _entries.isEmpty
                    ? const Center(child: Text('No professional details added yet.', style: TextStyle(color: Colors.white)))
                    : ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: _entries.length,
                        itemBuilder: (context, index) {
                          final entry = _entries[index];
                          return Card(
                              color: Colors.white.withOpacity(0.18),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                              margin: const EdgeInsets.symmetric(vertical: 8),
                              child: ListTile(
                                contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                              leading: const Icon(Icons.business_center, color: Colors.white),
                                title: Text(
                                '${entry.companyName} - ${entry.profileName}',
                                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    if (entry.location.isNotEmpty)
                                    Text(entry.location, style: const TextStyle(color: Colors.white70)),
                                    Row(
                                      children: [
                                      const Icon(Icons.calendar_today, size: 16, color: Colors.white54),
                                      const SizedBox(width: 4),
                                      Text('${entry.fromTime}${entry.serving ? ' - Present' : entry.toTime != null ? ' - ${entry.toTime}' : ''}', style: const TextStyle(color: Colors.white70)),
                                      ],
                                    ),
                                  Wrap(
                                    spacing: 6,
                                    children: entry.roles.map((role) => Chip(label: Text(role), backgroundColor: Colors.blue.withOpacity(0.2), labelStyle: const TextStyle(color: Colors.blue))).toList(),
                                    ),
                                  Wrap(
                                    spacing: 6,
                                    children: entry.techStacks.map((tech) => Chip(label: Text(tech), backgroundColor: Colors.deepPurple.withOpacity(0.2), labelStyle: const TextStyle(color: Colors.deepPurple))).toList(),
                                      ),
                                    if (entry.achievements != null && entry.achievements!.isNotEmpty)
                                    Padding(
                                      padding: const EdgeInsets.only(top: 6.0),
                                      child: Text('Achievements: ${entry.achievements}', style: const TextStyle(color: Colors.amberAccent)),
                                      ),
                                  ],
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
          if (_showAddForm)
            AddProfessionalOverlay(
              onClose: _closeAddProfessional,
              onSave: _addOrEditProfessional,
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
            onPressed: _openAddProfessional,
            child: const Icon(Icons.add),
              ),
          ),
    );
  }
}

class AddProfessionalOverlay extends StatefulWidget {
  final VoidCallback onClose;
  final Function(ProfessionalEntry) onSave;
  final ProfessionalEntry? entry;
  const AddProfessionalOverlay({super.key, required this.onClose, required this.onSave, this.entry});

  @override
  State<AddProfessionalOverlay> createState() => _AddProfessionalOverlayState();
}

class _AddProfessionalOverlayState extends State<AddProfessionalOverlay> with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _companyController;
  late TextEditingController _profileController;
  late List<String> _skills;
  late TextEditingController _skillInputController;
  late TextEditingController _fromTimeController;
  late TextEditingController _toTimeController;
  late bool _serving;
  late TextEditingController _locationController;
  String _employmentType = 'Full-time';
  late TextEditingController _referenceController;
  late TextEditingController _achievementsController;
  bool _showErrors = false;
  late AnimationController _animController;
  late ConfettiController _confettiController;
  final List<String> _employmentTypes = [
    'Full-time', 'Part-time', 'Contract', 'Internship'
  ];
  bool _skillsInputMode = false;
  FocusNode _skillsFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    final entry = widget.entry;
    _companyController = TextEditingController(text: entry?.companyName ?? '');
    _profileController = TextEditingController(text: entry?.profileName ?? '');
    _skills = List<String>.from(entry?.techStacks ?? []); // Use techStacks for skills
    _skillInputController = TextEditingController();
    _fromTimeController = TextEditingController(text: entry?.fromTime ?? '');
    _toTimeController = TextEditingController(text: entry?.toTime ?? '');
    _serving = entry?.serving ?? false;
    _locationController = TextEditingController(text: entry?.location ?? '');
    _employmentType = entry?.employmentType ?? 'Full-time';
    _referenceController = TextEditingController(text: entry?.reference ?? '');
    _achievementsController = TextEditingController(text: entry?.achievements ?? '');
    _animController = AnimationController(vsync: this, duration: const Duration(milliseconds: 600));
    _animController.forward();
    _confettiController = ConfettiController(duration: const Duration(seconds: 1));
  }

  @override
  void dispose() {
    _companyController.dispose();
    _profileController.dispose();
    _skillInputController.dispose();
    _fromTimeController.dispose();
    _toTimeController.dispose();
    _locationController.dispose();
    _referenceController.dispose();
    _achievementsController.dispose();
    _animController.dispose();
    _confettiController.dispose();
    _skillsFocusNode.dispose();
    super.dispose();
  }

  void _enterSkillsInputMode() {
    setState(() => _skillsInputMode = true);
    Future.delayed(const Duration(milliseconds: 100), () {
      _skillsFocusNode.requestFocus();
    });
  }

  void _exitSkillsInputMode() {
    setState(() => _skillsInputMode = false);
    _skillsFocusNode.unfocus();
  }

  void _addSkill() {
    final skill = _skillInputController.text.trim();
    if (skill.isNotEmpty && !_skills.contains(skill)) {
      setState(() {
        _skills.add(skill);
        _skillInputController.clear();
      });
      }
    _exitSkillsInputMode();
  }

  void _removeSkill(String skill) {
    setState(() {
      _skills.remove(skill);
    });
  }

  void _trySave() {
    setState(() => _showErrors = true);
    if (_formKey.currentState?.validate() ?? false) {
      _confettiController.play();
      Future.delayed(const Duration(milliseconds: 900), () {
        widget.onSave(ProfessionalEntry(
          companyName: _companyController.text.trim(),
          profileName: _profileController.text.trim(),
          roles: [], // No roles, just skills
          techStacks: _skills,
          fromTime: _fromTimeController.text.trim(),
          toTime: _serving ? null : _toTimeController.text.trim(),
          serving: _serving,
          location: _locationController.text.trim(),
          employmentType: _employmentType,
          reference: _referenceController.text.trim(),
          achievements: _achievementsController.text.trim(),
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
      duration: Duration(milliseconds: 300),
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
      borderSide: BorderSide(color: Colors.white.withOpacity(0.5)),
    );
    return Stack(
      children: [
        FadeTransition(
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
                                      const Icon(Icons.business_center, color: Colors.white, size: 32),
                                      const SizedBox(width: 10),
                          Text(
                            widget.entry == null ? 'Add Professional' : 'Edit Professional',
                                        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
                                      ),
                                    ],
                                  ),
                                  GestureDetector(
                                    onTap: widget.onClose,
                                    child: const Icon(Icons.close, color: Colors.white, size: 32),
                                  ),
                                ],
                          ),
                          const SizedBox(height: 18),
                          TextFormField(
                            controller: _companyController,
                            decoration: InputDecoration(
                              labelText: 'Company Name',
                                  labelStyle: const TextStyle(color: Colors.white),
                              filled: true,
                              fillColor: fieldFill,
                              border: border,
                              enabledBorder: border,
                              focusedBorder: border,
                              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                                  prefixIcon: const Icon(Icons.business, color: Colors.white),
                            ),
                                validator: (v) => v == null || v.trim().isEmpty ? 'Required' : null,
                          ),
                          const SizedBox(height: 12),
                          TextFormField(
                            controller: _profileController,
                            decoration: InputDecoration(
                                  labelText: 'Profile Name',
                                  labelStyle: const TextStyle(color: Colors.white),
                              filled: true,
                              fillColor: fieldFill,
                              border: border,
                              enabledBorder: border,
                              focusedBorder: border,
                              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                                  prefixIcon: const Icon(Icons.person, color: Colors.white),
                            ),
                                validator: (v) => v == null || v.trim().isEmpty ? 'Required' : null,
                          ),
                          const SizedBox(height: 12),
                              AnimatedContainer(
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.ease,
                                padding: EdgeInsets.zero,
                                child: GestureDetector(
                                  onTap: _enterSkillsInputMode,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.18),
                                      borderRadius: BorderRadius.circular(20),
                                      border: Border.all(color: _skillsInputMode ? Colors.blueAccent : Colors.white.withOpacity(0.5), width: 2),
                                    ),
                                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Icon(Icons.label, color: _skillsInputMode ? Colors.blueAccent : Colors.white),
                                            const SizedBox(width: 10),
                                            Text('Skills', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
                                          ],
                                        ),
                                        AnimatedCrossFade(
                                          duration: const Duration(milliseconds: 250),
                                          crossFadeState: _skillsInputMode ? CrossFadeState.showSecond : CrossFadeState.showFirst,
                                          firstChild: _skills.isEmpty
                                              ? const SizedBox(height: 0)
                                              : Padding(
                                                  padding: const EdgeInsets.only(top: 8.0),
                                                  child: Wrap(
                            spacing: 8,
                                                    runSpacing: 4,
                                                    children: _skills.map((skill) => Chip(
                                                      label: Text(skill),
                                                      backgroundColor: Colors.blue.withOpacity(0.2),
                                                      labelStyle: TextStyle(color: Colors.blue),
                                                      deleteIcon: Icon(Icons.close, color: Colors.redAccent, size: 18),
                                                      onDeleted: () => _removeSkill(skill),
                            )).toList(),
                          ),
                                                ),
                                          secondChild: Column(
                                            children: [
                                              Row(
                                                children: [
                                                  Expanded(
                                                    child: TextFormField(
                                                      focusNode: _skillsFocusNode,
                                                      controller: _skillInputController,
                                                      decoration: InputDecoration(
                                                        hintText: 'Type a skill and press add',
                                                        hintStyle: TextStyle(color: Colors.white70),
                                                        border: InputBorder.none,
                                                      ),
                                                      style: TextStyle(color: Colors.white),
                                                      onFieldSubmitted: (_) => _addSkill(),
                                                    ),
                                                  ),
                                                  TextButton(
                                                    onPressed: _addSkill,
                                                    child: Text('Add', style: TextStyle(color: Colors.blueAccent)),
                                                  ),
                                                ],
                                              ),
                                              if (_skills.isNotEmpty)
                                                Padding(
                                                  padding: const EdgeInsets.only(top: 8.0),
                                                  child: Wrap(
                            spacing: 8,
                                                    runSpacing: 4,
                                                    children: _skills.map((skill) => Chip(
                                                      label: Text(skill),
                                                      backgroundColor: Colors.blue.withOpacity(0.2),
                                                      labelStyle: TextStyle(color: Colors.blue),
                                                      deleteIcon: Icon(Icons.close, color: Colors.redAccent, size: 18),
                                                      onDeleted: () => _removeSkill(skill),
                            )).toList(),
                                                  ),
                                                ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  controller: _fromTimeController,
                                      keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                        labelText: 'From Year',
                                        labelStyle: const TextStyle(color: Colors.white),
                                    filled: true,
                                    fillColor: fieldFill,
                                    border: border,
                                    enabledBorder: border,
                                    focusedBorder: border,
                                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                                        prefixIcon: const Icon(Icons.calendar_today, color: Colors.white),
                                      ),
                                      validator: _validateYear,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                              Expanded(
                                    child: AnimatedOpacity(
                                      opacity: _serving ? 0.4 : 1.0,
                                      duration: Duration(milliseconds: 300),
                                      child: TextFormField(
                                        controller: _toTimeController,
                                        enabled: !_serving,
                                        keyboardType: TextInputType.number,
                                        decoration: InputDecoration(
                                          labelText: 'To Year',
                                          labelStyle: const TextStyle(color: Colors.white),
                                          filled: true,
                                          fillColor: fieldFill,
                                          border: border,
                                          enabledBorder: border,
                                          focusedBorder: border,
                                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                                          prefixIcon: const Icon(Icons.calendar_today, color: Colors.white),
                                        ),
                                        validator: (v) {
                                          if (_serving) return null;
                                          return _validateYear(v);
                                        },
                                      ),
                              ),
                                  ),
                                  const SizedBox(width: 8),
                                  Column(
                                    children: [
                              Checkbox(
                                value: _serving,
                                onChanged: (v) => setState(() => _serving = v ?? false),
                                        activeColor: Colors.blueAccent,
                              ),
                                      const Text('Serving', style: TextStyle(color: Colors.white, fontSize: 12)),
                                    ],
                                  ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          TextFormField(
                            controller: _locationController,
                            decoration: InputDecoration(
                              labelText: 'Location',
                                  labelStyle: const TextStyle(color: Colors.white),
                              filled: true,
                              fillColor: fieldFill,
                              border: border,
                              enabledBorder: border,
                              focusedBorder: border,
                              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                                  prefixIcon: const Icon(Icons.location_on, color: Colors.white),
                            ),
                                validator: (v) => v == null || v.trim().isEmpty ? 'Required' : null,
                          ),
                          const SizedBox(height: 12),
                          DropdownButtonFormField<String>(
                            value: _employmentType,
                            items: _employmentTypes.map((type) => DropdownMenuItem(value: type, child: Text(type))).toList(),
                            onChanged: (v) => setState(() => _employmentType = v ?? 'Full-time'),
                            decoration: InputDecoration(
                              labelText: 'Employment Type',
                                  labelStyle: const TextStyle(color: Colors.white),
                              filled: true,
                              fillColor: fieldFill,
                              border: border,
                              enabledBorder: border,
                              focusedBorder: border,
                              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                                  prefixIcon: const Icon(Icons.work, color: Colors.white),
                            ),
                          ),
                          const SizedBox(height: 12),
                          TextFormField(
                            controller: _referenceController,
                            decoration: InputDecoration(
                                  labelText: 'Reference (optional)',
                                  labelStyle: const TextStyle(color: Colors.white),
                              filled: true,
                              fillColor: fieldFill,
                              border: border,
                              enabledBorder: border,
                              focusedBorder: border,
                              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                                  prefixIcon: const Icon(Icons.contact_mail, color: Colors.white),
                            ),
                          ),
                          const SizedBox(height: 12),
                          TextFormField(
                            controller: _achievementsController,
                            decoration: InputDecoration(
                                  labelText: 'Achievements (optional)',
                                  labelStyle: const TextStyle(color: Colors.white),
                              filled: true,
                              fillColor: fieldFill,
                              border: border,
                              enabledBorder: border,
                              focusedBorder: border,
                              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                                  prefixIcon: const Icon(Icons.emoji_events, color: Colors.white),
                            ),
                          ),
                              const SizedBox(height: 24),
                              Center(
                            child: ElevatedButton(
                                  onPressed: _trySave,
                              style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.white,
                                    foregroundColor: Colors.blueAccent,
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                                    elevation: 0,
                                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 18),
                                  ),
                                  child: const Text('Save', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
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
                ],
              ),
                  ),
                ),
              ),
        Align(
          alignment: Alignment.topCenter,
          child: ConfettiWidget(
            confettiController: _confettiController,
            blastDirectionality: BlastDirectionality.explosive,
            shouldLoop: false,
            colors: [Colors.blue, Colors.pink, Colors.amber, Colors.green, Colors.deepPurple],
            numberOfParticles: 30,
            maxBlastForce: 20,
            minBlastForce: 8,
            emissionFrequency: 0.05,
            gravity: 0.2,
          ),
        ),
      ],
    );
  }
} 