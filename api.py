from fastapi import FastAPI, HTTPException
from pydantic import BaseModel
import requests

app = FastAPI()

# Ollama API endpoint (running locally in the container)
OLLAMA_URL = "http://localhost:11434/api/generate"
MODEL_NAME = "llama3.2:3b"  # Matches the pulled model

# Define the request model for the API
class QueryRequest(BaseModel):
    query: str  # The user's query/prompt

@app.post("/query")
async def query_model(request: QueryRequest):
    """
    Endpoint to send a query to the Llama 3.2 model and get a response.
    """
    data = {
        "model": MODEL_NAME,
        "prompt": request.query,
        "stream": False  # Set to True for streaming if preferred
    }

    try:
        response = requests.post(OLLAMA_URL, json=data, timeout=30)  # 30-second timeout
        response.raise_for_status()
        result = response.json()
        return {"response": result.get("response", "No response generated.")}
    except requests.exceptions.RequestException as e:
        raise HTTPException(status_code=500, detail=f"Error interacting with Ollama: {str(e)}")

@app.get("/")
async def root():
    """
    Root endpoint for health check.
    """
    return {"message": "Ollama API is running. Use POST /query to send a prompt."}