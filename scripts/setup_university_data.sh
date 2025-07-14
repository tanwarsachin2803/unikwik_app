#!/bin/bash

echo "🎓 Setting up University Data for Unikwik App"
echo "=============================================="

# Ensure we're in the project root
cd "$(dirname "$0")/.."

# Check if Node.js 18 is available
if ! command -v nvm &> /dev/null; then
    echo "❌ NVM is not installed. Please install NVM first."
    exit 1
fi

# Use Node.js 18
echo "🔧 Setting Node.js version to 18..."
nvm use 18

# Check if Node.js 18 is active
NODE_VERSION=$(node --version)
if [[ $NODE_VERSION != v18* ]]; then
    echo "❌ Error: Node.js 18 is required, but found $NODE_VERSION"
    echo "Please install Node.js 18: nvm install 18"
    exit 1
fi

echo "✅ Using Node.js $NODE_VERSION"

# Kill any existing backend processes
echo "🔄 Stopping any existing backend processes..."
pkill -f "node.*index.js" || true
sleep 1

# Generate university data
echo "📊 Generating university data from CSV..."
cd backend
node utils/generateFlutterAssets.js

if [ $? -eq 0 ]; then
    echo "✅ University data generated successfully!"
    echo "📁 Files created in assets/university_data/"
    
    # Show summary
    echo ""
    echo "📈 Summary:"
    if [ -f "assets/university_data/summary.json" ]; then
        echo "   - $(jq '.totalCountries' assets/university_data/summary.json) countries"
        echo "   - $(jq '.totalUniversities' assets/university_data/summary.json) universities"
    fi
    
    echo ""
    echo "🚀 Starting backend server..."
    echo "   - API will be available at http://localhost:3001"
    echo "   - University API: http://localhost:3001/api/university/countries"
    echo ""
    echo "Press Ctrl+C to stop the server"
    echo ""
    
    # Start the backend
    node index.js
else
    echo "❌ Failed to generate university data"
    exit 1
fi 