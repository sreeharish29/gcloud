FROM python:3.10-slim

# Install system dependencies (ffmpeg is mandatory for whisper)
RUN apt-get update && apt-get install -y --no-install-recommends \
    ffmpeg \
    git \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Copy dependency definition first for layer caching
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Pre-download the Whisper base model into the image
# This prevents pods from downloading the model every time they scale up
RUN python -c "import whisper; whisper.load_model('base')"

# Copy application source code
COPY server.py .

EXPOSE 8000

CMD ["uvicorn", "server:app", "--host", "0.0.0.0", "--port", "8000"]