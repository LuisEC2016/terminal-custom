#!/usr/bin/env bash
# install_tools.sh — herramientas CLI para programadores
# Se ejecuta desde setup.sh como paso 2 (antes del perfil ZSH)
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
BOLD='\033[1m'
RESET='\033[0m'

log()  { printf "${CYAN}[tools]${RESET} %s\n" "$*"; }
ok()   { printf "${GREEN}[  ok ]${RESET} %s\n" "$*"; }
warn() { printf "${YELLOW}[ warn]${RESET} %s\n" "$*"; }
skip() { printf "${YELLOW}[ skip]${RESET} %s\n" "$*"; }

has() { command -v "$1" >/dev/null 2>&1; }

# ── 1. Paquetes apt esenciales ────────────────────────────────────────────────
log "Actualizando índice de paquetes..."
sudo apt-get update -qq

APT_TOOLS=(
  # Navegación y búsqueda
  bat                  # cat con syntax highlighting
  fd-find              # find moderno (fd)
  ripgrep              # grep ultrarrápido (rg)
  tree                 # árbol de directorios
  ncdu                 # du interactivo con navegación

  # Procesamiento de texto
  jq                   # procesar JSON en terminal
  yq                   # procesar YAML/JSON/TOML
  sd                   # sed moderno con sintaxis clara
  miller               # CSV/JSON/TSV suizo

  # Monitoreo del sistema
  btop                 # monitor de recursos visual
  htop                 # monitor de procesos clásico
  duf                  # df visual mejorado
  lsof                 # archivos abiertos por proceso

  # Red y HTTP
  curl                 # HTTP/FTP cliente base
  wget                 # descarga de archivos
  httpie               # HTTP client human-friendly
  nmap                 # escaneo de puertos
  netcat-openbsd       # nc multiusos

  # Git y diff
  git                  # control de versiones
  git-delta            # diff con syntax highlighting
  meld                 # diff gráfico (opcional)

  # Multiplexador de terminal
  tmux                 # sesiones/paneles/ventanas
  zellij               # alternativa moderna a tmux (si existe en apt)

  # Desarrollo
  make                 # automatización de builds
  gcc                  # compilador C
  build-essential      # compiladores base
  pkg-config           # configuración de dependencias
  unzip zip            # compresión
  xclip                # portapapeles en terminal (X11/Wayland)
  wl-clipboard         # portapapeles Wayland (wl-copy, wl-paste)

  # Utilidades extra
  tldr                 # man pages simplificadas
  pv                   # barra de progreso en pipes
  entr                 # re-ejecutar comando al cambiar archivos
  watch                # ejecutar comando con intervalo
  parallel             # ejecutar comandos en paralelo
  shellcheck           # linter de scripts bash/sh
)

log "Instalando paquetes apt..."
sudo apt-get install -y --no-install-recommends "${APT_TOOLS[@]}" 2>&1 \
  | grep -E '(Instalando|Installing|Setting up|already|cannot|error)' || true
ok "Paquetes apt instalados."

# ── 2. Symlink fd-find → fd ──────────────────────────────────────────────────
if has fdfind && ! has fd; then
  sudo ln -sf "$(which fdfind)" /usr/local/bin/fd
  ok "Symlink fd → fdfind creado."
fi

# ── 3. Symlink bat → batcat ──────────────────────────────────────────────────
if has batcat && ! has bat; then
  sudo ln -sf "$(which batcat)" /usr/local/bin/bat
  ok "Symlink bat → batcat creado."
fi

# ── 4. eza (ls moderno con iconos y git) ─────────────────────────────────────
if ! has eza; then
  log "Instalando eza..."
  EZA_VERSION="$(curl -s https://api.github.com/repos/eza-community/eza/releases/latest \
    | grep '"tag_name"' | sed 's/.*"v\([^"]*\)".*/\1/')"
  EZA_DEB="/tmp/eza_amd64.deb"
  curl -fsSLo "$EZA_DEB" \
    "https://github.com/eza-community/eza/releases/latest/download/eza_x86_64-unknown-linux-gnu.tar.gz" \
    2>/dev/null || true

  # Alternativa: instalar via cargo o apt si existe
  if sudo apt-get install -y eza 2>/dev/null; then
    ok "eza instalado via apt."
  else
    warn "eza no disponible en apt; instalando binario..."
    EZA_TAR="/tmp/eza.tar.gz"
    curl -fsSLo "$EZA_TAR" \
      "https://github.com/eza-community/eza/releases/latest/download/eza_x86_64-unknown-linux-gnu.tar.gz"
    tar -xzf "$EZA_TAR" -C /tmp/
    sudo mv /tmp/eza /usr/local/bin/eza
    sudo chmod +x /usr/local/bin/eza
    rm -f "$EZA_TAR"
    ok "eza instalado en /usr/local/bin/eza."
  fi
else
  skip "eza ya instalado: $(eza --version | head -1)"
fi

# ── 5. lazygit — UI TUI para git ─────────────────────────────────────────────
if ! has lazygit; then
  log "Instalando lazygit..."
  LG_VERSION="$(curl -s https://api.github.com/repos/jesseduffield/lazygit/releases/latest \
    | grep '"tag_name"' | sed 's/.*"v\([^"]*\)".*/\1/')"
  LG_TAR="/tmp/lazygit.tar.gz"
  curl -fsSLo "$LG_TAR" \
    "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LG_VERSION}_Linux_x86_64.tar.gz"
  tar -xzf "$LG_TAR" -C /tmp/ lazygit
  sudo mv /tmp/lazygit /usr/local/bin/lazygit
  sudo chmod +x /usr/local/bin/lazygit
  rm -f "$LG_TAR"
  ok "lazygit ${LG_VERSION} instalado."
else
  skip "lazygit ya instalado: $(lazygit --version | head -1)"
fi

# ── 6. glow — render de Markdown en terminal ─────────────────────────────────
if ! has glow; then
  log "Instalando glow..."
  if ! sudo apt-get install -y glow 2>/dev/null; then
    GLOW_VERSION="$(curl -s https://api.github.com/repos/charmbracelet/glow/releases/latest \
      | grep '"tag_name"' | sed 's/.*"v\([^"]*\)".*/\1/')"
    GLOW_DEB="/tmp/glow.deb"
    curl -fsSLo "$GLOW_DEB" \
      "https://github.com/charmbracelet/glow/releases/latest/download/glow_${GLOW_VERSION}_amd64.deb"
    sudo dpkg -i "$GLOW_DEB" && rm -f "$GLOW_DEB"
  fi
  ok "glow instalado."
else
  skip "glow ya instalado."
fi

# ── 7. zoxide — cd inteligente con ranking ────────────────────────────────────
if ! has zoxide; then
  log "Instalando zoxide..."
  if ! sudo apt-get install -y zoxide 2>/dev/null; then
    curl -sSfL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | sh
  fi
  ok "zoxide instalado."
else
  skip "zoxide ya instalado: $(zoxide --version)"
fi

# ── 8. starship — prompt alternativo (referencia, no activado por defecto) ────
# No se activa aquí; solo se instala para que esté disponible.
if ! has starship; then
  log "Instalando starship (desactivado por defecto, usa p10k)..."
  curl -sSf https://starship.rs/install.sh | sh -s -- --yes --bin-dir /usr/local/bin 2>/dev/null || true
  ok "starship instalado (inactivo; se activa con STARSHIP=1 en .zshrc)."
else
  skip "starship ya instalado."
fi

# ── 9. navi — cheatsheets interactivos ───────────────────────────────────────
if ! has navi; then
  log "Instalando navi..."
  if ! sudo apt-get install -y navi 2>/dev/null; then
    curl -sSf https://raw.githubusercontent.com/denisidoro/navi/master/scripts/install \
      | bash 2>/dev/null || warn "navi no pudo instalarse automáticamente."
  fi
  has navi && ok "navi instalado." || warn "navi omitido (instalar manualmente si se necesita)."
else
  skip "navi ya instalado."
fi

# ── 10. neovim config básica (si neovim existe y no hay init.lua) ─────────────
if has nvim && [[ ! -f "$HOME/.config/nvim/init.lua" ]]; then
  log "Copiando configuración neovim..."
  mkdir -p "$HOME/.config/nvim"
  cp "$SCRIPT_DIR/configs/init.lua" "$HOME/.config/nvim/init.lua"
  ok "Configuración neovim copiada en ~/.config/nvim/init.lua."
elif has nvim; then
  skip "~/.config/nvim/init.lua ya existe — no se sobrescribe."
fi

# ── 11. tmux config ───────────────────────────────────────────────────────────
if has tmux; then
  if [[ ! -f "$HOME/.tmux.conf" ]]; then
    log "Copiando configuración tmux..."
    cp "$SCRIPT_DIR/configs/.tmux.conf" "$HOME/.tmux.conf"
    ok "Configuración tmux copiada en ~/.tmux.conf."
  else
    skip "~/.tmux.conf ya existe — no se sobrescribe."
  fi
fi

# ── 12. delta config global en git ──────────────────────────────────────────
if has delta; then
  log "Configurando delta como pager global de git..."
  git config --global core.pager delta
  git config --global interactive.diffFilter "delta --color-only"
  git config --global delta.navigate true
  git config --global delta.light false
  git config --global delta.side-by-side true
  git config --global delta.line-numbers true
  git config --global merge.conflictstyle diff3
  git config --global diff.colorMoved default
  ok "delta configurado como pager de git."
fi

ok "Todas las herramientas CLI instaladas correctamente."
