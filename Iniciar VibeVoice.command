#!/bin/bash
# Duplo clique no Finder para abrir o demo do VibeVoice no navegador (macOS).
# Para encerrar, feche esta janela do Terminal ou aperte Ctrl+C.
cd "$(dirname "$0")" || exit 1

URL="http://127.0.0.1:7860"

if [ ! -d .venv ]; then
    if ! command -v uv >/dev/null 2>&1; then
        echo "uv não encontrado. Instale com: curl -LsSf https://astral.sh/uv/install.sh | sh"
        read -r -p "Pressione Enter para fechar..."
        exit 1
    fi
    echo "Primeira execução: criando o ambiente Python (pode demorar alguns minutos)..."
    uv venv --python 3.12 .venv && uv pip install --python .venv/bin/python -e . || {
        read -r -p "Falha na instalação. Pressione Enter para fechar..."
        exit 1
    }
fi

# Abre o navegador assim que o servidor responder
(
    until curl -s -o /dev/null "$URL"; do sleep 2; done
    open "$URL"
) &
WAITER=$!
trap 'kill $WAITER 2>/dev/null' EXIT

echo "Iniciando o VibeVoice... o navegador abre sozinho quando o modelo terminar de carregar."
.venv/bin/python demo/gradio_demo.py --model_path vibevoice/VibeVoice-1.5B --port 7860

read -r -p "O servidor parou. Pressione Enter para fechar..."
