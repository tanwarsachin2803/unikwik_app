#!/bin/bash

set -e

# Move to project root
cd "$(dirname "$0")/.."

# Load NVM if not already loaded
export NVM_DIR="$HOME/.nvm"
if [ -s "$NVM_DIR/nvm.sh" ]; then
  . "$NVM_DIR/nvm.sh"
else
  echo "❌ NVM is not installed. Please install NVM first."
  exit 1
fi

# Ensure Node 18 is installed
if ! nvm ls 18 &>/dev/null; then
  echo "⬇️  Installing Node.js 18..."
  nvm install 18
fi

nvm use 18
NODE_VERSION=$(node --version)
if [[ $NODE_VERSION != v18* ]]; then
  echo "❌ Node.js 18 is required, but found $NODE_VERSION"
  exit 1
fi

echo "✅ Using Node.js $NODE_VERSION"

# Kill any existing backend processes
pkill -f "node.*index.js" || true
sleep 1

# Generate university data
cd backend
if [ -f utils/generateFlutterAssets.js ]; then
  echo "📊 Generating university data..."
  node utils/generateFlutterAssets.js
else
  echo "⚠️  University data generator not found, skipping."
fi

# (Add other data generators here if needed)

# Start backend
echo "🚀 Starting backend server..."
echo "   - API: http://localhost:3001"
echo "   - University API: http://localhost:3001/api/university/countries"
echo "   - Visa API: http://localhost:3001/api/visa"
echo "Press Ctrl+C to stop the server."
node index.js 