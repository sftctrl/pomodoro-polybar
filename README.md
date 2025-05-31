# Pomodoro para Polybar

Um script simples e configurável para o método Pomodoro integrado à Polybar, com visual dinâmico, sons e controle via clique.

## Funcionalidades

- Temporizador configurável para estudo e pausa
- Indicação visual com cores dinâmicas na Polybar
- Controle por clique (iniciar, pausar, resetar)
- Alertas sonoros para início e fim dos ciclos

## Como usar

1. Clone o repositório:
   
   git clone git@github.com:sftctrl/pomodoro-polybar.git
   cd pomodoro-polybar

2. Dê permissão de execução para o script:
   
   chmod +x pomodoro.sh

3. Execute o script (se quiser testar fora da Polybar):
   
   ./pomodoro.sh

4. Configure a Polybar para usar o script (exemplo no arquivo config.ini).

## Configuração

- Modifique os tempos de estudo e pausa diretamente no script (pomodoro.sh) ou configure via variáveis de ambiente.
- Sons e cores também são configuráveis no script.

## Dependências

- bash
- paplay (para sons, parte do pacote pulseaudio-utils)
- polybar

## Licença

Este projeto está sob a licença MIT. Veja o arquivo LICENSE para mais detalhes.
