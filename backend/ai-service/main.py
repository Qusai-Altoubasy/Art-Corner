import os
import logging
from fastapi import FastAPI, HTTPException
from pydantic import BaseModel
import json as python_json
from pathlib import Path
from google import genai
from google.genai import types

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

# ---- Config ----
GEMINI_API_KEY = os.getenv("GEMINI_API_KEY")
if not GEMINI_API_KEY:
    logger.error("GEMINI_API_KEY is missing!")
    raise RuntimeError("GEMINI_API_KEY is not set")

client = genai.Client(api_key=GEMINI_API_KEY)

prompt_file = Path("prompt.md")
if not prompt_file.exists():
    raise FileNotFoundError("prompt.md not found! Please add it in the same folder.")

BASE_PROMPT = prompt_file.read_text(encoding="utf-8")

# ---- App ----
app = FastAPI()

# ---- Models ----
class AiQueryRequest(BaseModel):
    question: str

# ---- Endpoint ----
@app.post("/ai/analytics/query")
async def interpret_question(request: AiQueryRequest):
    try:

        full_prompt = (
            BASE_PROMPT
            + "\n\nUser question: \""
            + request.question
            + "\""
        )

        response = await client.aio.models.generate_content(
            model="gemini-3-flash-preview",
            contents=full_prompt,
            config=types.GenerateContentConfig(
                temperature=0.0
            )
        )
        if not response.text:
            logger.warning("AI returned empty response")
            raise HTTPException(status_code=500, detail="Empty AI response")

        return python_json.loads(response.text)

    except python_json.JSONDecodeError as je:
        logger.error(f"JSON Parse Error: {je}")
        raise HTTPException(status_code=500, detail="AI response was not valid JSON")

    except Exception as e:
        logger.error(f"Unexpected Error: {e}")
        raise HTTPException(status_code=500, detail=str(e))