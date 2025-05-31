#!/bin/bash
# ------------------------------------------------------------------
# Pomodoro.sh - Script simples para gerenciar ciclos Pomodoro na Polybar
# Autor: Lucas [sftctrl]
# Licença: MIT
#
# Requisitos:
# - Bash
# - Polybar (para exibir status)
# - `paplay` (geralmente parte do pacote `pulseaudio-utils`)
#
# Uso:
# - chmod +x pomodoro.sh
# - ./pomodoro.sh status    → exibe status atual para a Polybar
# - ./pomodoro.sh toggle    → inicia ou para o contador
# - ./pomodoro.sh reset     → encerra o Pomodoro e limpa status
#
# Integração com Polybar:
# [module/pomodoro]
# type = custom/script
# exec = /caminho/para/pomodoro.sh status
# click-left = /caminho/para/pomodoro.sh toggle
# click-right = /caminho/para/pomodoro.sh reset
# tail = true
# ------------------------------------------------------------------

ARQUIVO_STATUS="/tmp/pomodoro_status"

# Tempo em minutos
TEMPO_FOCO=25
TEMPO_PAUSA=5
TEMPO_PAUSA_LONGA=15
CICLOS=4

# Cores para a Polybar (formato hexadecimal)
COR_FOCO="#ff66cc"
COR_PAUSA="#66ccff"
COR_PAUSA_LONGA="#88aaff"
COR_INATIVO="#666666"

# Mostra o status formatado para Polybar
status() {
    if [[ -s "$ARQUIVO_STATUS" ]]; then
        # Obs: o uso de `source` aqui é seguro porque controlamos a escrita no arquivo
        source "$ARQUIVO_STATUS" 2>/dev/null
        if [[ -n "$ESTADO" && -n "$MIN" && -n "$SEG" ]]; then
            case "$ESTADO" in
                foco)        cor="$COR_FOCO" ;;
                pausa)       cor="$COR_PAUSA" ;;
                pausa_longa) cor="$COR_PAUSA_LONGA" ;;
                *)           cor="$COR_INATIVO" ;;
            esac
            icon="🍅"
            label="$(printf "%02d:%02d" "$MIN" "$SEG")"
            echo "%{F$cor}${icon} ${ESTADO^^}: ${label}%{F-}"
        else
            echo "%{F$COR_INATIVO}🍅 Pomodoro inativo%{F-}"
        fi
    else
        echo "%{F$COR_INATIVO}🍅 Pomodoro inativo%{F-}"
    fi
}

# Inicia o ciclo completo
start() {
    local ciclo=0
    while true; do
        ((ciclo++))
        run_timer "$TEMPO_FOCO" foco || break
        if (( ciclo % CICLOS == 0 )); then
            run_timer "$TEMPO_PAUSA_LONGA" pausa_longa || break
        else
            run_timer "$TEMPO_PAUSA" pausa || break
        fi
    done
}

# Executa um temporizador individual
run_timer() {
    local minutos="$1"
    local estado="$2"
    local segundos=$((minutos * 60))

    while ((segundos > 0)); do
        ((segundos--)) || true
        {
            echo "ESTADO=$estado"
            echo "MIN=$((segundos / 60))"
            echo "SEG=$((segundos % 60))"
        } > "$ARQUIVO_STATUS"
        sleep 1 || break
    done

    # Aqui usamos `paplay` com sons do sistema
    case "$estado" in
        foco)        paplay /usr/share/sounds/freedesktop/stereo/message.oga ;;
        pausa|pausa_longa) paplay /usr/share/sounds/freedesktop/stereo/complete.oga ;;
    esac
}

# Alterna entre iniciar e parar o Pomodoro
toggle() {
    if pgrep -f "[p]omodoro.sh start" > /dev/null; then
        pkill -f "[p]omodoro.sh start"
        sleep 0.1
        echo "%{F$COR_INATIVO}🍅 Pomodoro inativo%{F-}" > "$ARQUIVO_STATUS"
    else
        # ❗️Limitação: usamos `nohup` e `&` por conta de como o Polybar lida com subprocessos.
        nohup "$0" start >/dev/null 2>&1 &
    fi
}

# Finaliza o Pomodoro e limpa a interface
reset() {
    pkill -f "[p]omodoro.sh start"
    echo "%{F$COR_INATIVO}🍅 Pomodoro inativo%{F-}" > "$ARQUIVO_STATUS"
}

# Interface principal do script
case "$1" in
    start) start ;;
    toggle) toggle ;;
    reset) reset ;;
    status) status ;;
    *)
        echo "Uso: $0 {start|toggle|reset|status}"
        exit 1
        ;;
esac
