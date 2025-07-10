import 'package:flutter/material.dart';
import 'package:unikwik_app/data/models/university_model.dart';
import 'university_card.dart';

class UniversityList extends StatelessWidget {
  final List<University> universities;
  const UniversityList({super.key, required this.universities});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: universities.length,
      itemBuilder: (context, index) {
        return UniversityCard(
          university: universities[index],
          index: index,
        );
      },
    );
  }
} 