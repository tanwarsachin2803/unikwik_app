import 'package:flutter/material.dart';

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
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Ask Question', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text('To: ${widget.personName}', style: const TextStyle(fontSize: 14)),
            const SizedBox(height: 12),
            TextField(
              controller: _controller,
              minLines: 3,
              maxLines: 5,
              decoration: const InputDecoration(
                hintText: 'Type your question...',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 18),
            Row(
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
                  child: _sending ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2)) : const Text('Send'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
} 