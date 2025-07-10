import '../../core/models/university_ranking.dart';

class University {
  final String id;
  final String name;
  final String country;
  final String imageUrl;
  final double tuitionFee;
  final double applicationFee;
  final bool applicationOpen;
  final String? deadlines;
  final int? ranking;
  final String? region;
  final String? applicationUrl;
  final UniversityRanking? csvRanking;
  final bool isWatchlisted;

  University({
    required this.id,
    required this.name,
    required this.country,
    required this.imageUrl,
    required this.tuitionFee,
    required this.applicationFee,
    required this.applicationOpen,
    this.deadlines,
    this.ranking,
    this.region,
    this.applicationUrl,
    this.csvRanking,
    this.isWatchlisted = false,
  });

  factory University.fromFirestore(Map<String, dynamic> data, String id) {
    return University(
      id: id,
      name: data['uni_name'] ?? '',
      country: data['uni_country'] ?? '',
      imageUrl: data['uni_image'] ?? '',
      tuitionFee: (data['tution_fee'] ?? 0).toDouble(),
      applicationFee: (data['application_fee'] ?? 0).toDouble(),
      applicationOpen: data['application_open'] ?? false,
      deadlines: data['deadlines'],
      ranking: data['ranking'],
      region: data['uni_region'],
      applicationUrl: data['uni_application'],
      isWatchlisted: data['addedToWatchlist'] ?? false,
    );
  }

  University withCsvRanking(UniversityRanking csvRanking) {
    return University(
      id: id,
      name: name,
      country: country,
      imageUrl: imageUrl,
      tuitionFee: tuitionFee,
      applicationFee: applicationFee,
      applicationOpen: applicationOpen,
      deadlines: deadlines,
      ranking: csvRanking.ranking,
      region: region,
      applicationUrl: applicationUrl,
      csvRanking: csvRanking,
      isWatchlisted: isWatchlisted,
    );
  }

  int? get effectiveRanking => csvRanking?.ranking ?? ranking;
  double? get score => csvRanking?.score;

  Map<String, dynamic> toFirestore() {
    return {
      'uni_name': name,
      'uni_country': country,
      'uni_image': imageUrl,
      'tution_fee': tuitionFee,
      'application_fee': applicationFee,
      'application_open': applicationOpen,
      'deadlines': deadlines,
      'ranking': ranking,
      'uni_region': region,
      'uni_application': applicationUrl,
      'addedToWatchlist': isWatchlisted,
    };
  }
} 