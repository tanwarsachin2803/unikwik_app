const express = require('express');
const router = express.Router();
const { getVisaInfo, getAllVisaTypes, getCountries } = require('../controllers/visaController');

// Get visa information for specific type and country
router.get('/:visaType/:country', getVisaInfo);

// Get all available visa types
router.get('/types', getAllVisaTypes);

// Get all countries for a specific visa type
router.get('/:visaType/countries', getCountries);

module.exports = router; 