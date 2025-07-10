import 'package:flutter/material.dart';
import 'package:glass/glass.dart';
import 'package:unikwik_app/core/theme/app_colors.dart';

class QuestionPopup extends StatefulWidget {
  final String personName;
  final VoidCallback onSent;
  const QuestionPopup({super.key, required this.personName, required this.onSent});

  @override
  State<QuestionPopup> createState() => _QuestionPopupState();
}

class _QuestionPopupState extends State<QuestionPopup> {
  final TextEditingController _controller = TextEditingController();
  bool _sending = false;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        width: 370,
        padding: const EdgeInsets.all(0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Ask Question', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.white)),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.white),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Text('To: ${widget.personName}', style: const TextStyle(fontSize: 15, color: Colors.white70)),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: TextField(
                controller: _controller,
                minLines: 3,
                maxLines: 5,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'Type your question...',
                  hintStyle: const TextStyle(color: Colors.white70),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
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
                  setState(() {});
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                children: [
                  ElevatedButton(
                    onPressed: _sending || _controller.text.trim().isEmpty
                        ? null
                        : () async {
                            setState(() => _sending = true);
                            await Future.delayed(const Duration(milliseconds: 500));
                            widget.onSent();
                            if (mounted) Navigator.of(context).pop();
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.sand,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    ),
                    child: _sending
                        ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                        : const Text('Send', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ),
          ],
        ).asGlass(
          tintColor: AppColors.sand.withOpacity(0.13),
          blurX: 12,
          blurY: 12,
          clipBorderRadius: BorderRadius.circular(24),
        ),
      ),
    );
  }
} 