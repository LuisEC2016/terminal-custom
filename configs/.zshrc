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
)

source "$ZSH/oh-my-zsh.sh"

# ── Historial ─────────────────────────────────────────────────────────────────
HISTSIZE=50000
SAVEHIST=50000
HISTFILE="$HOME/.zsh_history"
setopt HIST_IGNORE_ALL_DUPS   # no guardar duplicados
setopt HIST_IGNORE_SPACE      # no guardar comandos que empiezan con espacio
setopt HIST_REDUCE_BLANKS     # limpiar espacios extra
setopt SHARE_HISTORY          # compartir historial entre sesiones en tiempo real
setopt EXTENDED_HISTORY       # guardar timestamp en cada entrada

# ── Opciones de shell ─────────────────────────────────────────────────────────
setopt AUTO_CD                # escribir un directorio lo entra sin "cd"
setopt CORRECT                # sugerir corrección de comandos mal escritos
setopt NO_BEEP                # sin pitidos

# ── Autosuggestions: aceptar sugerencia con → ────────────────────────────────
bindkey '^ ' autosuggest-accept       # Ctrl+Space acepta toda la sugerencia
bindkey '^[[C' autosuggest-accept     # → acepta toda la sugerencia

# ── History substring search: ↑↓ con substring ───────────────────────────────
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down

# ── FZF: opciones globales ────────────────────────────────────────────────────
export FZF_DEFAULT_OPTS="
  --height=40%
  --layout=reverse
  --border=rounded
  --info=inline
  --color=bg+:#1e3a4a,bg:#0c1c25,spinner:#86ffaf,hl:#5bd7ff
  --color=fg:#bdc3c7,header:#5bd7ff,info:#ffd057,pointer:#86ffaf
  --color=marker:#86ffaf,fg+:#ffffff,prompt:#86ffaf,hl+:#5bd7ff
"
export FZF_CTRL_T_OPTS="--preview 'cat -n {} 2>/dev/null | head -100'"
export FZF_ALT_C_OPTS="--preview 'ls -la {} 2>/dev/null | head -30'"

# ── Colores: ls, grep ─────────────────────────────────────────────────────────
export LS_COLORS='di=1;34:ln=1;36:so=1;35:pi=33:ex=1;32:bd=1;33:cd=1;33:su=1;31:sg=1;31:tw=1;34:ow=1;34'
alias ls='ls --color=auto --group-directories-first'
alias ll='ls -lah --color=auto --group-directories-first'
alias la='ls -A --color=auto --group-directories-first'
alias lt='ls -lath --color=auto'                          # ordenado por tiempo
alias grep='grep --color=auto'
alias diff='diff --color=auto'

# ── Aliases de productividad ──────────────────────────────────────────────────
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias mkdir='mkdir -pv'
alias cp='cp -iv'
alias mv='mv -iv'
alias df='df -h'
alias du='du -sh'
alias free='free -h'
alias ports='ss -tulnp'
alias myip='curl -s ifconfig.me'

# Git extras (complementan los de OMZ)
alias glog='git log --oneline --graph --decorate --all'
alias gundo='git reset --soft HEAD~1'
alias gstash='git stash push -m'

# ── Editor ────────────────────────────────────────────────────────────────────
export EDITOR='vim'
export VISUAL='vim'

# ── Lenguaje ──────────────────────────────────────────────────────────────────
export LANG='en_US.UTF-8'
export LC_ALL='en_US.UTF-8'

# ── NVM (Node Version Manager) ────────────────────────────────────────────────
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

# ── SDKMAN (Java/Kotlin/Groovy/Scala/…) ──────────────────────────────────────
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"

# ── PATH: herramientas adicionales ────────────────────────────────────────────
export PATH="$HOME/bin:$PATH"
export PATH="$PATH:$HOME/bin/openapitools"
export PATH="$PATH:$HOME/.lmstudio/bin"
export PATH="$PATH:/opt/mssql-tools18/bin"

# ── Powerlevel10k config ───────────────────────────────────────────────────────
[[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh
