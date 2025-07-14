# 🎓 University Feature - Unikwik App

## Overview

The University feature provides a beautiful, modern interface for browsing and filtering universities from around the world. It includes 1,498 universities across 104 countries with rich data and delightful user experience.

## ✨ Features

### 🎨 Modern UI/UX
- **Glassmorphic Design**: Beautiful glass containers with blur effects
- **Smooth Animations**: Staggered animations for cards and filters
- **Responsive Layout**: Works perfectly on all screen sizes
- **Dark Theme**: Optimized for dark backgrounds with gradient overlays

### 🔍 Advanced Filtering
- **Search**: Search by university name or country
- **Country Filter**: Filter by specific countries with flag emojis
- **Region Filter**: Filter by geographical regions
- **Ranking Filter**: Filter by world ranking ranges (Top 10, 25, 50, 100, 200)
- **Financial Filters**: Filter by maximum tuition and application fees
- **Real-time Updates**: Filters apply instantly as you type

### 📊 Rich Data Display
- **University Cards**: Beautiful cards with ranking, score, and financial info
- **Country Flags**: Visual country representation with emoji flags
- **Application Status**: Clear indicators for open/closed applications
- **Financial Information**: Tuition fees and application fees prominently displayed
- **Ranking Badges**: Golden ranking badges for top universities

### 🚀 Performance
- **Fast Loading**: Data loaded from local JSON files
- **Smooth Scrolling**: Optimized list performance
- **Instant Search**: Real-time filtering without delays

## 📁 File Structure

```
assets/university_data/
├── summary.json              # Overview of all countries and universities
├── countries.json            # List of all countries with flags
├── united_states.json        # Universities in United States
├── united_kingdom.json       # Universities in United Kingdom
├── china__mainland_.json     # Universities in China
└── ... (101 more country files)

lib/presentation/screens/university/
├── universities_screen.dart  # Main university screen
└── widgets/
    ├── university_card.dart      # University card widget
    ├── university_filter_chip.dart # Filter chip widget
    └── glass_dropdown_chip.dart   # Dropdown chip widget

backend/
├── utils/
│   ├── csvToJson.js              # CSV to JSON converter
│   └── generateFlutterAssets.js  # Flutter assets generator
├── routes/
│   └── universityRoutes.js       # University API routes
└── data/university_data/         # Backend JSON files
```

## 🛠️ Setup Instructions

### 1. Generate University Data

```bash
# Run the setup script (recommended)
./scripts/setup_university_data.sh

# Or manually:
cd backend
nvm use 18
node utils/generateFlutterAssets.js
```

### 2. Start Backend Server

```bash
cd backendR
nvm use 18
node index.js
```

### 3. Run Flutter App

```bash
flutter pub get
flutter run
```

## 📊 Data Sources

### CSV Structure
The feature uses data from `Ranking - Sheet1.csv` with the following columns:
- `Rank`: World ranking position
- `University`: University name
- `Country`: Country name
- `Score`: University score (0-100)
- `Region`: Geographical region
- `Start_Date`, `End_Date`: Application dates

### Generated JSON Structure
Each country JSON file contains:
```json
{
  "country": "United States",
  "flag": "🇺🇸",
  "totalUniversities": 199,
  "universities": [
    {
      "id": "United_States_1",
      "rank": 2,
      "name": "Massachusetts Institute of Technology",
      "country": "United States",
      "score": 100.0,
      "region": "North America",
      "tuitionFee": 49011,
      "applicationFee": 76,
      "applicationOpen": false,
      "isWatchlisted": false,
      "description": "MIT is a prestigious university...",
      "programs": ["Computer Science", "Engineering", "Business"],
      "acceptanceRate": 23,
      "studentCount": 51933,
      "founded": 1938,
      "campusType": "Suburban",
      "worldRanking": 2,
      "countryRanking": 1
    }
  ]
}
```

## 🎯 API Endpoints

### University Routes
- `GET /api/university/countries` - Get all countries with university counts
- `GET /api/university/country/:countryName` - Get universities by country
- `GET /api/university/search` - Search universities with filters
- `GET /api/university/top` - Get top universities globally
- `GET /api/university/regions` - Get all available regions

### Example Usage
```bash
# Get all countries
curl http://localhost:3001/api/university/countries

# Get universities in United States
curl http://localhost:3001/api/university/country/United%20States

# Search universities
curl "http://localhost:3001/api/university/search?query=MIT&maxRank=10"
```

## 🎨 UI Components

### UniversityCard
- **Glassmorphic container** with blur effects
- **Ranking badge** with golden gradient
- **Score indicator** with blue accent
- **Country flag** and region chip
- **Financial info chips** for tuition and application fees
- **Application status** with color-coded indicators
- **Apply button** with gradient design
- **Watchlist toggle** with heart icon

### UniversityFilterChip
- **Animated selection** with scale and shake effects
- **Color-coded borders** for different filter types
- **Check mark indicator** when selected
- **Smooth transitions** between states

### Filter Section
- **Collapsible design** with smooth animations
- **Horizontal scrolling** for filter chips
- **Advanced filters** for financial constraints
- **Clear all filters** button with red accent

## 🔧 Customization

### Adding New Countries
1. Add country to CSV file
2. Run `node utils/generateFlutterAssets.js`
3. Country will be automatically included

### Modifying Filter Options
Edit the filter arrays in `universities_screen.dart`:
```dart
List<String> _rankingRanges = [
  'Top 10', 'Top 25', 'Top 50', 'Top 100', 'Top 200', 'All'
];
```

### Styling Changes
- **Colors**: Modify color constants in widget files
- **Animations**: Adjust animation durations and effects
- **Layout**: Modify padding, margins, and spacing

## 🚀 Performance Tips

1. **Lazy Loading**: Universities are loaded in batches
2. **Caching**: Data is cached in memory after first load
3. **Optimized Images**: Using placeholder images for fast loading
4. **Efficient Filtering**: Real-time filtering with optimized algorithms

## 🐛 Troubleshooting

### Common Issues

1. **Node.js Version**: Ensure Node.js 18 is active
   ```bash
   nvm use 18
   ```

2. **Port Conflicts**: Kill existing processes
   ```bash
   pkill -f "node.*index.js"
   ```

3. **Missing Assets**: Regenerate university data
   ```bash
   cd backend && node utils/generateFlutterAssets.js
   ```

4. **Flutter Dependencies**: Update dependencies
   ```bash
   flutter pub get
   ```

### Debug Mode
Enable debug logging in the university screen:
```dart
print('Loading universities: ${universities.length}');
```

## 📈 Future Enhancements

- [ ] **University Details Screen**: Detailed view with programs, requirements
- [ ] **Watchlist Management**: Save favorite universities
- [ ] **Application Tracking**: Track application status
- [ ] **Comparison Tool**: Compare multiple universities
- [ ] **Offline Support**: Cache data for offline browsing
- [ ] **Push Notifications**: Application deadline reminders
- [ ] **Social Features**: Share universities with friends
- [ ] **Advanced Analytics**: University performance metrics

## 🤝 Contributing

1. Follow the existing code style and patterns
2. Add animations for new UI elements
3. Test on different screen sizes
4. Update documentation for new features
5. Ensure backward compatibility

---

**Built with ❤️ for the Unikwik Team** 