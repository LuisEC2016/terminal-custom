# ── Powerlevel10k: instant prompt (debe ir al inicio del .zshrc) ──────────────
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# ── Oh My Zsh ─────────────────────────────────────────────────────────────────
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="powerlevel10k/powerlevel10k"

# Forzar modo NF v3 antes de cargar p10k — VTE 0.84 mide chars suplementarios
# (U+10000+) como ancho 0, lo que hace que la detección automática falle y p10k
# caiga a modo 'compatible' mostrando los nombres de los iconos como texto.
POWERLEVEL9K_MODE=nerdfont-v3

# Plugins — todos son built-in de OMZ excepto los dos últimos (se clonan en install_profile.sh)
plugins=(
  git                       # aliases: gst, gco, gp, gl, gd, …
  z                         # cd inteligente por frecuencia (z <partial-path>)
  fzf                       # Ctrl+R historial fuzzy, Ctrl+T archivos fuzzy, Alt+C dirs
  extract                   # x <archivo> descomprime cualquier formato
  colored-man-pages         # man pages con syntax highlighting en color
  history                   # h = historial, hsi = grep historial
  history-substring-search  # flechas ↑↓ buscan en historial por substring
  zsh-syntax-highlighting   # resalta comandos válidos/inválidos en tiempo real
  zsh-autosuggestions       # sugiere comandos del historial en gris
  docker                    # completions de docker
  docker-compose            # completions de docker-compose
  npm                       # completions de npm
  pip                       # completions de pip
  python                    # aliases de python
  rust                      # completions de cargo/rustup
  # tmux: omitido — el plugin falla si tmux no está instalado; los aliases
  # se definen manualmente más abajo solo cuando tmux está disponible
  kubectl                   # completions de kubectl (si está instalado)
  aws                       # completions de aws cli (si está instalado)
)

source "$ZSH/oh-my-zsh.sh"

# ── Historial ─────────────────────────────────────────────────────────────────
HISTSIZE=100000
SAVEHIST=100000
HISTFILE="$HOME/.zsh_history"
setopt HIST_IGNORE_ALL_DUPS   # no guardar duplicados
setopt HIST_IGNORE_SPACE      # no guardar comandos que empiezan con espacio
setopt HIST_REDUCE_BLANKS     # limpiar espacios extra
setopt SHARE_HISTORY          # compartir historial entre sesiones en tiempo real
setopt EXTENDED_HISTORY       # guardar timestamp en cada entrada
setopt HIST_VERIFY            # expandir !! antes de ejecutar

# ── Opciones de shell ─────────────────────────────────────────────────────────
setopt AUTO_CD                # escribir un directorio lo entra sin "cd"
setopt CORRECT                # sugerir corrección de comandos mal escritos
setopt NO_BEEP                # sin pitidos
setopt GLOB_DOTS              # incluir archivos ocultos en globbing
setopt EXTENDED_GLOB          # patrones glob extendidos

# ── Autosuggestions: aceptar sugerencia con → ────────────────────────────────
bindkey '^ ' autosuggest-accept       # Ctrl+Space acepta toda la sugerencia
bindkey '^[[C' autosuggest-accept     # → acepta toda la sugerencia

# ── History substring search: ↑↓ con substring ───────────────────────────────
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down

# ── FZF: cargado desde ~/.fzf si existe, si no desde el sistema ──────────────
if [[ -f "$HOME/.fzf/bin/fzf" ]]; then
  export PATH="$HOME/.fzf/bin:$PATH"
  source "$HOME/.fzf/shell/completion.zsh" 2>/dev/null
  source "$HOME/.fzf/shell/key-bindings.zsh" 2>/dev/null
elif [[ -f /usr/share/doc/fzf/examples/key-bindings.zsh ]]; then
  source /usr/share/doc/fzf/examples/key-bindings.zsh
fi

# ── FZF: opciones globales con bat y eza como previewers ─────────────────────
export FZF_DEFAULT_OPTS="
  --height=40%
  --layout=reverse
  --border=rounded
  --info=inline
  --color=bg+:#1e3a4a,bg:#0c1c25,spinner:#86ffaf,hl:#5bd7ff
  --color=fg:#bdc3c7,header:#5bd7ff,info:#ffd057,pointer:#86ffaf
  --color=marker:#86ffaf,fg+:#ffffff,prompt:#86ffaf,hl+:#5bd7ff
  --bind=ctrl-/:toggle-preview
  --bind=ctrl-u:preview-page-up
  --bind=ctrl-d:preview-page-down
"
# Usar fd como fuente de fzf si está disponible
if command -v fd >/dev/null 2>&1; then
  export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
  export FZF_CTRL_T_COMMAND='fd --type f --hidden --follow --exclude .git'
  export FZF_ALT_C_COMMAND='fd --type d --hidden --follow --exclude .git'
fi
# Previewers
if command -v bat >/dev/null 2>&1; then
  export FZF_CTRL_T_OPTS="--preview 'bat --style=numbers --color=always --line-range :100 {}'"
else
  export FZF_CTRL_T_OPTS="--preview 'cat -n {} 2>/dev/null | head -100'"
fi
if command -v eza >/dev/null 2>&1; then
  export FZF_ALT_C_OPTS="--preview 'eza --tree --level=2 --color=always {}'"
else
  export FZF_ALT_C_OPTS="--preview 'ls -la {} 2>/dev/null | head -30'"
fi

# ── zoxide: reemplaza z con ranking más inteligente ───────────────────────────
if command -v zoxide >/dev/null 2>&1; then
  eval "$(zoxide init zsh)"
  # Mantener el alias 'j' para saltar rápido
  alias j='z'
  alias ji='zi'    # zi abre selector interactivo con fzf
fi

# ── eza: ls moderno con iconos y git ─────────────────────────────────────────
if command -v eza >/dev/null 2>&1; then
  alias ls='eza --color=always --group-directories-first --icons'
  alias ll='eza -lah --color=always --group-directories-first --icons --git'
  alias la='eza -a --color=always --group-directories-first --icons'
  alias lt='eza -lah --color=always --sort=modified --icons'           # por tiempo
  alias ltree='eza --tree --level=3 --color=always --icons --git'      # árbol
  alias ltree2='eza --tree --level=2 --color=always --icons'
else
  alias ls='ls --color=auto --group-directories-first'
  alias ll='ls -lah --color=auto --group-directories-first'
  alias la='ls -A --color=auto --group-directories-first'
  alias lt='ls -lath --color=auto'
fi

# ── bat: cat con syntax highlighting ─────────────────────────────────────────
if command -v bat >/dev/null 2>&1; then
  alias cat='bat --paging=never'
  alias batp='bat --paging=always'
  alias bh='bat --plain'                    # sin numeración ni decoraciones
  export MANPAGER="sh -c 'col -bx | bat -l man -p'"   # man con colores
  export BAT_THEME="TwoDark"
fi

# ── ripgrep: grep ultrarrápido ────────────────────────────────────────────────
if command -v rg >/dev/null 2>&1; then
  alias grep='rg --color=auto'             # rg como grep por defecto
  export RIPGREP_CONFIG_PATH="$HOME/.ripgreprc"
fi

# ── delta: diff mejorado ──────────────────────────────────────────────────────
if command -v delta >/dev/null 2>&1; then
  alias diff='delta'
fi

# ── btop: monitor de recursos ─────────────────────────────────────────────────
if command -v btop >/dev/null 2>&1; then
  alias top='btop'
fi

# ── duf: df visual ────────────────────────────────────────────────────────────
if command -v duf >/dev/null 2>&1; then
  alias df='duf'
else
  alias df='df -h'
fi

# ── ncdu: du interactivo ──────────────────────────────────────────────────────
if command -v ncdu >/dev/null 2>&1; then
  alias du='ncdu --color dark -rr'
else
  alias du='du -sh'
fi

# ── tmux: aliases solo si está instalado ─────────────────────────────────────
if command -v tmux >/dev/null 2>&1; then
  alias ta='tmux attach -t'             # conectarse a sesión existente
  alias tl='tmux list-sessions'         # listar sesiones
  alias ts='tmux new-session -s'        # nueva sesión con nombre
  alias tk='tmux kill-session -t'       # matar sesión
  alias td='tmux detach'                # desconectarse de sesión actual
fi

# ── lazygit: UI TUI para git ──────────────────────────────────────────────────
if command -v lazygit >/dev/null 2>&1; then
  alias lg='lazygit'
fi

# ── glow: render de Markdown en terminal ─────────────────────────────────────
if command -v glow >/dev/null 2>&1; then
  alias md='glow'
  alias readme='glow README.md'
fi

# ── navi: cheatsheets interactivos (Ctrl+G) ───────────────────────────────────
if command -v navi >/dev/null 2>&1; then
  eval "$(navi widget zsh)"
fi

# ── Portapapeles: wl-copy / xclip unificados ─────────────────────────────────
if command -v wl-copy >/dev/null 2>&1; then
  alias pbcopy='wl-copy'
  alias pbpaste='wl-paste'
elif command -v xclip >/dev/null 2>&1; then
  alias pbcopy='xclip -selection clipboard'
  alias pbpaste='xclip -selection clipboard -o'
fi

# ── Colores: grep (solo si no usa rg como grep) ───────────────────────────────
if ! command -v rg >/dev/null 2>&1; then
  alias grep='grep --color=auto'
fi
alias diff='diff --color=auto'

# ── Aliases de productividad general ─────────────────────────────────────────
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias mkdir='mkdir -pv'
alias cp='cp -iv'
alias mv='mv -iv'
alias free='free -h'
alias ports='ss -tulnp'
alias myip='curl -s ifconfig.me'

# ── Aliases de desarrollo ─────────────────────────────────────────────────────
alias py='python3'
alias pip='pip3'
alias serve='python3 -m http.server'           # servidor HTTP rápido en ./
alias json='python3 -m json.tool'              # formatear JSON desde stdin
alias urlencode='python3 -c "import sys,urllib.parse;print(urllib.parse.quote(sys.stdin.read().strip()))"'

# ── Git extras (complementan los de OMZ) ─────────────────────────────────────
alias glog='git log --oneline --graph --decorate --all'
alias gundo='git reset --soft HEAD~1'
alias gstash='git stash push -m'
alias gclean='git clean -fd'
alias gwip='git add -A && git commit -m "wip: trabajo en progreso"'
alias gunwip='git log --oneline | grep -q "wip:" && git reset HEAD~1'

# ── Funciones de utilidad para programadores ─────────────────────────────────

# mkd: crear directorio y entrar en él
mkd() { mkdir -p "$@" && cd "$@" || return 1; }

# fcd: navegar a directorio con fzf
fcd() {
  local dir
  dir=$(fd --type d --hidden --exclude .git 2>/dev/null \
        | fzf --preview 'eza --tree --level=2 --color=always {} 2>/dev/null || ls {}') \
  && cd "$dir" || return 1
}

# fopen: abrir archivo con fzf
fopen() {
  local file
  file=$(fd --type f --hidden --exclude .git 2>/dev/null | fzf \
    --preview 'bat --style=numbers --color=always --line-range :50 {} 2>/dev/null || cat {}')
  [[ -n "$file" ]] && ${EDITOR:-vim} "$file"
}

# fkill: matar proceso con fzf
fkill() {
  local pid
  pid=$(ps -ef | sed 1d | fzf -m --header="Selecciona procesos a matar" | awk '{print $2}')
  [[ -n "$pid" ]] && echo "$pid" | xargs kill -"${1:-9}"
}

# extract: descomprimir cualquier formato (respaldo si plugin no disponible)
if ! command -v extract >/dev/null 2>&1; then
  extract() {
    if [[ -f "$1" ]]; then
      case "$1" in
        *.tar.bz2) tar xjf "$1" ;;
        *.tar.gz)  tar xzf "$1" ;;
        *.tar.xz)  tar xJf "$1" ;;
        *.tar)     tar xf  "$1" ;;
        *.bz2)     bunzip2 "$1" ;;
        *.gz)      gunzip  "$1" ;;
        *.zip)     unzip   "$1" ;;
        *.7z)      7z x    "$1" ;;
        *.rar)     unrar x "$1" ;;
        *) echo "No sé cómo descomprimir '$1'" ;;
      esac
    else
      echo "'$1' no es un archivo válido"
    fi
  }
fi

# envsource: cargar .env de forma segura
envsource() {
  local file="${1:-.env}"
  [[ -f "$file" ]] || { echo "No existe $file"; return 1; }
  set -o allexport && source "$file" && set +o allexport
  echo "Variables de $file cargadas."
}

# bench: medir tiempo de ejecución de N iteraciones
bench() {
  local n="${1:-10}"
  shift
  for _ in $(seq 1 "$n"); do time "$@"; done 2>&1
}

# port: qué proceso usa un puerto
port() { lsof -i :"${1}" | grep LISTEN; }

# sizerank: archivos más pesados en el directorio actual
sizerank() { du -sh ./* 2>/dev/null | sort -rh | head "${1:-20}"; }

# watchfile: mostrar cambios en un archivo en tiempo real
watchfile() { tail -f "${1}" | bat --paging=never -l log 2>/dev/null || tail -f "${1}"; }

# ── Editor ────────────────────────────────────────────────────────────────────
if command -v nvim >/dev/null 2>&1; then
  export EDITOR='nvim'
  export VISUAL='nvim'
  alias vim='nvim'
  alias vi='nvim'
else
  export EDITOR='vim'
  export VISUAL='vim'
fi

# ── Lenguaje ──────────────────────────────────────────────────────────────────
export LANG='en_US.UTF-8'
export LC_ALL='en_US.UTF-8'

# ── NVM (Node Version Manager) ────────────────────────────────────────────────
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

# ── SDKMAN (Java/Kotlin/Groovy/Scala/…) ──────────────────────────────────────
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"

# ── Rust / Cargo ──────────────────────────────────────────────────────────────
[[ -f "$HOME/.cargo/env" ]] && source "$HOME/.cargo/env"

# ── Go ────────────────────────────────────────────────────────────────────────
[[ -d "/usr/local/go/bin" ]] && export PATH="$PATH:/usr/local/go/bin"
[[ -d "$HOME/go/bin" ]]       && export PATH="$PATH:$HOME/go/bin"

# ── Python: uv / pyenv ───────────────────────────────────────────────────────
[[ -d "$HOME/.local/bin" ]] && export PATH="$HOME/.local/bin:$PATH"
if command -v pyenv >/dev/null 2>&1; then
  export PYENV_ROOT="$HOME/.pyenv"
  export PATH="$PYENV_ROOT/bin:$PATH"
  eval "$(pyenv init -)"
fi

# ── PATH: herramientas adicionales ────────────────────────────────────────────
export PATH="$HOME/bin:$PATH"
export PATH="$PATH:$HOME/bin/openapitools"
export PATH="$PATH:$HOME/.lmstudio/bin"
export PATH="$PATH:/opt/mssql-tools18/bin"

# ── Powerlevel10k config ───────────────────────────────────────────────────────
[[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh
