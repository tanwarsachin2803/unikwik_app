import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/university_model.dart';

class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get universitiesCollection =>
      _firestore.collection('universities');

  Future<List<University>> getUniversities() async {
    try {
      final QuerySnapshot snapshot = await universitiesCollection.get();
      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return University.fromFirestore(data, doc.id);
      }).toList();
    } catch (e) {
      print('Error fetching universities: $e');
      return [];
    }
  }

  /// Fetch universities by their names (for CSV-based filtering)
  Future<List<University>> getUniversitiesByNames(List<String> names) async {
    try {
      if (names.isEmpty) return [];
      
      // Firestore 'whereIn' has a limit of 10 items, so we need to batch
      List<University> allUniversities = [];
      
      for (int i = 0; i < names.length; i += 10) {
        final batch = names.skip(i).take(10).toList();
        final QuerySnapshot snapshot = await universitiesCollection
            .where('uni_name', whereIn: batch)
            .get();
        
        final universities = snapshot.docs.map((doc) {
          final data = doc.data() as Map<String, dynamic>;
          return University.fromFirestore(data, doc.id);
        }).toList();
        
        allUniversities.addAll(universities);
      }
      
      return allUniversities;
    } catch (e) {
      print('Error fetching universities by names: $e');
      return [];
    }
  }

  Future<List<University>> getFilteredUniversities({
    String? searchQuery,
    String? country,
    double? maxTuition,
    double? maxApplicationFee,
    int limit = 10,
    String? region,
  }) async {
    try {
      Query<Map<String, dynamic>> query = universitiesCollection;
      if (country != null && country.isNotEmpty) {
        query = query.where('uni_country', isEqualTo: country);
      }
      if (region != null && region.isNotEmpty && region != 'World') {
        query = query.where('uni_region', isEqualTo: region);
      }
      if (maxTuition != null) {
        query = query.where('tution_fee', isLessThanOrEqualTo: maxTuition);
      }
      if (maxApplicationFee != null) {
        query = query.where('application_fee', isLessThanOrEqualTo: maxApplicationFee);
      }
      query = query.limit(limit);
      final QuerySnapshot snapshot = await query.get();
      List<University> universities = snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return University.fromFirestore(data, doc.id);
      }).toList();
      if (searchQuery != null && searchQuery.isNotEmpty) {
        universities = universities.where((university) =>
            university.name.toLowerCase().contains(searchQuery.toLowerCase())).toList();
      }
      return universities;
    } catch (e) {
      print('Error fetching filtered universities: $e');
      return [];
    }
  }

  // Add university to watchlist
  Future<void> toggleWatchlist(String universityId, bool addedToWatchlist) async {
    try {
      await universitiesCollection.doc(universityId).update({
        'addedToWatchlist': addedToWatchlist,
      });
    } catch (e) {
      print('Error updating watchlist: $e');
    }
  }

  // Get watchlisted universities
  Future<List<University>> getWatchlistedUniversities() async {
    try {
      final QuerySnapshot snapshot = await universitiesCollection
          .where('addedToWatchlist', isEqualTo: true)
          .get();
      
      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return University.fromFirestore(data, doc.id);
      }).toList();
    } catch (e) {
      print('Error fetching watchlisted universities: $e');
      return [];
    }
  }

  // Add sample universities to Firestore (for testing) - Updated to match CSV names
  Future<void> addSampleUniversities() async {
    final List<Map<String, dynamic>> sampleUniversities = [
      {
        'uni_name': 'Massachusetts Institute of Technology (MIT)',
        'uni_country': 'United States',
        'uni_image': 'https://upload.wikimedia.org/wikipedia/commons/0/0c/MIT_Dome_night1.jpg',
        'tution_fee': 55000.0,
        'application_fee': 90.0,
        'application_open': true,
        'deadlines': 'January 1',
        'uni_region': 'United States',
        'uni_application': 'https://mit.edu',
      },
      {
        'uni_name': 'University of Cambridge',
        'uni_country': 'United Kingdom',
        'uni_image': 'https://upload.wikimedia.org/wikipedia/commons/2/29/Harvard_University_Widener_Library.jpg',
        'tution_fee': 40000.0,
        'application_fee': 60.0,
        'application_open': true,
        'deadlines': 'October 15',
        'uni_region': 'United Kingdom',
        'uni_application': 'https://cam.ac.uk',
      },
      {
        'uni_name': 'University of Oxford',
        'uni_country': 'United Kingdom',
        'uni_image': 'https://upload.wikimedia.org/wikipedia/commons/2/29/Harvard_University_Widener_Library.jpg',
        'tution_fee': 42000.0,
        'application_fee': 65.0,
        'application_open': true,
        'deadlines': 'October 15',
        'uni_region': 'United Kingdom',
        'uni_application': 'https://ox.ac.uk',
      },
      {
        'uni_name': 'Harvard University',
        'uni_country': 'United States',
        'uni_image': 'https://upload.wikimedia.org/wikipedia/commons/2/29/Harvard_University_Widener_Library.jpg',
        'tution_fee': 52000.0,
        'application_fee': 75.0,
        'application_open': true,
        'deadlines': 'January 1',
        'uni_region': 'United States',
        'uni_application': 'https://harvard.edu',
      },
      {
        'uni_name': 'Stanford University',
        'uni_country': 'United States',
        'uni_image': 'https://upload.wikimedia.org/wikipedia/commons/4/4e/Stanford_University_campus_from_above.jpg',
        'tution_fee': 54000.0,
        'application_fee': 80.0,
        'application_open': true,
        'deadlines': 'January 1',
        'uni_region': 'United States',
        'uni_application': 'https://stanford.edu',
      },
      {
        'uni_name': 'National University of Singapore (NUS)',
        'uni_country': 'Singapore',
        'uni_image': 'https://upload.wikimedia.org/wikipedia/commons/0/0c/MIT_Dome_night1.jpg',
        'tution_fee': 35000.0,
        'application_fee': 50.0,
        'application_open': true,
        'deadlines': 'March 1',
        'uni_region': 'Singapore',
        'uni_application': 'https://nus.edu.sg',
      },
      {
        'uni_name': 'The University of Melbourne',
        'uni_country': 'Australia',
        'uni_image': 'https://upload.wikimedia.org/wikipedia/commons/4/4e/Stanford_University_campus_from_above.jpg',
        'tution_fee': 38000.0,
        'application_fee': 55.0,
        'application_open': true,
        'deadlines': 'November 30',
        'uni_region': 'Australia',
        'uni_application': 'https://unimelb.edu.au',
      },
    ];

    try {
      for (final university in sampleUniversities) {
        await universitiesCollection.add(university);
      }
      print('Sample universities added successfully');
    } catch (e) {
      print('Error adding sample universities: $e');
    }
  }
} 