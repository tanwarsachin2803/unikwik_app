const express = require('express');
const app = express();
const cors = require('cors');
const visaRoutes = require('./routes/visaRoutes');
const universityRoutes = require('./routes/universityRoutes');

// Middleware
app.use(cors());
app.use(express.json());

// Routes
app.use('/api/visa', visaRoutes);
app.use('/api/university', universityRoutes);

// Health check endpoint
app.get('/health', (req, res) => {
  res.json({ 
    status: 'healthy', 
    message: 'Visa Service API is running',
    timestamp: new Date().toISOString()
  });
});

// Root endpoint
app.get('/', (req, res) => {
  res.json({
    message: 'Unikwik API - Visa & University Services',
    version: '1.0.0',
    endpoints: {
      health: '/health',
      visa: '/api/visa/:visaType/:country',
      university: {
        countries: '/api/university/countries',
        country: '/api/university/country/:countryName',
        search: '/api/university/search',
        top: '/api/university/top',
        regions: '/api/university/regions'
      }
    },
    examples: {
      visa: '/api/visa/tourist/united_states',
      university: '/api/university/countries'
    }
  });
});

const PORT = process.env.PORT || 3001;
app.listen(PORT, () => {
  console.log(`🚀 Unikwik API running on port ${PORT}`);
  console.log(`📊 Health check: http://localhost:${PORT}/health`);
  console.log(`🎓 University API: http://localhost:${PORT}/api/university/countries`);
  console.log(`🔍 API documentation: http://localhost:${PORT}/`);
});

module.exports = app; 