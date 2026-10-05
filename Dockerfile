FROM ghcr.io/idiap/coqui-tts-cpu
ENTRYPOINT []
RUN tts --model_name tts_models/en/ljspeech/vits --text "warmup" --out_path /tmp/w.wav
CMD ["tts-server", "--model_name", "tts_models/en/ljspeech/vits", "--port", "5002"]
