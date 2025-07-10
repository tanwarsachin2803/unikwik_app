import '../models/university_model.dart';
import '../providers/firebase_service.dart';
import '../../core/services/university_ranking_service.dart';
import '../../core/models/university_ranking.dart';

class UniversityRepository {
  final FirebaseService _firebaseService = FirebaseService();

  // Get all universities with CSV rankings
  Future<List<University>> getUniversities() async {
    final firestoreUniversities = await _firebaseService.getUniversities();
    final rankings = await UniversityRankingService.loadUniversityRankings();
    
    return _mergeWithRankings(firestoreUniversities, rankings);
  }

  // Get filtered universities based on CSV data
  Future<List<University>> getFilteredUniversities({
    String? searchQuery,
    String? country,
    String? region,
    String? continent,
    double? minScore,
    double? maxScore,
    double? maxTuition,
    double? maxApplicationFee,
    int limit = 10,
  }) async {
    // First, load and filter CSV rankings
    final allRankings = await UniversityRankingService.loadUniversityRankings();
    
    // Apply filters to CSV data
    var filteredRankings = allRankings;
    
    if (searchQuery != null && searchQuery.isNotEmpty) {
      filteredRankings = UniversityRankingService.filterBySearch(
        filteredRankings, 
        searchQuery
      );
    }
    
    if (country != null && country.isNotEmpty) {
      filteredRankings = UniversityRankingService.filterByCountry(
        filteredRankings, 
        country
      );
    }
    
    if (region != null && region.isNotEmpty) {
      filteredRankings = UniversityRankingService.filterByRegion(
        filteredRankings, 
        region
      );
    }
    
    if (continent != null && continent.isNotEmpty) {
      filteredRankings = UniversityRankingService.filterByContinent(
        filteredRankings, 
        continent
      );
    }
    
    if (minScore != null || maxScore != null) {
      filteredRankings = UniversityRankingService.filterByScoreRange(
        filteredRankings, 
        minScore, 
        maxScore
      );
    }
    
    // Limit results
    if (limit > 0) {
      filteredRankings = filteredRankings.take(limit).toList();
    }
    
    // Get university names from filtered rankings
    final universityNames = filteredRankings
        .map((ranking) => ranking.university)
        .where((name) => name.isNotEmpty)
        .toList();
    
    // Fetch Firestore data for these universities
    final firestoreUniversities = await _firebaseService.getUniversitiesByNames(universityNames);
    
    // Merge with rankings and apply additional Firestore filters
    var mergedUniversities = _mergeWithRankings(firestoreUniversities, filteredRankings);
    
    // Apply Firestore-specific filters
    if (maxTuition != null) {
      mergedUniversities = mergedUniversities
          .where((uni) => uni.tuitionFee <= maxTuition)
          .toList();
    }
    
    if (maxApplicationFee != null) {
      mergedUniversities = mergedUniversities
          .where((uni) => uni.applicationFee <= maxApplicationFee)
          .toList();
    }
    
    return mergedUniversities;
  }

  // Get unique countries from CSV data
  Future<List<String>> getUniqueCountries() async {
    final rankings = await UniversityRankingService.loadUniversityRankings();
    return UniversityRankingService.getUniqueCountries(rankings);
  }

  // Get unique regions from CSV data
  Future<List<String>> getUniqueRegions() async {
    final rankings = await UniversityRankingService.loadUniversityRankings();
    return UniversityRankingService.getUniqueRegions(rankings);
  }

  // Get unique continents from CSV data
  Future<List<String>> getUniqueContinents() async {
    final rankings = await UniversityRankingService.loadUniversityRankings();
    return UniversityRankingService.getUniqueContinents(rankings);
  }

  // Merge Firestore universities with CSV rankings
  List<University> _mergeWithRankings(
    List<University> firestoreUniversities,
    List<UniversityRanking> rankings,
  ) {
    return firestoreUniversities.map((university) {
      final ranking = UniversityRankingService.findRankingByName(
        rankings, 
        university.name
      );
      
      if (ranking != null) {
        return university.withCsvRanking(ranking);
      }
      
      return university;
    }).toList();
  }

  // Toggle watchlist
  Future<void> toggleWatchlist(String universityId, bool addedToWatchlist) async {
    await _firebaseService.toggleWatchlist(universityId, addedToWatchlist);
  }

  // Get watchlisted universities
  Future<List<University>> getWatchlistedUniversities() async {
    final firestoreUniversities = await _firebaseService.getWatchlistedUniversities();
    final rankings = await UniversityRankingService.loadUniversityRankings();
    
    return _mergeWithRankings(firestoreUniversities, rankings);
  }

  // Add sample data (for testing)
  Future<void> addSampleData() async {
    await _firebaseService.addSampleUniversities();
  }
} 