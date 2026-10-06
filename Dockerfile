# VibeVoice Gradio demo
#   docker compose up --build      -> http://localhost:7860
FROM python:3.12-slim

ENV PYTHONUNBUFFERED=1 \
    PIP_NO_CACHE_DIR=1 \
    HF_HOME=/root/.cache/huggingface

WORKDIR /app

# Install dependencies first so code changes don't invalidate this layer
COPY pyproject.toml README.md ./
COPY vibevoice/__init__.py vibevoice/__init__.py
RUN pip install -e .

COPY . .

EXPOSE 7860

CMD ["python", "demo/gradio_demo.py", \
     "--model_path", "vibevoice/VibeVoice-1.5B", \
     "--host", "0.0.0.0", "--port", "7860"]
