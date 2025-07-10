import 'package:flutter/services.dart';
import 'package:csv/csv.dart';
import '../models/university_ranking.dart';

class UniversityRankingService {
  static List<UniversityRanking>? _cachedRankings;
  
  /// Load university rankings from CSV file
  static Future<List<UniversityRanking>> loadUniversityRankings() async {
    if (_cachedRankings != null) {
      return _cachedRankings!;
    }

    try {
      final csvString = await rootBundle.loadString('assets/Ranking - Sheet1.csv');
      final rows = const CsvToListConverter().convert(csvString, eol: '\n');
      
      // Skip header row and filter out invalid entries
      _cachedRankings = rows
          .skip(1)
          .where((row) => row.length >= 6 && row[2]?.toString().isNotEmpty == true)
          .map((row) => UniversityRanking.fromCsv(row))
          .where((ranking) => ranking.ranking > 0) // Only universities with valid rankings
          .toList();
      
      return _cachedRankings!;
    } catch (e) {
      print('Error loading university rankings: $e');
      return [];
    }
  }

  /// Filter rankings by search query
  static List<UniversityRanking> filterBySearch(
    List<UniversityRanking> rankings,
    String query,
  ) {
    if (query.isEmpty) return rankings;
    
    return rankings.where((ranking) {
      final searchLower = query.toLowerCase();
      return ranking.university.toLowerCase().contains(searchLower) ||
             ranking.country.toLowerCase().contains(searchLower) ||
             ranking.region.toLowerCase().contains(searchLower);
    }).toList();
  }

  /// Filter rankings by country
  static List<UniversityRanking> filterByCountry(
    List<UniversityRanking> rankings,
    String? country,
  ) {
    if (country == null || country.isEmpty) return rankings;
    
    return rankings.where((ranking) => 
      ranking.country.toLowerCase() == country.toLowerCase()
    ).toList();
  }

  /// Filter rankings by region
  static List<UniversityRanking> filterByRegion(
    List<UniversityRanking> rankings,
    String? region,
  ) {
    if (region == null || region.isEmpty) return rankings;
    
    return rankings.where((ranking) => 
      ranking.region.toLowerCase() == region.toLowerCase()
    ).toList();
  }

  /// Filter rankings by continent
  static List<UniversityRanking> filterByContinent(
    List<UniversityRanking> rankings,
    String? continent,
  ) {
    if (continent == null || continent.isEmpty) return rankings;
    
    return rankings.where((ranking) => 
      ranking.continent.toLowerCase() == continent.toLowerCase()
    ).toList();
  }

  /// Filter rankings by score range
  static List<UniversityRanking> filterByScoreRange(
    List<UniversityRanking> rankings,
    double? minScore,
    double? maxScore,
  ) {
    return rankings.where((ranking) {
      if (minScore != null && ranking.score < minScore) return false;
      if (maxScore != null && ranking.score > maxScore) return false;
      return true;
    }).toList();
  }

  /// Get unique countries from rankings
  static List<String> getUniqueCountries(List<UniversityRanking> rankings) {
    return rankings
        .map((r) => r.country)
        .where((country) => country.isNotEmpty)
        .toSet()
        .toList()
      ..sort();
  }

  /// Get unique regions from rankings
  static List<String> getUniqueRegions(List<UniversityRanking> rankings) {
    return rankings
        .map((r) => r.region)
        .where((region) => region.isNotEmpty)
        .toSet()
        .toList()
      ..sort();
  }

  /// Get unique continents from rankings
  static List<String> getUniqueContinents(List<UniversityRanking> rankings) {
    return rankings
        .map((r) => r.continent)
        .where((continent) => continent.isNotEmpty)
        .toSet()
        .toList()
      ..sort();
  }

  /// Find ranking by university name
  static UniversityRanking? findRankingByName(
    List<UniversityRanking> rankings,
    String universityName,
  ) {
    try {
      return rankings.firstWhere((ranking) =>
        ranking.university.toLowerCase() == universityName.toLowerCase()
      );
    } catch (e) {
      return null;
    }
  }

  /// Clear cache (useful for testing or reloading data)
  static void clearCache() {
    _cachedRankings = null;
  }
} 