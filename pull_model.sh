#!/bin/bash

# Start Ollama server in the background
/usr/local/bin/ollama serve &

# Wait for the server to initialize (adjust sleep if needed)
sleep 5

# Pull the Llama 3.2 3B model
/usr/local/bin/ollama pull llama3.2:3b

# Stop the server
pkill ollama