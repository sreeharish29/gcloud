FROM ghcr.io/idiap/coqui-tts-cpu
ENTRYPOINT []
ENV PIP_BREAK_SYSTEM_PACKAGES=1
RUN python3 -m pip install --no-cache-dir torch torchaudio --index-url https://download.pytorch.org/whl/cpu
RUN tts --model_name tts_models/en/ljspeech/vits --text "warmup" --out_path /tmp/w.wav
CMD ["tts-server", "--model_name", "tts_models/en/ljspeech/vits", "--port", "5002"]
