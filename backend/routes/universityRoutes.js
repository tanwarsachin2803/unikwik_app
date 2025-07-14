const express = require('express');
const fs = require('fs');
const path = require('path');
const { getCountryFlag } = require('../utils/csvToJson');

const router = express.Router();

// Get all countries with university counts
router.get('/countries', (req, res) => {
  try {
    const summaryPath = path.join(__dirname, '../data/university_data/summary.json');
    if (!fs.existsSync(summaryPath)) {
      return res.status(404).json({ error: 'University data not found. Please run the CSV parser first.' });
    }
    
    const summary = JSON.parse(fs.readFileSync(summaryPath, 'utf-8'));
    
    // Add flag emojis to countries
    const countriesWithFlags = summary.countries.map(country => ({
      ...country,
      flag: getCountryFlag(country.name)
    }));
    
    res.json({
      totalCountries: summary.totalCountries,
      totalUniversities: summary.totalUniversities,
      countries: countriesWithFlags
    });
  } catch (error) {
    console.error('Error reading countries:', error);
    res.status(500).json({ error: 'Failed to load countries' });
  }
});

// Get universities by country
router.get('/country/:countryName', (req, res) => {
  try {
    const { countryName } = req.params;
    const { page = 1, limit = 20, sortBy = 'rank', sortOrder = 'asc' } = req.query;
    
    // Convert country name to filename format
    const fileName = `${countryName.replace(/[^a-zA-Z0-9]/g, '_')}.json`;
    const filePath = path.join(__dirname, '../data/university_data', fileName);
    
    if (!fs.existsSync(filePath)) {
      return res.status(404).json({ error: 'Country not found' });
    }
    
    const countryData = JSON.parse(fs.readFileSync(filePath, 'utf-8'));
    let universities = [...countryData.universities];
    
    // Apply sorting
    universities.sort((a, b) => {
      let aVal = a[sortBy];
      let bVal = b[sortBy];
      
      // Handle numeric sorting
      if (typeof aVal === 'string' && !isNaN(aVal)) aVal = parseFloat(aVal);
      if (typeof bVal === 'string' && !isNaN(bVal)) bVal = parseFloat(bVal);
      
      if (sortOrder === 'desc') {
        return bVal > aVal ? 1 : bVal < aVal ? -1 : 0;
      } else {
        return aVal > bVal ? 1 : aVal < bVal ? -1 : 0;
      }
    });
    
    // Apply pagination
    const pageNum = parseInt(page);
    const limitNum = parseInt(limit);
    const startIndex = (pageNum - 1) * limitNum;
    const endIndex = startIndex + limitNum;
    const paginatedUniversities = universities.slice(startIndex, endIndex);
    
    res.json({
      country: countryData.country,
      totalUniversities: countryData.totalUniversities,
      page: pageNum,
      limit: limitNum,
      totalPages: Math.ceil(countryData.totalUniversities / limitNum),
      universities: paginatedUniversities,
      flag: getCountryFlag(countryData.country)
    });
  } catch (error) {
    console.error('Error reading country data:', error);
    res.status(500).json({ error: 'Failed to load country data' });
  }
});

// Search universities across all countries
router.get('/search', (req, res) => {
  try {
    const { query, country, region, maxRank, minScore, maxTuition, maxApplicationFee, page = 1, limit = 20 } = req.query;
    
    if (!query && !country && !region && !maxRank && !minScore && !maxTuition && !maxApplicationFee) {
      return res.status(400).json({ error: 'At least one search parameter is required' });
    }
    
    const summaryPath = path.join(__dirname, '../data/university_data/summary.json');
    if (!fs.existsSync(summaryPath)) {
      return res.status(404).json({ error: 'University data not found' });
    }
    
    const summary = JSON.parse(fs.readFileSync(summaryPath, 'utf-8'));
    let allUniversities = [];
    
    // Load universities from relevant countries
    const countriesToSearch = country 
      ? summary.countries.filter(c => c.name.toLowerCase().includes(country.toLowerCase()))
      : summary.countries;
    
    for (const countryInfo of countriesToSearch) {
      const fileName = countryInfo.fileName;
      const filePath = path.join(__dirname, '../data/university_data', fileName);
      
      if (fs.existsSync(filePath)) {
        const countryData = JSON.parse(fs.readFileSync(filePath, 'utf-8'));
        allUniversities.push(...countryData.universities);
      }
    }
    
    // Apply filters
    let filteredUniversities = allUniversities.filter(uni => {
      // Search query filter
      if (query && !uni.name.toLowerCase().includes(query.toLowerCase())) {
        return false;
      }
      
      // Region filter
      if (region && uni.region !== region) {
        return false;
      }
      
      // Max rank filter
      if (maxRank && uni.rank > parseInt(maxRank)) {
        return false;
      }
      
      // Min score filter
      if (minScore && uni.score < parseFloat(minScore)) {
        return false;
      }
      
      // Max tuition filter
      if (maxTuition && uni.tuitionFee > parseFloat(maxTuition)) {
        return false;
      }
      
      // Max application fee filter
      if (maxApplicationFee && uni.applicationFee > parseFloat(maxApplicationFee)) {
        return false;
      }
      
      return true;
    });
    
    // Sort by rank
    filteredUniversities.sort((a, b) => a.rank - b.rank);
    
    // Apply pagination
    const pageNum = parseInt(page);
    const limitNum = parseInt(limit);
    const startIndex = (pageNum - 1) * limitNum;
    const endIndex = startIndex + limitNum;
    const paginatedUniversities = filteredUniversities.slice(startIndex, endIndex);
    
    res.json({
      query,
      totalResults: filteredUniversities.length,
      page: pageNum,
      limit: limitNum,
      totalPages: Math.ceil(filteredUniversities.length / limitNum),
      universities: paginatedUniversities
    });
  } catch (error) {
    console.error('Error searching universities:', error);
    res.status(500).json({ error: 'Failed to search universities' });
  }
});

// Get top universities globally
router.get('/top', (req, res) => {
  try {
    const { limit = 50, country, region } = req.query;
    
    const summaryPath = path.join(__dirname, '../data/university_data/summary.json');
    if (!fs.existsSync(summaryPath)) {
      return res.status(404).json({ error: 'University data not found' });
    }
    
    const summary = JSON.parse(fs.readFileSync(summaryPath, 'utf-8'));
    let allUniversities = [];
    
    // Load universities from relevant countries
    const countriesToSearch = country 
      ? summary.countries.filter(c => c.name.toLowerCase().includes(country.toLowerCase()))
      : summary.countries;
    
    for (const countryInfo of countriesToSearch) {
      const fileName = countryInfo.fileName;
      const filePath = path.join(__dirname, '../data/university_data', fileName);
      
      if (fs.existsSync(filePath)) {
        const countryData = JSON.parse(fs.readFileSync(filePath, 'utf-8'));
        let universities = countryData.universities;
        
        // Apply region filter if specified
        if (region) {
          universities = universities.filter(uni => uni.region === region);
        }
        
        allUniversities.push(...universities);
      }
    }
    
    // Sort by rank and take top N
    allUniversities.sort((a, b) => a.rank - b.rank);
    const topUniversities = allUniversities.slice(0, parseInt(limit));
    
    res.json({
      limit: parseInt(limit),
      totalFound: allUniversities.length,
      universities: topUniversities
    });
  } catch (error) {
    console.error('Error getting top universities:', error);
    res.status(500).json({ error: 'Failed to get top universities' });
  }
});

// Get regions
router.get('/regions', (req, res) => {
  try {
    const summaryPath = path.join(__dirname, '../data/university_data/summary.json');
    if (!fs.existsSync(summaryPath)) {
      return res.status(404).json({ error: 'University data not found' });
    }
    
    const summary = JSON.parse(fs.readFileSync(summaryPath, 'utf-8'));
    const regions = new Set();
    
    // Collect all regions
    for (const countryInfo of summary.countries) {
      const fileName = countryInfo.fileName;
      const filePath = path.join(__dirname, '../data/university_data', fileName);
      
      if (fs.existsSync(filePath)) {
        const countryData = JSON.parse(fs.readFileSync(filePath, 'utf-8'));
        countryData.universities.forEach(uni => {
          if (uni.region) {
            regions.add(uni.region);
          }
        });
      }
    }
    
    res.json({
      regions: Array.from(regions).sort()
    });
  } catch (error) {
    console.error('Error getting regions:', error);
    res.status(500).json({ error: 'Failed to get regions' });
  }
});

module.exports = router; 