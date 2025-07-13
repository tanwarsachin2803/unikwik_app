#!/bin/bash

PORT=3001

# Kill any process using the port
echo "Killing any process using port $PORT..."
lsof -ti:$PORT | xargs kill -9 2>/dev/null

# Start the backend
cd backend && node index.js 