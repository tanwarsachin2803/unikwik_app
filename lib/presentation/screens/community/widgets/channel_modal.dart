import 'package:flutter/material.dart';
import 'package:glass/glass.dart';
import 'package:unikwik_app/core/theme/app_colors.dart';

class ChannelModal extends StatelessWidget {
  final Map<String, dynamic> channel;
  final bool joined;
  final VoidCallback onJoin;
  const ChannelModal({super.key, required this.channel, required this.joined, required this.onJoin});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> messages = [
      {'author': 'Ankit', 'text': 'Welcome to the channel!', 'emoji': '👋', 'time': '2 min ago'},
      {'author': 'Sara', 'text': 'Got internship at Bosch! 🚀', 'emoji': '🎉', 'time': '5 min ago'},
      {'author': 'Priya', 'text': 'Congrats!', 'emoji': '👏', 'time': '10 min ago'},
    ];
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(12),
      child: Container(
        width: double.infinity,
        height: MediaQuery.of(context).size.height * 0.95,
        padding: const EdgeInsets.all(0),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    channel['name'] ?? '',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: AppColors.deepTeal,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.white),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            ),
            const Divider(height: 1, color: Colors.white24),
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.all(18),
                itemCount: messages.length,
                itemBuilder: (context, i) {
                  final msg = messages[i];
                  return Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(msg['emoji'] ?? '', style: const TextStyle(fontSize: 22)),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    msg['author'] ?? '',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.deepTeal,
                                      fontSize: 16,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    msg['time'] ?? '',
                                    style: const TextStyle(
                                      color: Colors.white70,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 2),
                              Text(
                                msg['text'] ?? '',
                                style: const TextStyle(color: Colors.white, fontSize: 15),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ).asGlass(
                    tintColor: AppColors.sand.withOpacity(0.18),
                    blurX: 10,
                    blurY: 10,
                    clipBorderRadius: BorderRadius.circular(16),
                  );
                },
                separatorBuilder: (context, i) => const SizedBox(height: 12),
              ),
            ),
            if (joined)
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          hintText: 'Type a message...',
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
                      ),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.sand,
                        foregroundColor: AppColors.deepTeal,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                      ),
                      onPressed: () {},
                      child: const Text('Send', style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
              )
            else
              Padding(
                padding: const EdgeInsets.all(16),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.sand,
                    foregroundColor: AppColors.deepTeal,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                  ),
                  onPressed: onJoin,
                  child: const Text('Send Join Request', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ),
          ],
        ).asGlass(
          tintColor: Colors.white.withOpacity(0.13),
          blurX: 12,
          blurY: 12,
          clipBorderRadius: BorderRadius.circular(18),
        ),
      ),
    );
  }
} 