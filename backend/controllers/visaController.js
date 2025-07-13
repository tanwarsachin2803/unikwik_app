const path = require('path');
const fs = require('fs').promises;
const { loadVisaData } = require('../utils/fileLoader');

// Cache for loaded visa data
const visaDataCache = new Map();

exports.getVisaInfo = async (req, res) => {
  try {
    const { visaType, country } = req.params;
    
    // Validate visa type
    const validVisaTypes = ['tourist', 'study', 'work', 'medical'];
    if (!validVisaTypes.includes(visaType.toLowerCase())) {
      return res.status(400).json({ 
        error: 'Invalid visa type. Must be one of: tourist, study, work, medical' 
      });
    }

    // Load visa data
    const jsonData = await loadVisaData(visaType.toLowerCase());
    
    // Normalize country key
    const countryKey = country.toLowerCase().replace(/\s+/g, '_').replace(/-/g, '_');

    // Check if country exists
    if (!jsonData.countries[countryKey]) {
      return res.status(404).json({ 
        error: `Country '${country}' not found for ${visaType} visa type.`,
        available_countries: Object.keys(jsonData.countries).map(key => ({
          key: key,
          name: jsonData.countries[key].name
        }))
      });
    }

    // Return formatted response
    res.json({
      success: true,
      visa_type: visaType,
      country: jsonData.countries[countryKey],
      general_requirements: jsonData.general_requirements,
      common_fees: jsonData.common_fees,
      processing_times: jsonData.processing_times,
      additional_info: {
        work_rights: jsonData.work_rights || null,
        medical_categories: jsonData.medical_categories || null,
        popular_treatments: jsonData.popular_treatments || null,
        insurance_requirements: jsonData.insurance_requirements || null
      }
    });

  } catch (error) {
    console.error('Error in getVisaInfo:', error);
    res.status(500).json({ 
      error: 'Internal server error',
      message: error.message 
    });
  }
};

exports.getAllVisaTypes = async (req, res) => {
  try {
    const visaTypes = [
      {
        key: 'tourist',
        name: 'Tourist Visa',
        description: 'For leisure travel and sightseeing',
        icon: '🏖️'
      },
      {
        key: 'study',
        name: 'Student Visa',
        description: 'For educational purposes and academic programs',
        icon: '🎓'
      },
      {
        key: 'work',
        name: 'Work Visa',
        description: 'For employment and professional opportunities',
        icon: '💼'
      },
      {
        key: 'medical',
        name: 'Medical Visa',
        description: 'For healthcare treatment and medical procedures',
        icon: '🏥'
      }
    ];

    res.json({
      success: true,
      visa_types: visaTypes
    });

  } catch (error) {
    console.error('Error in getAllVisaTypes:', error);
    res.status(500).json({ 
      error: 'Internal server error',
      message: error.message 
    });
  }
};

exports.getCountries = async (req, res) => {
  try {
    const { visaType } = req.params;
    
    // Validate visa type
    const validVisaTypes = ['tourist', 'study', 'work', 'medical'];
    if (!validVisaTypes.includes(visaType.toLowerCase())) {
      return res.status(400).json({ 
        error: 'Invalid visa type. Must be one of: tourist, study, work, medical' 
      });
    }

    // Load visa data
    const jsonData = await loadVisaData(visaType.toLowerCase());
    
    // Extract countries with their details
    const countries = Object.entries(jsonData.countries).map(([key, country]) => ({
      key: key,
      name: country.name,
      flag: country.flag,
      processing_time: country.processing_time,
      fees: country.fees
    }));

    res.json({
      success: true,
      visa_type: visaType,
      countries: countries
    });

  } catch (error) {
    console.error('Error in getCountries:', error);
    res.status(500).json({ 
      error: 'Internal server error',
      message: error.message 
    });
  }
}; 