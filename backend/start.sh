#!/bin/bash

# Ensure we're using Node.js 18
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

# Generate university data if it doesn't exist
if [ ! -d "data/university_data" ]; then
    echo "📊 Generating university data from CSV..."
    node utils/csvToJson.js
fi

# Start the backend
echo "🚀 Starting Unikwik API backend..."
node index.js 