import 'package:flutter/material.dart';
import 'package:glass/glass.dart';

class PersonCard extends StatelessWidget {
  final Map<String, dynamic> person;
  final VoidCallback onConnect;
  final VoidCallback onAsk;
  const PersonCard({super.key, required this.person, required this.onConnect, required this.onAsk});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
      padding: const EdgeInsets.all(16),
      width: MediaQuery.of(context).size.width * 0.9,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 12, offset: Offset(0, 6))],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.12),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white.withOpacity(0.18)),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: CircleAvatar(
                  radius: 32,
                  backgroundColor: Colors.blueGrey.shade100,
                  backgroundImage: person['imageUrl'] != null && person['imageUrl'].isNotEmpty
                      ? NetworkImage(person['imageUrl'])
                      : null,
                  child: person['imageUrl'] == null || person['imageUrl'].isEmpty
                      ? Icon(Icons.person, color: Colors.white, size: 36)
                      : null,
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 18.0, horizontal: 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(person['name'] ?? '', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.white)),
                          if (person['universityImage'] != null && person['universityImage'].isNotEmpty) ...[
                            const SizedBox(width: 8),
                            CircleAvatar(
                              radius: 14,
                              backgroundImage: NetworkImage(person['universityImage']),
                              backgroundColor: Colors.transparent,
                            ),
                          ]
                        ],
                      ),
                      const SizedBox(height: 6),
                      if (person['university'] != null)
                        Row(
                          children: [
                            Icon(Icons.school, color: Colors.blueAccent, size: 18),
                            const SizedBox(width: 4),
                            Flexible(child: Text(person['university'], style: TextStyle(color: Colors.blue[100], fontSize: 14, fontWeight: FontWeight.w500), overflow: TextOverflow.ellipsis)),
                          ],
                        ),
                      if (person['program'] != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 2.0),
                          child: Row(
                            children: [
                              Icon(Icons.menu_book, color: Colors.deepPurpleAccent, size: 16),
                              const SizedBox(width: 4),
                              Flexible(child: Text(person['program'], style: TextStyle(color: Colors.deepPurple[100], fontSize: 13), overflow: TextOverflow.ellipsis)),
                            ],
                          ),
                        ),
                      if (person['company'] != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 2.0),
                          child: Row(
                            children: [
                              Icon(Icons.work, color: Colors.green, size: 16),
                              const SizedBox(width: 4),
                              Flexible(child: Text(person['company'], style: TextStyle(color: Colors.green[100], fontSize: 13), overflow: TextOverflow.ellipsis)),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: onAsk,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurpleAccent,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        elevation: 0,
                      ),
                      child: const Text('Ask'),
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: onConnect,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        elevation: 0,
                      ),
                      child: const Text('Connect'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ).asGlass(
          blurX: 18,
          blurY: 18,
          tintColor: Colors.white.withOpacity(0.18),
          clipBorderRadius: BorderRadius.circular(20),
        ),
      ),
    );
  }
} 