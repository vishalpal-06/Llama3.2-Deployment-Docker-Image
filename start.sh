#!/bin/bash

# Start Ollama server in the background
/usr/local/bin/ollama serve &

# Wait a few seconds for Ollama to initialize
sleep 5

# Run the FastAPI server
uvicorn api:app --host 0.0.0.0 --port 8000 --reload