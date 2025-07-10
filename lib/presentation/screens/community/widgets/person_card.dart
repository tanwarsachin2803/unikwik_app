import 'package:flutter/material.dart';

class PersonCard extends StatelessWidget {
  final Map<String, dynamic> person;
  final VoidCallback onConnect;
  final VoidCallback onAsk;
  const PersonCard({super.key, required this.person, required this.onConnect, required this.onAsk});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [
              CircleAvatar(backgroundImage: NetworkImage(person['imageUrl'] ?? '')),
              const SizedBox(width: 12),
              Text(person['name'] ?? '', style: const TextStyle(fontWeight: FontWeight.bold)),
            ]),
            const SizedBox(height: 8),
            if (person['university'] != null)
              Row(children: [const Icon(Icons.school), const SizedBox(width: 4), Text(person['university'])]),
            if (person['company'] != null)
              Row(children: [const Icon(Icons.work), const SizedBox(width: 4), Text(person['company'])]),
            const SizedBox(height: 12),
            Row(children: [
              ElevatedButton(onPressed: onAsk, child: const Text('Ask Question')),
              const SizedBox(width: 8),
              ElevatedButton(onPressed: onConnect, child: const Text('Connect')),
            ])
          ],
        ),
      ),
    );
  }
} 