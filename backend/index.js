const express = require('express');
const app = express();
const cors = require('cors');
const visaRoutes = require('./routes/visaRoutes');

// Middleware
app.use(cors());
app.use(express.json());

// Routes
app.use('/api/visa', visaRoutes);

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
    message: 'Visa Requirements Viewer API',
    version: '1.0.0',
    endpoints: {
      health: '/health',
      visa: '/api/visa/:visaType/:country'
    },
    example: '/api/visa/tourist/united_states'
  });
});

const PORT = process.env.PORT || 3001;
app.listen(PORT, () => {
  console.log(`🚀 Visa Service API running on port ${PORT}`);
  console.log(`📊 Health check: http://localhost:${PORT}/health`);
  console.log(`🔍 API documentation: http://localhost:${PORT}/`);
});

module.exports = app; 