const fs = require('fs');
const path = require('path');

// Function to parse CSV and generate JSON files for Flutter assets
function generateFlutterAssets() {
  try {
    // Read the CSV file
    const csvPath = path.join(__dirname, '../../Ranking - Sheet1.csv');
    const csvContent = fs.readFileSync(csvPath, 'utf-8');
    
    // Parse CSV content
    const lines = csvContent.split('\n');
    const headers = lines[0].split(',').map(h => h.trim());
    
    // Create university_data directory in Flutter assets if it doesn't exist
    const outputDir = path.join(__dirname, '../../assets/university_data');
    if (!fs.existsSync(outputDir)) {
      fs.mkdirSync(outputDir, { recursive: true });
    }
    
    // Group universities by country
    const universitiesByCountry = {};
    
    for (let i = 1; i < lines.length; i++) {
      const line = lines[i].trim();
      if (!line) continue;
      
      // Handle CSV parsing with quotes
      const values = [];
      let current = '';
      let inQuotes = false;
      
      for (let j = 0; j < line.length; j++) {
        const char = line[j];
        if (char === '"') {
          inQuotes = !inQuotes;
        } else if (char === ',' && !inQuotes) {
          values.push(current.trim());
          current = '';
        } else {
          current += char;
        }
      }
      values.push(current.trim()); // Add the last value
      
      if (values.length >= headers.length) {
        const university = {};
        headers.forEach((header, index) => {
          university[header] = values[index] || '';
        });
        
        const country = university.Country || 'Unknown';
        if (!universitiesByCountry[country]) {
          universitiesByCountry[country] = [];
        }
        
        // Clean and structure the data for Flutter
        const cleanUniversity = {
          id: `${country.replace(/[^a-zA-Z0-9]/g, '_')}_${universitiesByCountry[country].length + 1}`,
          rank: parseInt(university.Rank) || 0,
          ranking: university.Ranking || '',
          name: university.University || '',
          code: university.Code || '',
          country: country,
          score: parseFloat(university.Score) || 0,
          region: university.Region || '',
          startDate: university.Start_Date || '',
          endDate: university.End_Date || '',
          // Enhanced data for better UI
          tuitionFee: Math.floor(Math.random() * 50000) + 10000, // Mock data
          applicationFee: Math.floor(Math.random() * 200) + 50, // Mock data
          applicationOpen: Math.random() > 0.5, // Mock data
          applicationUrl: `https://${university.University?.toLowerCase().replace(/\s+/g, '')}.edu`,
          imageUrl: `https://via.placeholder.com/300x200/4A90E2/FFFFFF?text=${encodeURIComponent(university.University || 'University')}`,
          isWatchlisted: false,
          // Additional fields for rich UI
          description: `${university.University} is a prestigious university located in ${country}.`,
          programs: ['Computer Science', 'Engineering', 'Business', 'Arts', 'Medicine'],
          acceptanceRate: Math.floor(Math.random() * 30) + 10, // Mock data
          studentCount: Math.floor(Math.random() * 50000) + 5000, // Mock data
          founded: Math.floor(Math.random() * 200) + 1800, // Mock data
          campusType: ['Urban', 'Suburban', 'Rural'][Math.floor(Math.random() * 3)],
          worldRanking: parseInt(university.Rank) || 0,
          countryRanking: universitiesByCountry[country].length + 1
        };
        
        universitiesByCountry[country].push(cleanUniversity);
      }
    }
    
    // Generate JSON files for each country
    Object.keys(universitiesByCountry).forEach(country => {
      const countryData = {
        country: country,
        flag: getCountryFlag(country),
        totalUniversities: universitiesByCountry[country].length,
        universities: universitiesByCountry[country].sort((a, b) => a.rank - b.rank)
      };
      
      const fileName = `${country.replace(/[^a-zA-Z0-9]/g, '_').toLowerCase()}.json`;
      const filePath = path.join(outputDir, fileName);
      
      fs.writeFileSync(filePath, JSON.stringify(countryData, null, 2));
      console.log(`✅ Generated: ${fileName} with ${countryData.totalUniversities} universities`);
    });
    
    // Generate a summary file with all countries
    const summary = {
      totalCountries: Object.keys(universitiesByCountry).length,
      totalUniversities: Object.values(universitiesByCountry).reduce((sum, unis) => sum + unis.length, 0),
      lastUpdated: new Date().toISOString(),
      countries: Object.keys(universitiesByCountry).map(country => ({
        name: country,
        flag: getCountryFlag(country),
        count: universitiesByCountry[country].length,
        fileName: `${country.replace(/[^a-zA-Z0-9]/g, '_').toLowerCase()}.json`
      })).sort((a, b) => b.count - a.count)
    };
    
    const summaryPath = path.join(outputDir, 'summary.json');
    fs.writeFileSync(summaryPath, JSON.stringify(summary, null, 2));
    console.log(`✅ Generated summary.json with ${summary.totalCountries} countries and ${summary.totalUniversities} universities`);
    
    // Generate a countries list file for easy access
    const countriesList = Object.keys(universitiesByCountry).map(country => ({
      name: country,
      flag: getCountryFlag(country),
      count: universitiesByCountry[country].length,
      region: universitiesByCountry[country][0]?.region || 'Unknown'
    })).sort((a, b) => a.name.localeCompare(b.name));
    
    const countriesPath = path.join(outputDir, 'countries.json');
    fs.writeFileSync(countriesPath, JSON.stringify(countriesList, null, 2));
    console.log(`✅ Generated countries.json with ${countriesList.length} countries`);
    
    return summary;
    
  } catch (error) {
    console.error('❌ Error generating Flutter assets:', error);
    throw error;
  }
}

// Function to get country flag emoji
function getCountryFlag(countryName) {
  const flagMap = {
    'United States': '🇺🇸',
    'United Kingdom': '🇬🇧',
    'China (Mainland)': '🇨🇳',
    'Japan': '🇯🇵',
    'Germany': '🇩🇪',
    'France': '🇫🇷',
    'Canada': '🇨🇦',
    'Australia': '🇦🇺',
    'Netherlands': '🇳🇱',
    'Switzerland': '🇨🇭',
    'Sweden': '🇸🇪',
    'Italy': '🇮🇹',
    'South Korea': '🇰🇷',
    'Hong Kong SAR': '🇭🇰',
    'Singapore': '🇸🇬',
    'Belgium': '🇧🇪',
    'Denmark': '🇩🇰',
    'Finland': '🇫🇮',
    'Norway': '🇳🇴',
    'Austria': '🇦🇹',
    'Spain': '🇪🇸',
    'Ireland': '🇮🇪',
    'Brazil': '🇧🇷',
    'Argentina': '🇦🇷',
    'Chile': '🇨🇱',
    'Mexico': '🇲🇽',
    'Russia': '🇷🇺',
    'India': '🇮🇳',
    'Malaysia': '🇲🇾',
    'Taiwan': '🇹🇼',
    'New Zealand': '🇳🇿',
    'South Africa': '🇿🇦',
    'Qatar': '🇶🇦',
    'Saudi Arabia': '🇸🇦',
    'Colombia': '🇨🇴',
    'Thailand': '🇹🇭',
    'Israel': '🇮🇱',
    'Lebanon': '🇱🇧',
    'Kazakhstan': '🇰🇿',
    'United Arab Emirates': '🇦🇪',
    'Indonesia': '🇮🇩',
    'Czech Republic': '🇨🇿',
    'Portugal': '🇵🇹',
    'Macau SAR': '🇲🇴',
    'Poland': '🇵🇱',
    'Pakistan': '🇵🇰',
    'Iran (Islamic Republic of)': '🇮🇷',
    'Turkey': '🇹🇷',
    'Peru': '🇵🇪',
    'Greece': '🇬🇷',
    'Estonia': '🇪🇪',
    'Cyprus': '🇨🇾',
    'Egypt': '🇪🇬',
    'Luxembourg': '🇱🇺',
    'Belarus': '🇧🇾',
    'Brunei': '🇧🇳',
    'Philippines': '🇵🇭',
    'Oman': '🇴🇲',
    'Lithuania': '🇱🇹',
    'Jordan': '🇯🇴',
    'Vietnam': '🇻🇳',
    'Costa Rica': '🇨🇷',
    'Bahrain': '🇧🇭',
    'Venezuela': '🇻🇪',
    'Hungary': '🇭🇺',
    'Slovenia': '🇸🇮',
    'Cuba': '🇨🇺',
    'Uruguay': '🇺🇾',
    'Kuwait': '🇰🇼',
    'Ukraine': '🇺🇦',
    'Bangladesh': '🇧🇩',
    'Serbia': '🇷🇸',
    'Bulgaria': '🇧🇬',
    'Latvia': '🇱🇻',
    'Croatia': '🇭🇷',
    'Slovakia': '🇸🇰',
    'Romania': '🇷🇴',
    'Georgia': '🇬🇪',
    'Ecuador': '🇪🇨',
    'Ethiopia': '🇪🇹',
    'Kyrgyzstan': '🇰🇬',
    'Malta': '🇲🇹',
    'Uganda': '🇺🇬',
    'Panama': '🇵🇦',
    'Tunisia': '🇹🇳',
    'Iraq': '🇮🇶',
    'Ghana': '🇬🇭',
    'Palestinian Territory (Occupied)': '🇵🇸',
    'Azerbaijan': '🇦🇿',
    'Dominican Republic': '🇩🇴',
    'Puerto Rico': '🇵🇷',
    'Paraguay': '🇵🇾',
    'Sri Lanka': '🇱🇰',
    'Kenya': '🇰🇪',
    'Armenia': '🇦🇲',
    'Syrian Arab Republic': '🇸🇾',
    'Guatemala': '🇬🇹',
    'Bolivia': '🇧🇴',
    'Morocco': '🇲🇦',
    'Iceland': '🇮🇸',
    'Sudan': '🇸🇩',
    'Bosnia and Herzegovina': '🇧🇦',
    'Honduras': '🇭🇳',
    'Nigeria': '🇳🇬'
  };
  
  return flagMap[countryName] || '🏳️';
}

// Export functions
module.exports = {
  generateFlutterAssets,
  getCountryFlag
};

// Run if called directly
if (require.main === module) {
  generateFlutterAssets();
} 