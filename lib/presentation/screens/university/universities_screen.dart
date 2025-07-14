import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:unikwik_app/presentation/widgets/gradient_background.dart';
import 'package:unikwik_app/presentation/widgets/glass_container.dart';
import 'widgets/university_card.dart';
import 'widgets/university_filter_chip.dart';
import 'dart:convert';
import 'package:unikwik_app/presentation/widgets/profile_drawer.dart';

class UniversityScreen extends StatefulWidget {
  const UniversityScreen({super.key});

  @override
  State<UniversityScreen> createState() => _UniversityScreenState();
}

class _UniversityScreenState extends State<UniversityScreen>
    with TickerProviderStateMixin {
  // Animation controllers
  late AnimationController _searchController;
  late AnimationController _filterController;
  late AnimationController _listController;

  // Data state
  List<Map<String, dynamic>> _allUniversities = [];
  List<Map<String, dynamic>> _filteredUniversities = [];
  List<Map<String, dynamic>> _countries = [];
  bool _isLoading = true;
  String? _error;

  // Filter state
  String _searchQuery = '';
  String? _selectedCountry;
  String? _selectedRegion;
  String? _selectedRanking;
  double? _maxTuition;
  double? _maxApplicationFee;
  bool _showFilters = false;
  // 1. Add sort state
  bool _sortAscending = false;

  // Controllers
  final TextEditingController _searchTextController = TextEditingController();
  final TextEditingController _tuitionController = TextEditingController();
  final TextEditingController _applicationController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  // Filter options
  List<String> _regions = [];
  final List<String> _rankingRanges = [
    'Top 10',
    'Top 25',
    'Top 50',
    'Top 100',
    'Top 200',
    'All'
  ];

  int? _expandedIndex; // Track which card is expanded

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _loadUniversityData();
  }

  void _initializeAnimations() {
    _searchController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _filterController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _listController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    // Start animations
    _searchController.forward();
    Future.delayed(const Duration(milliseconds: 200), () {
      _filterController.forward();
    });
    Future.delayed(const Duration(milliseconds: 400), () {
      _listController.forward();
    });
  }

  Future<void> _loadUniversityData() async {
    try {
    setState(() {
      _isLoading = true;
      _error = null;
    });

      // Load countries data
      final countriesData = await rootBundle.loadString('assets/university_data/countries.json');
      final countriesList = json.decode(countriesData) as List;
      _countries = countriesList.cast<Map<String, dynamic>>();

      // Load all universities from all countries
      List<Map<String, dynamic>> allUnis = [];
      for (final country in _countries) {
        final fileName = (country['fileName'] as String?) ?? country['name'].toString().replaceAll(RegExp(r'[^a-zA-Z0-9]'), '_').toLowerCase() + '.json';
        try {
          final uniData = await rootBundle.loadString('assets/university_data/$fileName');
          final countryData = json.decode(uniData) as Map<String, dynamic>;
          final universities = countryData['universities'] as List;
          for (final u in universities) {
            // Robust parsing: skip if name or rank is null
            if (u == null || u['name'] == null || u['rank'] == null) continue;
            // Defensive: ensure all fields are strings or provide defaults
            allUnis.add({
              ...u,
              'name': u['name']?.toString() ?? '',
              'country': u['country']?.toString() ?? '',
              'region': u['region']?.toString() ?? '',
              'score': (u['score'] is num) ? u['score'] : double.tryParse(u['score']?.toString() ?? '') ?? 0.0,
              'rank': (u['rank'] is int) ? u['rank'] : int.tryParse(u['rank']?.toString() ?? '') ?? 9999,
              'tuitionFee': (u['tuitionFee'] is int) ? u['tuitionFee'] : int.tryParse(u['tuitionFee']?.toString() ?? '') ?? 0,
              'applicationFee': (u['applicationFee'] is int) ? u['applicationFee'] : int.tryParse(u['applicationFee']?.toString() ?? '') ?? 0,
              'applicationOpen': u['applicationOpen'] ?? false,
              'flag': country['flag'] ?? '',
            });
          }
    } catch (e) {
          // Ignore missing files or bad data
        }
      }

      // Extract unique regions
      final regions = allUnis
          .map((uni) => uni['region'] as String?)
          .where((region) => region != null && region.isNotEmpty)
          .map((region) => region!)
        .toSet()
        .toList();
      regions.sort();

      // Show top 10 by default
      allUnis.sort((a, b) => (a['rank'] as int).compareTo(b['rank'] as int));
      final top10 = allUnis.take(10).toList();

      setState(() {
        _allUniversities = allUnis;
        _filteredUniversities = top10;
        _regions = regions;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Failed to load university data: $e';
        _isLoading = false;
      });
    }
  }

  void _applyFilters() {
    List<Map<String, dynamic>> filtered = List.from(_allUniversities);

    // Search filter
    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((uni) {
        final name = (uni['name'] as String).toLowerCase();
        final country = (uni['country'] as String).toLowerCase();
        final query = _searchQuery.toLowerCase();
        return name.contains(query) || country.contains(query);
      }).toList();
    }

    // Country filter
    if (_selectedCountry != null) {
      filtered = filtered.where((uni) => uni['country'] == _selectedCountry).toList();
    }

    // Region filter
    if (_selectedRegion != null) {
      filtered = filtered.where((uni) => uni['region'] == _selectedRegion).toList();
    }

    // Ranking filter
    if (_selectedRanking != null) {
      final maxRank = _getMaxRankFromRange(_selectedRanking!);
      if (maxRank > 0) {
        filtered = filtered.where((uni) => (uni['rank'] as int) <= maxRank).toList();
      }
    }

    // Tuition filter
    if (_maxTuition != null) {
      filtered = filtered.where((uni) => (uni['tuitionFee'] as int) <= _maxTuition!).toList();
    }

    // Application fee filter
    if (_maxApplicationFee != null) {
      filtered = filtered.where((uni) => (uni['applicationFee'] as int) <= _maxApplicationFee!).toList();
    }

    // Sort by rank
    filtered.sort((a, b) => (a['rank'] as int).compareTo(b['rank'] as int));
    if (!_sortAscending) {
      filtered = filtered.reversed.toList();
    }

    // If no filters, show top 10 by rank (after sorting)
    if (!_hasActiveFilters) {
      filtered = filtered.take(10).toList();
    }
    setState(() {
      _filteredUniversities = filtered;
    });
  }

  int _getMaxRankFromRange(String range) {
    switch (range) {
      case 'Top 10':
        return 10;
      case 'Top 25':
        return 25;
      case 'Top 50':
        return 50;
      case 'Top 100':
        return 100;
      case 'Top 200':
        return 200;
      default:
        return 0; // All
    }
  }

  void _clearAllFilters() {
    setState(() {
      _searchQuery = '';
      _selectedCountry = null;
      _selectedRegion = null;
      _selectedRanking = null;
      _maxTuition = null;
      _maxApplicationFee = null;
      _showFilters = false;
      _sortAscending = false; // Reset sort state
    });

    _searchTextController.clear();
    _tuitionController.clear();
    _applicationController.clear();

    _applyFilters();
  }

  bool get _hasActiveFilters {
    return _searchQuery.isNotEmpty ||
        _selectedCountry != null ||
        _selectedRegion != null ||
        _selectedRanking != null ||
        _maxTuition != null ||
        _maxApplicationFee != null;
  }

  @override
  void dispose() {
    _searchController.dispose();
    _filterController.dispose();
    _listController.dispose();
    _searchTextController.dispose();
    _tuitionController.dispose();
    _applicationController.dispose();
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
                _buildHeader(),
                _buildSearchBar(),
                _buildFilterSection(),
                _buildResultsSection(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center, // Center the row
        children: [
          // Removed profile icon here
          // const SizedBox(width: 16), // Remove the gap after the icon as well
          Icon(
            Icons.school_rounded,
            color: Colors.amber[300],
            size: 32,
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Universities',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white.withOpacity(0.95),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFilterToggle() {
    final bool hasActiveFilters = _hasActiveFilters;
    return GestureDetector(
      onTap: () {
        setState(() {
          _showFilters = !_showFilters;
        });
        if (_showFilters) {
          _filterController.forward();
        } else {
          _filterController.reverse();
        }
      },
      child: GlassContainer(
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: hasActiveFilters ? Colors.amber.withOpacity(0.18) : Colors.transparent,
            borderRadius: BorderRadius.circular(16),
          ),
                    child: Row(
            mainAxisSize: MainAxisSize.min,
                      children: [
              Icon(
                _showFilters ? Icons.tune : Icons.tune_outlined,
                color: hasActiveFilters ? Colors.amber : Colors.white,
                size: 20,
              ),
              const SizedBox(width: 6),
              Text(
                'Filters',
                style: TextStyle(
                  color: hasActiveFilters ? Colors.amber : Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    ).animate(controller: _searchController)
      .fadeIn(delay: 600.ms)
      .scale(begin: const Offset(0.8, 0.8));
  }

  Widget _buildSearchBar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: GlassContainer(
                          child: TextField(
                controller: _searchTextController,
                            onChanged: (value) {
                              setState(() {
                    _searchQuery = value;
                              });
                  _applyFilters();
                            },
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                decoration: InputDecoration(
                  hintText: 'Search universities or countries...',
                              hintStyle: TextStyle(
                    color: Colors.white.withOpacity(0.6),
                                fontSize: 16,
                              ),
                              border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 16,
                              ),
                              prefixIcon: Icon(
                    Icons.search_rounded,
                    color: Colors.white.withOpacity(0.7),
                    size: 24,
                  ),
                  suffixIcon: _searchQuery.isNotEmpty
                      ? IconButton(
                          onPressed: () {
                            _searchTextController.clear();
                            setState(() {
                              _searchQuery = '';
                            });
                            _applyFilters();
                          },
                          icon: Icon(
                            Icons.clear_rounded,
                            color: Colors.white.withOpacity(0.7),
                                size: 20,
                              ),
                        )
                      : null,
                            ),
                          ),
                        ),
          ),
          const SizedBox(width: 8),
          _buildSortButton(),
          const SizedBox(width: 8),
          _buildFilterToggle(),
        ],
      ),
    ).animate(controller: _searchController)
      .fadeIn(delay: 300.ms)
      .slideY(begin: 0.3);
  }

  Widget _buildSortButton() {
    return GlassContainer(
      child: GestureDetector(
        onTap: () {
                            setState(() {
            _sortAscending = !_sortAscending;
            _applyFilters();
          });
        },
        child: Container(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Icon(
                _sortAscending ? Icons.arrow_upward : Icons.arrow_downward,
                color: Colors.white,
                size: 20,
              ),
              const SizedBox(width: 6),
              Text(
                'Sort',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFilterSection() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      height: _showFilters ? null : 0,
      child: _showFilters
          ? Container(
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: Column(
                children: [
                  _buildFilterChips(),
                  const SizedBox(height: 12),
                  _buildAdvancedFilters(),
                  const SizedBox(height: 12),
                  _buildClearFiltersButton(),
                ],
              ),
            ).animate(controller: _filterController)
              .fadeIn()
              .slideY(begin: -0.3)
          : const SizedBox.shrink(),
    );
  }

  Widget _buildFilterChips() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 8.0,
          runSpacing: 8.0,
          children: [
            // Region filter
            UniversityFilterChip(
              label: _selectedRegion ?? 'All Regions',
              isSelected: _selectedRegion != null,
              onTap: () => _showRegionPicker(),
              icon: Icons.map_rounded,
              color: Colors.green,
            ),
            // Country filter
            UniversityFilterChip(
              label: _selectedCountry ?? 'All countries',
              isSelected: _selectedCountry != null,
              onTap: () => _showCountryPicker(),
              icon: Icons.public_rounded,
              color: Colors.blue,
            ),
            // Ranking/count filter
            UniversityFilterChip(
              label: _selectedRanking ?? 'All',
              isSelected: _selectedRanking != null,
              onTap: () => _showRankingPicker(),
              icon: Icons.emoji_events_rounded,
              color: Colors.amber,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildAdvancedFilters() {
    return Row(
      children: [
        Expanded(
          child: GlassContainer(
                          child: TextField(
              controller: _tuitionController,
                            onChanged: (value) {
                              setState(() {
                  _maxTuition = double.tryParse(value);
                              });
                _applyFilters();
                            },
                            keyboardType: TextInputType.number,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                              hintText: 'Max Tuition',
                hintStyle: TextStyle(color: Colors.white.withOpacity(0.6)),
                              border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                              prefixIcon: Icon(
                  Icons.attach_money_rounded,
                  color: Colors.white.withOpacity(0.7),
                  size: 18,
                              ),
                            ),
                          ),
                        ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: GlassContainer(
                          child: TextField(
              controller: _applicationController,
                            onChanged: (value) {
                              setState(() {
                  _maxApplicationFee = double.tryParse(value);
                              });
                _applyFilters();
                            },
                            keyboardType: TextInputType.number,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Application Fee',
                hintStyle: TextStyle(color: Colors.white.withOpacity(0.6)),
                              border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                              prefixIcon: Icon(
                  Icons.description_rounded,
                  color: Colors.white.withOpacity(0.7),
                  size: 18,
                              ),
                            ),
                          ),
                        ),
        ),
      ],
    );
  }

  Widget _buildClearFiltersButton() {
    return GestureDetector(
                          onTap: _clearAllFilters,
      child: GlassContainer(
                          child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                Icons.clear_all_rounded,
                color: Colors.red[300],
                size: 18,
                                ),
                                const SizedBox(width: 8),
                                Text(
                'Clear All Filters',
                style: TextStyle(
                  color: Colors.red[300],
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
    );
  }

  Widget _buildResultsSection() {
    return Expanded(
      child: _isLoading
          ? _buildLoadingState()
          : _error != null
              ? _buildErrorState()
              : _filteredUniversities.isEmpty
                  ? _buildEmptyState()
                  : _buildUniversitiesList(),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            color: Colors.amber[300],
            strokeWidth: 3,
          ).animate(onPlay: (controller) => controller.repeat())
            .rotate(duration: 1.seconds),
          const SizedBox(height: 16),
          Text(
            'Loading universities...',
            style: TextStyle(
              color: Colors.white.withOpacity(0.8),
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
          Icon(
            Icons.error_outline_rounded,
            color: Colors.red[300],
            size: 64,
          ),
          const SizedBox(height: 16),
          Text(
            'Oops! Something went wrong',
            style: TextStyle(
              color: Colors.white.withOpacity(0.9),
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
                                  Text(
                                    _error!,
            style: TextStyle(
              color: Colors.white.withOpacity(0.7),
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          GestureDetector(
            onTap: _loadUniversityData,
            child: GlassContainer(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                child: const Text(
                  'Try Again',
                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ),
        ],
                                              ),
                                            );
                                          }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off_rounded,
            color: Colors.white.withOpacity(0.5),
            size: 64,
          ),
          const SizedBox(height: 16),
          Text(
            'No universities found',
            style: TextStyle(
              color: Colors.white.withOpacity(0.8),
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Try adjusting your filters or search terms',
            style: TextStyle(
              color: Colors.white.withOpacity(0.6),
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
          ),
          if (_hasActiveFilters) ...[
            const SizedBox(height: 20),
            GestureDetector(
              onTap: _clearAllFilters,
              child: GlassContainer(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  child: const Text(
                    'Clear Filters',
                                    style: TextStyle(
                                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildUniversitiesList() {
    return ListView.builder(
                                  controller: _scrollController,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      itemCount: _filteredUniversities.length,
                                  itemBuilder: (context, index) {
        final university = _filteredUniversities[index];
        final isExpanded = _expandedIndex == index;
                                    return Padding(
          padding: const EdgeInsets.only(bottom: 12),
                                      child: UniversityCard(
            university: university,
                                        index: index,
            isExpanded: isExpanded,
            onTap: () {
              setState(() {
                _expandedIndex = isExpanded ? null : index;
              });
            },
                                      ),
                                    );
                                  },
    );
  }

  void _showCountryPicker() {
    final filteredCountries = _selectedRegion == null
        ? _countries
        : _countries.where((c) => c['region'] == _selectedRegion).toList();
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => _buildCountryPicker(filteredCountries),
    );
  }

  void _showRegionPicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => _buildRegionPicker(),
    );
  }

  void _showRankingPicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => _buildRankingPicker(),
    );
  }

  Widget _buildCountryPicker(List<Map<String, dynamic>> countryList) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.5,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                const Text(
                  'Select Country',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const Icon(Icons.close),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: countryList.length + 1,
              itemBuilder: (context, index) {
                if (index == 0) {
                  return ListTile(
                    leading: const Icon(Icons.public),
                    title: const Text('All Countries'),
                    onTap: () {
                      setState(() {
                        _selectedCountry = null;
                      });
                      _applyFilters();
                      Navigator.pop(context);
                    },
                  );
                }
                final country = countryList[index - 1];
                return ListTile(
                  leading: Text(
                    country['flag'] ?? '🏳️',
                    style: const TextStyle(fontSize: 24),
                  ),
                  title: Text(country['name']),
                  subtitle: Text('${country['count']} universities'),
                  onTap: () {
                    setState(() {
                      _selectedCountry = country['name'];
                    });
                    _applyFilters();
                    Navigator.pop(context);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRegionPicker() {
    return Container(
      height: MediaQuery.of(context).size.height * 0.5,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                const Text(
                  'Select Region',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const Icon(Icons.close),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _regions.length + 1,
              itemBuilder: (context, index) {
                if (index == 0) {
                  return ListTile(
                    leading: const Icon(Icons.map),
                    title: const Text('All Regions'),
                    onTap: () {
                      setState(() {
                        _selectedRegion = null;
                      });
                      _applyFilters();
                      Navigator.pop(context);
                    },
                  );
                }
                final region = _regions[index - 1];
                return ListTile(
                  leading: const Icon(Icons.public),
                  title: Text(region),
                  onTap: () {
                    setState(() {
                      _selectedRegion = region;
                    });
                    _applyFilters();
                    Navigator.pop(context);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRankingPicker() {
    return Container(
      height: MediaQuery.of(context).size.height * 0.4,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                const Text(
                  'Select Ranking',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const Icon(Icons.close),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _rankingRanges.length + 1,
              itemBuilder: (context, index) {
                if (index == 0) {
                  return ListTile(
                    leading: const Icon(Icons.emoji_events),
                    title: const Text('All Rankings'),
                    onTap: () {
                      setState(() {
                        _selectedRanking = null;
                      });
                      _applyFilters();
                      Navigator.pop(context);
                    },
                  );
                }
                final ranking = _rankingRanges[index - 1];
                return ListTile(
                  leading: const Icon(Icons.star),
                  title: Text(ranking),
                  onTap: () {
                    setState(() {
                      _selectedRanking = ranking;
                    });
                    _applyFilters();
                    Navigator.pop(context);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showUniversityDetails(Map<String, dynamic> university) {
    // TODO: Implement university details screen
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${university['name']} details coming soon!'),
        backgroundColor: Colors.amber[700],
      ),
    );
  }

  // 3. Glass look for 'Upcoming' option (example usage)
  Widget _buildUpcomingOption() {
    return GlassContainer(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Icon(Icons.access_time, color: Colors.white, size: 20),
            SizedBox(width: 8),
            Text('Upcoming', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }
}
