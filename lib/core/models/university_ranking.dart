class UniversityRanking {
  final int rank;
  final int ranking;
  final String university;
  final String country;
  final String region;
  final double score;
  final String continent;
  final DateTime? startDate;
  final DateTime? endDate;

  UniversityRanking({
    required this.rank,
    required this.ranking,
    required this.university,
    required this.country,
    required this.region,
    required this.score,
    required this.continent,
    this.startDate,
    this.endDate,
  });

  factory UniversityRanking.fromCsv(List<dynamic> row) {
    String rankingStr = row[1].toString().replaceAll(RegExp(r'[^0-9]'), '');
    int ranking = int.tryParse(rankingStr) ?? 0;
    // Parse dates (format: dd/MM/yyyy or dd/MM/yyyy,dd/MM/yyyy)
    DateTime? parseDate(String? s) {
      if (s == null || s.trim().isEmpty) return null;
      try {
        // Try dd/MM/yyyy
        final parts = s.trim().split('/');
        if (parts.length == 3) {
          return DateTime.parse('${parts[2]}-${parts[1].padLeft(2, '0')}-${parts[0].padLeft(2, '0')}');
        }
        // Try yyyy-MM-dd
        return DateTime.parse(s.trim());
      } catch (_) {
        return null;
      }
    }
    return UniversityRanking(
      rank: int.tryParse(row[0].toString()) ?? 0,
      ranking: ranking,
      university: row[2]?.toString().trim() ?? '',
      country: row[4]?.toString().trim() ?? '',
      region: row[6]?.toString().trim() ?? '',
      score: double.tryParse(row[5].toString()) ?? 0.0,
      continent: '',
      startDate: parseDate(row[7]?.toString()),
      endDate: parseDate(row[8]?.toString()),
    );
  }

  bool get isCurrentlyOpen {
    final now = DateTime.now();
    if (startDate != null && endDate != null) {
      return now.isAfter(startDate!) && now.isBefore(endDate!);
    }
    return false;
  }

  @override
  String toString() {
    return 'UniversityRanking(rank: $rank, ranking: $ranking, university: $university, country: $country, region: $region, score: $score, startDate: $startDate, endDate: $endDate)';
  }
} 