FROM ghcr.io/idiap/coqui-tts-cpu
ENTRYPOINT []
COPY --from=ghcr.io/astral-sh/uv:latest /uv /usr/local/bin/uv
RUN uv pip install --python /opt/venv/bin/python --no-cache \
    --index-url https://download.pytorch.org/whl/cpu \
    --extra-index-url https://pypi.org/simple \
    torch torchaudio
RUN tts --model_name tts_models/en/ljspeech/vits --text "warmup" --out_path /tmp/w.wav
CMD ["tts-server", "--model_name", "tts_models/en/ljspeech/vits", "--port", "5002"]
