import 'package:flutter/material.dart';
import 'package:glass/glass.dart';
import 'package:unikwik_app/core/theme/app_colors.dart';

class ChannelCreationPopup extends StatefulWidget {
  final void Function(String) onAdd;
  const ChannelCreationPopup({super.key, required this.onAdd});

  @override
  State<ChannelCreationPopup> createState() => _ChannelCreationPopupState();
}

class _ChannelCreationPopupState extends State<ChannelCreationPopup> {
  final TextEditingController _controller = TextEditingController();
  String? _error;
  bool _adding = false;

  static final RegExp _pattern = RegExp(r'^#([a-z]+)-(jobs|study|general)$');

  void _validateAndAdd() {
    final value = _controller.text.trim();
    if (!_pattern.hasMatch(value)) {
      setState(() {
        _error = "Channel name must be like #germany-jobs, #canada-study, or #usa-general";
      });
      return;
    }
    setState(() => _adding = true);
    widget.onAdd(value);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        width: 350,
        padding: const EdgeInsets.all(0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Add Channel', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.white)),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.white),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: TextField(
                controller: _controller,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Channel Name',
                  labelStyle: const TextStyle(color: Colors.white),
                  hintText: '#germany-jobs',
                  hintStyle: const TextStyle(color: Colors.white70),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  errorText: _error,
                  errorStyle: const TextStyle(color: Colors.white),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Colors.white54),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Colors.white),
                  ),
                ),
                onChanged: (_) {
                  if (_error != null) setState(() => _error = null);
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.sand,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  onPressed: _adding ? null : _validateAndAdd,
                  child: _adding
                      ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                      : const Text('Add', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white)),
                ),
              ),
            ),
          ],
        ).asGlass(
          tintColor: Colors.white.withOpacity(0.13),
          blurX: 12,
          blurY: 12,
          clipBorderRadius: BorderRadius.circular(20),
        ),
      ),
    );
  }
} 