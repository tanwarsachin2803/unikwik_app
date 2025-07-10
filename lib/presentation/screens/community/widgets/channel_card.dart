import 'package:flutter/material.dart';

class ChannelCard extends StatelessWidget {
  final Map<String, dynamic> channel;
  final bool joined;
  final VoidCallback onTap;
  const ChannelCard({super.key, required this.channel, required this.joined, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 220,
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.only(right: 12),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.2),
          borderRadius: BorderRadius.circular(18),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(channel['name'] ?? '', style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text('${channel['emoji'] ?? ''} ${channel['latestMessage'] ?? ''}'),
            const SizedBox(height: 4),
            Text('- ${channel['author'] ?? ''}', style: const TextStyle(fontSize: 12, fontStyle: FontStyle.italic)),
          ],
        ),
      ),
    );
  }
} 