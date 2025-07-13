import 'package:flutter/material.dart';
import 'package:unikwik_app/presentation/widgets/gradient_background.dart';
import 'widgets/university_card.dart';
import 'widgets/glass_dropdown_chip.dart';
import 'package:unikwik_app/data/models/university_model.dart';
import 'package:unikwik_app/data/repositories/university_repository.dart';
import 'package:unikwik_app/core/services/university_ranking_service.dart';
import 'package:unikwik_app/core/models/university_ranking.dart';
import 'package:unikwik_app/presentation/screens/community/community_screen.dart';

class UniversityScreen extends StatefulWidget {
  const UniversityScreen({super.key});

  @override
  State<UniversityScreen> createState() => _UniversityScreenState();
}

class _UniversityScreenState extends State<UniversityScreen> {
  // Default values for filters
  static const String defaultRegion = 'World';
  static const String? defaultCountry = null;
  static const String defaultSearchQuery = '';
  static const String? defaultTuitionFilter = null;
  static const String? defaultApplicationFilter = null;

  String? selectedRegion = defaultRegion;
  String? selectedCountry = defaultCountry;
  String searchQuery = defaultSearchQuery;
  String? tuitionFilter = defaultTuitionFilter;
  String? applicationFilter = defaultApplicationFilter;
  
  // Controllers for better input handling
  final TextEditingController searchController = TextEditingController();
  final TextEditingController tuitionController = TextEditingController();
  final TextEditingController applicationController = TextEditingController();

  // Repository for data operations
  late final UniversityRepository _repository;
  
  // State for universities
  List<University> _universities = [];
  bool _isLoading = true;
  String? _error;

  // Dynamic filter options
  List<String> regionOptions = [];
  List<String> countryOptions = [];

  final ScrollController _scrollController = ScrollController();
  int _currentPage = 0;
  final int _pageSize = 10;
  bool _isLoadingMore = false;
  bool _hasMore = true;
  List<UniversityRanking> _allRankings = [];

  @override
  void initState() {
    super.initState();
    _repository = UniversityRepository();
    _loadFilterOptions();
    _initScrollListener();
    _loadInitialUniversities();
  }

  void _initScrollListener() {
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200 && !_isLoadingMore && _hasMore && !_isLoading) {
        _loadMoreUniversities();
      }
    });
  }

  Future<void> _loadInitialUniversities() async {
    setState(() {
      _universities = [];
      _currentPage = 0;
      _hasMore = true;
      _isLoading = true;
      _error = null;
    });
    try {
      // Load all rankings from CSV once
      _allRankings = await UniversityRankingService.loadUniversityRankings();
      await _loadMoreUniversities(reset: true);
    } catch (e) {
      setState(() {
        _error = 'Failed to load universities: $e';
        _isLoading = false;
      });
    }
  }

  Future<void> _loadMoreUniversities({bool reset = false}) async {
    if (_isLoadingMore) return;
    setState(() {
      _isLoadingMore = true;
      if (reset) _universities = [];
    });
    try {
      // Sort by ranking (ascending)
      final sorted = List<UniversityRanking>.from(_allRankings)
        ..sort((a, b) => a.ranking.compareTo(b.ranking));
      final start = _currentPage * _pageSize;
      final end = start + _pageSize;
      final pageRankings = sorted.skip(start).take(_pageSize).toList();
      if (pageRankings.isEmpty) {
        setState(() {
          _hasMore = false;
          _isLoadingMore = false;
        });
        return;
      }
      final names = pageRankings.map((r) => r.university).toList();
      final universities = await _repository.getFilteredUniversities(
        searchQuery: null,
        country: null,
        maxTuition: null,
        maxApplicationFee: null,
        limit: _pageSize,
      );
      // Only keep those in this page
      final filtered = universities.where((u) => names.contains(u.name)).toList();
      // Sort to match CSV order
      filtered.sort((a, b) => names.indexOf(a.name).compareTo(names.indexOf(b.name)));
      setState(() {
        if (reset) {
          _universities = filtered;
        } else {
          _universities.addAll(filtered);
        }
        _currentPage++;
        _hasMore = filtered.length == _pageSize;
        _isLoading = false;
        _isLoadingMore = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Failed to load more universities: $e';
        _isLoading = false;
        _isLoadingMore = false;
      });
    }
  }

  Future<void> _loadFilterOptions() async {
    // Load unique regions and countries from CSV
    final regions = await UniversityRankingService.getUniqueRegions(
      await UniversityRankingService.loadUniversityRankings(),
    );
    setState(() {
      regionOptions = ['World', ...regions];
    });
    await _updateCountryOptions(selectedRegion);
  }

  Future<void> _updateCountryOptions(String? region) async {
    final rankings = await UniversityRankingService.loadUniversityRankings();
    List<String> countries;
    if (region != null && region != 'World') {
      countries = rankings
        .where((r) => r.region == region)
        .map((r) => r.country)
        .where((c) => c.isNotEmpty)
        .toSet()
        .toList();
    } else {
      countries = UniversityRankingService.getUniqueCountries(rankings);
    }
    countries.sort();
    setState(() {
      countryOptions = countries;
    });
  }

  // Load universities from top 10 in CSV
  Future<void> _loadUniversities() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      // 1. Load all rankings from CSV
      final rankings = await UniversityRankingService.loadUniversityRankings();
      // 2. Sort by ranking (ascending, i.e., 1 is best)
      final top10 = List<UniversityRanking>.from(rankings)
        ..sort((a, b) => a.ranking.compareTo(b.ranking));
      final top10List = top10.take(10).toList();
      // 3. Get their names
      final names = top10List.map((r) => r.university).toList();
      // 4. Fetch Firestore data for these names
      final universities = await _repository.getFilteredUniversities(
        searchQuery: null,
        country: null,
        maxTuition: null,
        maxApplicationFee: null,
        limit: 10,
      );
      // 5. Filter to only those in top 10 names (in case Firestore has more)
      final filtered = universities.where((u) => names.contains(u.name)).toList();
      // 6. Sort to match CSV order
      filtered.sort((a, b) => names.indexOf(a.name).compareTo(names.indexOf(b.name)));
      setState(() {
        _universities = filtered;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Failed to load universities: $e';
        _isLoading = false;
      });
    }
  }

  // Load filtered universities
  Future<void> _loadFilteredUniversities() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      double? maxTuition;
      double? maxApplicationFee;

      if (tuitionFilter != null && tuitionFilter!.isNotEmpty) {
        maxTuition = double.tryParse(tuitionFilter!);
      }

      if (applicationFilter != null && applicationFilter!.isNotEmpty) {
        maxApplicationFee = double.tryParse(applicationFilter!);
      }

      final universities = await _repository.getFilteredUniversities(
        searchQuery: searchQuery.isNotEmpty ? searchQuery : null,
        country: selectedCountry,
        maxTuition: maxTuition,
        maxApplicationFee: maxApplicationFee,
        limit: 10,
      );

      setState(() {
        _universities = universities;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Failed to load filtered universities: $e';
        _isLoading = false;
      });
    }
  }

  // Method to clear all filters
  void _clearAllFilters() {
    setState(() {
      selectedRegion = defaultRegion;
      selectedCountry = defaultCountry;
      searchQuery = defaultSearchQuery;
      tuitionFilter = defaultTuitionFilter;
      applicationFilter = defaultApplicationFilter;
      
      // Clear text controllers
      searchController.clear();
      tuitionController.clear();
      applicationController.clear();
    });
    
    // Reload universities without filters
    _loadUniversities();
  }

  // Method to check if any filters are active
  bool _hasActiveFilters() {
    return searchQuery.isNotEmpty ||
           (selectedCountry != null && selectedCountry!.isNotEmpty) ||
           (tuitionFilter != null && tuitionFilter!.isNotEmpty) ||
           (applicationFilter != null && applicationFilter!.isNotEmpty);
  }

  // Method to check if a specific filter is active
  bool _isFilterActive(String? value) {
    return value != null && value.isNotEmpty;
  }

  // Map regions to countries
  final Map<String, List<String>> regionToCountries = {
    'World': ['USA', 'UK', 'Japan'],
    'Europe': ['UK'],
    'Asia': ['Japan'],
    'North America': ['USA'],
    // Add more as needed
  };

  List<String> get visibleCountryOptions {
    if (selectedRegion == null || selectedRegion == 'World') {
      return regionToCountries['World']!;
    }
    return regionToCountries[selectedRegion!] ?? [];
  }

  List<University> get filteredUniversities {
    var list = _universities;
    // Only show universities with a positive integer ranking
    list = list.where((u) => u.ranking != null && u.ranking! > 0).toList();
    // Filter by search query
    if (searchQuery.isNotEmpty) {
      list = list.where((u) => 
        u.name.toLowerCase().contains(searchQuery.toLowerCase())
      ).toList();
    }
    // Filter by country
    if (selectedCountry != null && selectedCountry!.isNotEmpty) {
      list = list.where((u) => u.country == selectedCountry).toList();
    }
    // Filter by tuition fee (max value)
    if (tuitionFilter != null && tuitionFilter!.isNotEmpty) {
      try {
        double maxTuition = double.parse(tuitionFilter!);
        list = list.where((u) => u.tuitionFee <= maxTuition).toList();
      } catch (e) {
        // Invalid number, ignore filter
      }
    }
    // Filter by application fee (max value)
    if (applicationFilter != null && applicationFilter!.isNotEmpty) {
      try {
        double maxApplication = double.parse(applicationFilter!);
        list = list.where((u) => u.applicationFee <= maxApplication).toList();
      } catch (e) {
        // Invalid number, ignore filter
      }
    }
    // Limit to 10 results for better performance
    return list.take(10).toList();
  }

  // Add this method to toggle watchlist
  Future<void> _toggleWatchlist(University university) async {
    final newStatus = !university.isWatchlisted;
    setState(() {
      _universities = _universities.map((u) =>
        u.id == university.id ? University(
          id: u.id,
          name: u.name,
          country: u.country,
          imageUrl: u.imageUrl,
          tuitionFee: u.tuitionFee,
          applicationFee: u.applicationFee,
          applicationOpen: u.applicationOpen,
          deadlines: u.deadlines,
          ranking: u.ranking,
          region: u.region,
          applicationUrl: u.applicationUrl,
          csvRanking: u.csvRanking,
          isWatchlisted: newStatus,
        ) : u
      ).toList();
    });
    await _repository.toggleWatchlist(university.id, newStatus);
  }

  @override
  void dispose() {
    searchController.dispose();
    tuitionController.dispose();
    applicationController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const Positioned.fill(child: GradientBackground()),
          SafeArea(
            child: Column(
              children: [
                // Header with title and tabs
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.public, color: Colors.lightBlueAccent, size: 32),
                      const SizedBox(width: 10),
                      Text(
                        'Universities',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.white.withOpacity(0.9),
                        ),
                      ),
                    ],
                  ),
                ),
                // Filters
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        // Search TextField
                        Container(
                          width: 200,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(18),
                            color: Colors.white.withOpacity(0.1),
                            border: Border.all(
                              color: _isFilterActive(searchQuery) 
                                  ? Colors.blueAccent.withOpacity(0.8)
                                  : Colors.white.withOpacity(0.2),
                              width: _isFilterActive(searchQuery) ? 2 : 1,
                            ),
                            boxShadow: _isFilterActive(searchQuery) ? [
                              BoxShadow(
                                color: Colors.blueAccent.withOpacity(0.3),
                                blurRadius: 8,
                                spreadRadius: 2,
                              ),
                            ] : null,
                          ),
                          child: TextField(
                            controller: searchController,
                            onChanged: (value) {
                              setState(() {
                                searchQuery = value;
                              });
                              _loadFilteredUniversities();
                            },
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                            decoration: const InputDecoration(
                              hintText: 'Search universities...',
                              hintStyle: TextStyle(
                                color: Colors.white70,
                                fontSize: 16,
                              ),
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                              prefixIcon: Icon(
                                Icons.search,
                                color: Colors.white70,
                                size: 20,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        GlassDropdownChip<String>(
                          options: regionOptions,
                          selectedValue: selectedRegion,
                          onChanged: (region) async {
                            setState(() {
                              selectedRegion = region;
                              selectedCountry = null;
                            });
                            await _updateCountryOptions(region);
                            _loadFilteredUniversities();
                          },
                          labelBuilder: (region) => region,
                          placeholder: 'Region',
                          isActive: selectedRegion != defaultRegion,
                          activeGlowColor: Colors.purpleAccent,
                        ),
                        const SizedBox(width: 12),
                        GlassDropdownChip<String>(
                          options: countryOptions,
                          selectedValue: selectedCountry,
                          onChanged: (country) {
                            setState(() {
                              selectedCountry = country;
                            });
                            _loadFilteredUniversities();
                          },
                          labelBuilder: (country) => country,
                          placeholder: 'Country',
                          isActive: _isFilterActive(selectedCountry),
                          activeGlowColor: Colors.cyanAccent,
                        ),
                        const SizedBox(width: 12),
                        // Tuition Fee Filter
                        Container(
                          width: 150,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(18),
                            color: Colors.white.withOpacity(0.1),
                            border: Border.all(
                              color: _isFilterActive(tuitionFilter) 
                                  ? Colors.greenAccent.withOpacity(0.8)
                                  : Colors.white.withOpacity(0.2),
                              width: _isFilterActive(tuitionFilter) ? 2 : 1,
                            ),
                            boxShadow: _isFilterActive(tuitionFilter) ? [
                              BoxShadow(
                                color: Colors.greenAccent.withOpacity(0.3),
                                blurRadius: 8,
                                spreadRadius: 2,
                              ),
                            ] : null,
                          ),
                          child: TextField(
                            controller: tuitionController,
                            onChanged: (value) {
                              setState(() {
                                tuitionFilter = value;
                              });
                              _loadFilteredUniversities();
                            },
                            keyboardType: TextInputType.number,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                            decoration: const InputDecoration(
                              hintText: 'Max Tuition',
                              hintStyle: TextStyle(
                                color: Colors.white70,
                                fontSize: 16,
                              ),
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                              prefixIcon: Icon(
                                Icons.attach_money,
                                color: Colors.white70,
                                size: 20,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        // Application Fee Filter
                        Container(
                          width: 150,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(18),
                            color: Colors.white.withOpacity(0.1),
                            border: Border.all(
                              color: _isFilterActive(applicationFilter) 
                                  ? Colors.orangeAccent.withOpacity(0.8)
                                  : Colors.white.withOpacity(0.2),
                              width: _isFilterActive(applicationFilter) ? 2 : 1,
                            ),
                            boxShadow: _isFilterActive(applicationFilter) ? [
                              BoxShadow(
                                color: Colors.orangeAccent.withOpacity(0.3),
                                blurRadius: 8,
                                spreadRadius: 2,
                              ),
                            ] : null,
                          ),
                          child: TextField(
                            controller: applicationController,
                            onChanged: (value) {
                              setState(() {
                                applicationFilter = value;
                              });
                              _loadFilteredUniversities();
                            },
                            keyboardType: TextInputType.number,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                            decoration: const InputDecoration(
                              hintText: 'Max App Fee',
                              hintStyle: TextStyle(
                                color: Colors.white70,
                                fontSize: 16,
                              ),
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                              prefixIcon: Icon(
                                Icons.description,
                                color: Colors.white70,
                                size: 20,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        // Clear All Filters Button
                        GestureDetector(
                          onTap: _clearAllFilters,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(18),
                              color: Colors.white.withOpacity(0.1),
                              border: Border.all(
                                color: _hasActiveFilters() 
                                    ? Colors.redAccent.withOpacity(0.8)
                                    : Colors.white.withOpacity(0.2),
                                width: _hasActiveFilters() ? 2 : 1,
                              ),
                              boxShadow: _hasActiveFilters() ? [
                                BoxShadow(
                                  color: Colors.redAccent.withOpacity(0.3),
                                  blurRadius: 8,
                                  spreadRadius: 2,
                                ),
                              ] : null,
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.clear_all,
                                  color: Colors.white70,
                                  size: 20,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'Clear',
                                  style: const TextStyle(
                                    color: Colors.white70,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: _isLoading
                      ? const Center(
                          child: CircularProgressIndicator(
                            color: Colors.white,
                          ),
                        )
                      : _error != null
                          ? Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    _error!,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(height: 16),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      ElevatedButton(
                                        onPressed: _loadUniversities,
                                        child: const Text('Retry'),
                                      ),
                                      const SizedBox(width: 16),
                                      ElevatedButton(
                                        onPressed: () async {
                                          try {
                                            await _repository.addSampleData();
                                            _loadUniversities();
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              const SnackBar(
                                                content: Text('Sample data added successfully!'),
                                                backgroundColor: Colors.green,
                                              ),
                                            );
                                          } catch (e) {
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              SnackBar(
                                                content: Text('Failed to add sample data: $e'),
                                                backgroundColor: Colors.red,
                                              ),
                                            );
                                          }
                                        },
                                        child: const Text('Add Sample Data'),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            )
                          : filteredUniversities.isEmpty
                              ? const Center(
                                  child: Text(
                                    'No universities found',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                    ),
                                  ),
                                )
                              : ListView.builder(
                                  controller: _scrollController,
                                  padding: const EdgeInsets.symmetric(vertical: 12),
                                  itemCount: filteredUniversities.length,
                                  itemBuilder: (context, index) {
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 12),
                                      child: UniversityCard(
                                        university: filteredUniversities[index],
                                        index: index,
                                        onWatchlistToggle: () => _toggleWatchlist(filteredUniversities[index]),
                                      ),
                                    );
                                  },
                                ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
