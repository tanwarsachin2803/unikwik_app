const fs = require('fs');
const path = require('path');

// Function to parse CSV and generate JSON files for each country
function parseCSVAndGenerateJSON() {
  try {
    // Read the CSV file
    const csvPath = path.join(__dirname, '../../Ranking - Sheet1.csv');
    const csvContent = fs.readFileSync(csvPath, 'utf-8');
    
    // Parse CSV content
    const lines = csvContent.split('\n');
    const headers = lines[0].split(',').map(h => h.trim());
    
    // Create university_data directory if it doesn't exist
    const outputDir = path.join(__dirname, '../data/university_data');
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
        
        // Clean and structure the data
        const cleanUniversity = {
          id: `${country}_${universitiesByCountry[country].length + 1}`,
          rank: parseInt(university.Rank) || 0,
          ranking: university.Ranking || '',
          name: university.University || '',
          code: university.Code || '',
          country: country,
          score: parseFloat(university.Score) || 0,
          region: university.Region || '',
          startDate: university.Start_Date || '',
          endDate: university.End_Date || '',
          // Additional fields for enhanced data
          tuitionFee: Math.floor(Math.random() * 50000) + 10000, // Mock data
          applicationFee: Math.floor(Math.random() * 200) + 50, // Mock data
          applicationOpen: Math.random() > 0.5, // Mock data
          applicationUrl: `https://${university.University?.toLowerCase().replace(/\s+/g, '')}.edu`,
          imageUrl: `https://via.placeholder.com/300x200/4A90E2/FFFFFF?text=${encodeURIComponent(university.University || 'University')}`,
          isWatchlisted: false
        };
        
        universitiesByCountry[country].push(cleanUniversity);
      }
    }
    
    // Generate JSON files for each country
    Object.keys(universitiesByCountry).forEach(country => {
      const countryData = {
        country: country,
        totalUniversities: universitiesByCountry[country].length,
        universities: universitiesByCountry[country].sort((a, b) => a.rank - b.rank)
      };
      
      const fileName = `${country.replace(/[^a-zA-Z0-9]/g, '_')}.json`;
      const filePath = path.join(outputDir, fileName);
      
      fs.writeFileSync(filePath, JSON.stringify(countryData, null, 2));
      console.log(`Generated: ${fileName} with ${countryData.totalUniversities} universities`);
    });
    
    // Generate a summary file with all countries
    const summary = {
      totalCountries: Object.keys(universitiesByCountry).length,
      totalUniversities: Object.values(universitiesByCountry).reduce((sum, unis) => sum + unis.length, 0),
      countries: Object.keys(universitiesByCountry).map(country => ({
        name: country,
        count: universitiesByCountry[country].length,
        fileName: `${country.replace(/[^a-zA-Z0-9]/g, '_')}.json`
      })).sort((a, b) => b.count - a.count)
    };
    
    const summaryPath = path.join(outputDir, 'summary.json');
    fs.writeFileSync(summaryPath, JSON.stringify(summary, null, 2));
    console.log(`Generated summary.json with ${summary.totalCountries} countries and ${summary.totalUniversities} universities`);
    
    return summary;
    
  } catch (error) {
    console.error('Error parsing CSV:', error);
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
    'Saudi Arabia': '🇸🇦'
  };
  
  return flagMap[countryName] || '🏳️';
}

// Export functions
module.exports = {
  parseCSVAndGenerateJSON,
  getCountryFlag
};

// Run if called directly
if (require.main === module) {
  parseCSVAndGenerateJSON();
} 