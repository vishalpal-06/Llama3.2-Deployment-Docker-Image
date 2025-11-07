# Use Ubuntu 22.04 as the base image
FROM ubuntu:22.04

# Update and install dependencies
RUN apt-get update && apt-get install -y \
    curl \
    python3 \
    python3-pip \
    && rm -rf /var/lib/apt/lists/*

# Install Python libraries: requests, FastAPI, and Uvicorn
RUN pip3 install requests fastapi uvicorn

# Install Ollama
RUN curl -fsSL https://ollama.ai/install.sh | sh

# Copy and run the model pull script (starts server, pulls model, stops server)
COPY pull_model.sh /tmp/pull_model.sh
RUN chmod +x /tmp/pull_model.sh && /tmp/pull_model.sh

# Copy the start script and API script
COPY start.sh /app/start.sh
COPY api.py /app/api.py

# Make the start script executable
RUN chmod +x /app/start.sh

# Expose the port for FastAPI (default 8000)
EXPOSE 8000

# Set working directory
WORKDIR /app

# Run the start script (starts Ollama and then the FastAPI server)
CMD ["./start.sh"]