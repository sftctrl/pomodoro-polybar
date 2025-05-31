#!/bin/bash

# Instalação do script Pomodoro na máquina do usuário

set -e  # Encerra se qualquer comando falhar

echo "🛠 Instalando o Pomodoro para Polybar..."

# Caminho padrão de instalação
DEST="$HOME/.local/bin"

# Garante que o diretório exista
mkdir -p "$DEST"

# Torna o script executável
chmod +x pomodoro.sh

# Copia ou cria um link simbólico
cp -f pomodoro.sh "$DEST/pomodoro"

echo "✅ Script copiado para $DEST/pomodoro"

# Verifica se o diretório está no PATH
if [[ ":$PATH:" != *":$DEST:"* ]]; then
    echo "⚠️ AVISO: $DEST não está no seu PATH."
    echo "   Adicione esta linha ao seu ~/.bashrc ou ~/.zshrc:"
    echo "   export PATH=\"\$PATH:$DEST\""
fi

# Instrução final
echo ""
echo "🚀 Agora você pode adicionar o Pomodoro à sua Polybar:"
echo "Exemplo de módulo:"
echo ""
echo "[module/pomodoro]"
echo "type = custom/script"
echo "exec = $DEST/pomodoro"
echo "click-left = $DEST/pomodoro toggle"
echo "click-right = $DEST/pomodoro stop"
echo "interval = 1"
echo ""
echo "🎉 Instalação concluída!"
