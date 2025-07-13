const path = require('path');
const fs = require('fs').promises;

// Cache for loaded visa data
const visaDataCache = new Map();

/**
 * Load visa data from JSON file with caching
 * @param {string} visaType - The type of visa (tourist, study, work, medical)
 * @returns {Promise<Object>} The parsed JSON data
 */
exports.loadVisaData = async (visaType) => {
  try {
    // Check cache first
    if (visaDataCache.has(visaType)) {
      return visaDataCache.get(visaType);
    }

    // Construct file path - using the existing visa data files
    const filePath = path.join(__dirname, '../../assets/visa_data', `${visaType}.json`);

    // Read and parse the file
    const fileContent = await fs.readFile(filePath, 'utf8');
    const jsonData = JSON.parse(fileContent);

    // Cache the data
    visaDataCache.set(visaType, jsonData);

    console.log(`✅ Loaded visa data for ${visaType} visa type`);
    return jsonData;

  } catch (error) {
    console.error(`❌ Error loading visa data for ${visaType}:`, error);
    
    if (error.code === 'ENOENT') {
      throw new Error(`Visa data file not found for type: ${visaType}`);
    }
    
    if (error instanceof SyntaxError) {
      throw new Error(`Invalid JSON format in visa data file for type: ${visaType}`);
    }
    
    throw new Error(`Failed to load visa data for type: ${visaType}`);
  }
};

/**
 * Clear the cache (useful for development/testing)
 */
exports.clearCache = () => {
  visaDataCache.clear();
  console.log('🗑️ Visa data cache cleared');
};

/**
 * Get cache statistics
 */
exports.getCacheStats = () => {
  return {
    cachedTypes: Array.from(visaDataCache.keys()),
    cacheSize: visaDataCache.size
  };
}; 