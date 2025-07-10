import '../models/university_model.dart';

class UniversityService {
  static List<University> getSampleUniversities() {
    return [
      University(
        id: 1,
        name: 'University Cambridge',
        country: 'USA',
        imageUrl: 'https://images.unsplash.com/photo-1506744038136-46273834b3fb',
        tuitionFee: 0,
        applicationFee: 90,
        addedToWatchlist: true,
        startMonth: 'September',
        flagCode: 'us',
      ),
      University(
        id: 2,
        name: 'Stanford University',
        country: 'US',
        imageUrl: 'https://images.unsplash.com/photo-1464983953574-0892a716854b',
        tuitionFee: 0,
        applicationFee: 40,
        addedToWatchlist: true,
        startMonth: 'September',
        chanceOfAccept: 90,
        semester: 'Winter semester',
        flagCode: 'us',
      ),
      University(
        id: 3,
        name: 'Stanford University',
        country: 'USA',
        imageUrl: 'https://images.unsplash.com/photo-1503676382389-4809596d5290',
        tuitionFee: 0,
        applicationFee: 40,
        addedToWatchlist: true,
        startMonth: 'September',
        semester: 'December',
        flagCode: 'us',
      ),
    ];
  }
} 