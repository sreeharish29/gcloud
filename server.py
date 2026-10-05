from fastapi import FastAPI, UploadFile, File, HTTPException
import whisper
import tempfile
import time
import os
from fastapi.middleware.cors import CORSMiddleware
app = FastAPI()
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # Or specify your frontend URL, e.g. ["http://localhost:3000"]
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)
# Load the model once at startup (not per-request)
model = whisper.load_model("base")


@app.post("/transcribe")
async def transcribe(file: UploadFile = File(...)):
    if not file.filename.endswith((".mp3", ".wav", ".m4a")):
        raise HTTPException(status_code=400, detail="Please upload an mp3/wav/m4a file")

    # Save uploaded file to a temp path
    suffix = os.path.splitext(file.filename)[1]
    tmp = tempfile.NamedTemporaryFile(delete=False, suffix=suffix)
    contents = await file.read()
    tmp.write(contents)
    tmp.close()

    # Single process, no threading: this blocks until transcription is done,
    # so concurrent requests queue up one at a time on this worker - which
    # mirrors one Kubernetes pod handling one request at a time.
    start = time.time()
    result = model.transcribe(tmp.name)
    end = time.time()

    os.remove(tmp.name)

    return {
        "filename": file.filename,
        "text": result["text"],
        "time_taken_seconds": round(end - start, 2)
    }