import 'package:flutter/material.dart';

class ChannelModal extends StatelessWidget {
  final Map<String, dynamic> channel;
  final bool joined;
  final VoidCallback onJoin;
  const ChannelModal({super.key, required this.channel, required this.joined, required this.onJoin});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> messages = [
      {'author': 'Ankit', 'text': 'Welcome to the channel!', 'emoji': '👋'},
      {'author': 'Sara', 'text': 'Got internship at Bosch! 🚀', 'emoji': '🎉'},
      {'author': 'Priya', 'text': 'Congrats!', 'emoji': '👏'},
    ];
    return Dialog(
      insetPadding: const EdgeInsets.all(12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: SizedBox(
        width: double.infinity,
        height: MediaQuery.of(context).size.height * 0.95,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(channel['name'] ?? '', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
            const Divider(),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: messages.length,
                itemBuilder: (context, i) {
                  final msg = messages[i];
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(msg['emoji'] ?? '', style: const TextStyle(fontSize: 18)),
                        const SizedBox(width: 8),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(msg['author'] ?? '', style: const TextStyle(fontWeight: FontWeight.bold)),
                            Text(msg['text'] ?? ''),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            if (joined)
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        decoration: const InputDecoration(
                          hintText: 'Type a message...',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: () {},
                      child: const Text('Send'),
                    ),
                  ],
                ),
              )
            else
              Padding(
                padding: const EdgeInsets.all(16),
                child: ElevatedButton(
                  onPressed: onJoin,
                  child: const Text('Send Join Request'),
                ),
              ),
          ],
        ),
      ),
    );
  }
} 