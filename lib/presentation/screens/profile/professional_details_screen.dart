import 'package:flutter/material.dart';
import 'package:unikwik_app/core/theme/app_colors.dart';
import 'package:glass/glass.dart';
import 'package:unikwik_app/presentation/widgets/gradient_background.dart';

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

class _ProfessionalDetailsScreenState extends State<ProfessionalDetailsScreen> {
  final List<ProfessionalEntry> _entries = [];
  bool _showAddForm = false;
  ProfessionalEntry? _editingEntry;
  int? _editingIndex;

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
      } else {
        _entries.add(entry);
      }
      _showAddForm = false;
      _editingEntry = null;
      _editingIndex = null;
    });
  }

  void _removeProfessional(int index) {
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
      _openEditProfessional(_entries[index], index);
    } else if (selected == 'remove') {
      _removeProfessional(index);
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
              Expanded(
                child: _entries.isEmpty
                    ? const Center(child: Text('No professional details added yet.', style: TextStyle(color: AppColors.sand)))
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
                                leading: Icon(Icons.business_center, color: AppColors.sand),
                                title: Text(
                                  '${entry.profileName} @ ${entry.companyName}',
                                  style: const TextStyle(color: AppColors.sand, fontWeight: FontWeight.bold),
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    if (entry.location.isNotEmpty)
                                      Text(entry.location, style: const TextStyle(color: AppColors.sand)),
                                    Row(
                                      children: [
                                        Text('Roles: ', style: const TextStyle(color: AppColors.sand, fontWeight: FontWeight.w600)),
                                        Flexible(child: Text(entry.roles.join(', '), style: const TextStyle(color: AppColors.sand))),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Text('Tech Stacks: ', style: const TextStyle(color: AppColors.sand, fontWeight: FontWeight.w600)),
                                        Flexible(child: Text(entry.techStacks.join(', '), style: const TextStyle(color: AppColors.sand))),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Text('From: ', style: const TextStyle(color: AppColors.sand, fontWeight: FontWeight.w600)),
                                        Text(entry.fromTime, style: const TextStyle(color: AppColors.sand)),
                                        if (entry.serving)
                                          const Text(' - Serving', style: TextStyle(color: AppColors.sand))
                                        else if (entry.toTime != null && entry.toTime!.isNotEmpty)
                                          Text(' - ${entry.toTime}', style: const TextStyle(color: AppColors.sand)),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Text('Employment: ', style: const TextStyle(color: AppColors.sand, fontWeight: FontWeight.w600)),
                                        Text(entry.employmentType, style: const TextStyle(color: AppColors.sand)),
                                      ],
                                    ),
                                    if (entry.reference != null && entry.reference!.isNotEmpty)
                                      Row(
                                        children: [
                                          Text('Reference: ', style: const TextStyle(color: AppColors.sand, fontWeight: FontWeight.w600)),
                                          Flexible(child: Text(entry.reference!, style: const TextStyle(color: AppColors.sand))),
                                        ],
                                      ),
                                    if (entry.achievements != null && entry.achievements!.isNotEmpty)
                                      Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text('Achievements: ', style: const TextStyle(color: AppColors.sand, fontWeight: FontWeight.w600)),
                                          Flexible(child: Text(entry.achievements!, style: const TextStyle(color: AppColors.sand))),
                                        ],
                                      ),
                                  ],
                                ),
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
        : FloatingActionButton(
            backgroundColor: AppColors.sand,
            foregroundColor: Colors.white,
            onPressed: _openAddProfessional,
            child: const Icon(Icons.add),
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

class _AddProfessionalOverlayState extends State<AddProfessionalOverlay> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _companyController;
  late TextEditingController _profileController;
  late List<String> _roles;
  late List<String> _techStacks;
  late TextEditingController _fromTimeController;
  late TextEditingController _toTimeController;
  late bool _serving;
  late TextEditingController _locationController;
  String _employmentType = 'Full-time';
  late TextEditingController _referenceController;
  late TextEditingController _achievementsController;

  final List<String> _roleOptions = [
    'Team Lead', 'Developer', 'Mentor', 'Architect', 'DevOps', 'QA', 'Manager', 'Designer', 'Analyst', 'Other'
  ];
  final List<String> _techOptions = [
    'Flutter', 'Dart', 'React', 'Node.js', 'Python', 'Java', 'AWS', 'Azure', 'Docker', 'Kubernetes', 'SQL', 'NoSQL', 'Other'
  ];
  final List<String> _employmentTypes = [
    'Full-time', 'Part-time', 'Contract', 'Internship'
  ];

  @override
  void initState() {
    super.initState();
    final entry = widget.entry;
    _companyController = TextEditingController(text: entry?.companyName ?? '');
    _profileController = TextEditingController(text: entry?.profileName ?? '');
    _roles = List<String>.from(entry?.roles ?? []);
    _techStacks = List<String>.from(entry?.techStacks ?? []);
    _fromTimeController = TextEditingController(text: entry?.fromTime ?? '');
    _toTimeController = TextEditingController(text: entry?.toTime ?? '');
    _serving = entry?.serving ?? false;
    _locationController = TextEditingController(text: entry?.location ?? '');
    _employmentType = entry?.employmentType ?? 'Full-time';
    _referenceController = TextEditingController(text: entry?.reference ?? '');
    _achievementsController = TextEditingController(text: entry?.achievements ?? '');
  }

  @override
  void dispose() {
    _companyController.dispose();
    _profileController.dispose();
    _fromTimeController.dispose();
    _toTimeController.dispose();
    _locationController.dispose();
    _referenceController.dispose();
    _achievementsController.dispose();
    super.dispose();
  }

  void _toggleRole(String role) {
    setState(() {
      if (_roles.contains(role)) {
        _roles.remove(role);
      } else {
        if (_roles.length < 5) {
          _roles.add(role);
        }
      }
    });
  }

  void _toggleTech(String tech) {
    setState(() {
      if (_techStacks.contains(tech)) {
        _techStacks.remove(tech);
      } else {
        _techStacks.add(tech);
      }
    });
  }

  Future<void> _pickDate(TextEditingController controller) async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: DateTime(1970),
      lastDate: DateTime(now.year + 5),
    );
    if (picked != null) {
      controller.text = '${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}';
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
                            widget.entry == null ? 'Add Professional' : 'Edit Professional',
                            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.sand),
                          ),
                          const SizedBox(height: 18),
                          TextFormField(
                            controller: _companyController,
                            decoration: InputDecoration(
                              labelText: 'Company Name',
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
                            controller: _profileController,
                            decoration: InputDecoration(
                              labelText: 'Profile Name (Job Title)',
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
                          Text('Roles (max 5):', style: const TextStyle(color: AppColors.sand, fontWeight: FontWeight.w600)),
                          Wrap(
                            spacing: 8,
                            children: _roleOptions.map((role) => FilterChip(
                              label: Text(role),
                              selected: _roles.contains(role),
                              onSelected: (_) => _toggleRole(role),
                              selectedColor: AppColors.sand.withOpacity(0.7),
                              backgroundColor: fieldFill,
                              labelStyle: TextStyle(color: _roles.contains(role) ? Colors.white : AppColors.sand),
                            )).toList(),
                          ),
                          const SizedBox(height: 12),
                          Text('Tech Stacks:', style: const TextStyle(color: AppColors.sand, fontWeight: FontWeight.w600)),
                          Wrap(
                            spacing: 8,
                            children: _techOptions.map((tech) => FilterChip(
                              label: Text(tech),
                              selected: _techStacks.contains(tech),
                              onSelected: (_) => _toggleTech(tech),
                              selectedColor: AppColors.sand.withOpacity(0.7),
                              backgroundColor: fieldFill,
                              labelStyle: TextStyle(color: _techStacks.contains(tech) ? Colors.white : AppColors.sand),
                            )).toList(),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  controller: _fromTimeController,
                                  readOnly: true,
                                  onTap: () => _pickDate(_fromTimeController),
                                  decoration: InputDecoration(
                                    labelText: 'From',
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
                                child: _serving
                                    ? const SizedBox()
                                    : TextFormField(
                                        controller: _toTimeController,
                                        readOnly: true,
                                        onTap: () => _pickDate(_toTimeController),
                                        decoration: InputDecoration(
                                          labelText: 'To',
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
                                value: _serving,
                                onChanged: (v) => setState(() => _serving = v ?? false),
                                activeColor: AppColors.sand,
                              ),
                              const Text('Serving', style: TextStyle(color: AppColors.sand)),
                            ],
                          ),
                          const SizedBox(height: 12),
                          TextFormField(
                            controller: _locationController,
                            decoration: InputDecoration(
                              labelText: 'Location',
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
                          DropdownButtonFormField<String>(
                            value: _employmentType,
                            items: _employmentTypes.map((type) => DropdownMenuItem(value: type, child: Text(type))).toList(),
                            onChanged: (v) => setState(() => _employmentType = v ?? 'Full-time'),
                            decoration: InputDecoration(
                              labelText: 'Employment Type',
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
                            controller: _referenceController,
                            decoration: InputDecoration(
                              labelText: 'Reference/Contact (optional)',
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
                            controller: _achievementsController,
                            maxLines: 3,
                            decoration: InputDecoration(
                              labelText: 'Achievements/Highlights (optional)',
                              labelStyle: const TextStyle(color: AppColors.sand),
                              filled: true,
                              fillColor: fieldFill,
                              border: border,
                              enabledBorder: border,
                              focusedBorder: border,
                              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                            ),
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
                                  widget.onSave(ProfessionalEntry(
                                    companyName: _companyController.text,
                                    profileName: _profileController.text,
                                    roles: _roles,
                                    techStacks: _techStacks,
                                    fromTime: _fromTimeController.text,
                                    toTime: _serving ? null : _toTimeController.text,
                                    serving: _serving,
                                    location: _locationController.text,
                                    employmentType: _employmentType,
                                    reference: _referenceController.text.isEmpty ? null : _referenceController.text,
                                    achievements: _achievementsController.text.isEmpty ? null : _achievementsController.text,
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