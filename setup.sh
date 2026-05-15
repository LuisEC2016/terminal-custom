#!/usr/bin/env bash
# setup.sh — instalador principal del perfil de terminal Pixegami
# Ubuntu 26.04 LTS · solo Wayland · GNOME 50 · Ptyxis
set -euo pipefail

# ── Colores ──────────────────────────────────────────────────────────────────
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
BOLD='\033[1m'
RESET='\033[0m'

log()  { printf "${CYAN}[setup]${RESET} %s\n" "$*"; }
ok()   { printf "${GREEN}[  ok ]${RESET} %s\n" "$*"; }
warn() { printf "${YELLOW}[ warn]${RESET} %s\n" "$*"; }
fail() { printf "${RED}[error]${RESET} %s\n" "$*" >&2; exit 1; }

# ── Verificaciones previas ────────────────────────────────────────────────────
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

[[ $EUID -eq 0 ]] && fail "No ejecutes este script como root. Usa tu usuario normal."

command -v sudo >/dev/null 2>&1 || fail "'sudo' no está disponible."
command -v git  >/dev/null 2>&1 || fail "'git' no está instalado."

# Confirmar que estamos en Wayland
if [[ "${XDG_SESSION_TYPE:-}" != "wayland" ]]; then
    warn "XDG_SESSION_TYPE='${XDG_SESSION_TYPE:-no definido}'. Este perfil está optimizado para Wayland."
    warn "Continúa solo si sabes lo que haces."
fi

# ── Banner ────────────────────────────────────────────────────────────────────
printf "\n${BOLD}${CYAN}"
printf "╔══════════════════════════════════════════╗\n"
printf "║      Pixegami Terminal Setup             ║\n"
printf "║  Ubuntu 26.04 · GNOME 50 · Ptyxis        ║\n"
printf "╚══════════════════════════════════════════╝\n"
printf "${RESET}\n"

# ── Corregir ownership de instalaciones anteriores ejecutadas como root ────────
# Lista de archivos/directorios que versiones anteriores pudieron crear como root.
fix_ownership() {
    local target="$1"
    if [[ -e "$target" && "$(stat -c '%U' "$target")" != "$USER" ]]; then
        log "  Corrigiendo ownership de $target (era root)..."
        sudo chown -R "$USER:$USER" "$target"
    fi
}

fix_ownership "$HOME/.vimrc"
fix_ownership "$HOME/.zshrc"
fix_ownership "$HOME/.p10k.zsh"
fix_ownership "$HOME/.tmux.conf"
fix_ownership "$HOME/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting"
fix_ownership "$HOME/.oh-my-zsh/custom/plugins/zsh-autosuggestions"
fix_ownership "$HOME/.oh-my-zsh/custom/themes/powerlevel10k"
fix_ownership "$HOME/.fonts/RobotoMono"
fix_ownership "$HOME/.config/nvim"

# ── Limpieza de instalaciones anteriores ─────────────────────────────────────
log "Limpiando instalaciones anteriores..."

PTYXIS_UUID="fb358fc9-49ea-4252-ad34-1d25c649e633"
GT_UUID="b1dcc9dd-5262-4d8d-a863-c897e6d979b9"

# Powerline: paquetes pip anteriores
if pip3 show powerline-status >/dev/null 2>&1; then
    log "  Desinstalando powerline-status (pip)..."
    pip3 uninstall -y powerline-status 2>/dev/null || true
fi

# Vim: backup de .vimrc
if [[ -f "$HOME/.vimrc" ]]; then
    log "  Backup de ~/.vimrc → ~/.vimrc.bak"
    cp "$HOME/.vimrc" "$HOME/.vimrc.bak"
fi

# ZSH: backup de .zshrc
if [[ -f "$HOME/.zshrc" ]]; then
    log "  Backup de ~/.zshrc → ~/.zshrc.bak"
    cp "$HOME/.zshrc" "$HOME/.zshrc.bak"
fi

# Fuentes: limpiar RobotoMono Powerline anterior (la NF se sobreescribe en install_powerline)
if [[ -d "$HOME/.fonts/RobotoMono" ]]; then
    log "  Eliminando RobotoMono Powerline anterior..."
    rm -rf "$HOME/.fonts/RobotoMono"
fi

# Ptyxis: limpiar perfiles ajenos y el perfil Pixegami para reinstalarlo limpio
while IFS= read -r uuid; do
    uuid="${uuid%/}"
    if [[ -n "$uuid" ]]; then
        dconf reset -f "/org/gnome/Ptyxis/Profiles/$uuid/" 2>/dev/null || true
    fi
done < <(dconf list /org/gnome/Ptyxis/Profiles/ 2>/dev/null || true)

# GNOME Terminal: limpiar solo el perfil Pixegami para reinstalarlo limpio
# (no se borra toda la config legacy para no perder el UUID en la lista)
dconf reset -f "/org/gnome/terminal/legacy/profiles:/:${GT_UUID}/" 2>/dev/null || true

ok "Limpieza completada."

# ── Paso 1: Powerline + fuentes ───────────────────────────────────────────────
printf "\n${BOLD}[1/4] Powerline y fuentes${RESET}\n"
log "Ejecutando install_powerline.sh..."
bash "$SCRIPT_DIR/install_powerline.sh"
ok "Powerline y fuentes instalados."

# ── Paso 2: Herramientas CLI para programadores ───────────────────────────────
printf "\n${BOLD}[2/4] Herramientas CLI para programadores${RESET}\n"
log "Ejecutando install_tools.sh..."
bash "$SCRIPT_DIR/install_tools.sh"
ok "Herramientas CLI instaladas."

# ── Paso 3: ZSH + Oh My Zsh ──────────────────────────────────────────────────
printf "\n${BOLD}[3/4] ZSH y Oh My Zsh${RESET}\n"
log "Ejecutando install_terminal.sh..."
bash "$SCRIPT_DIR/install_terminal.sh"
ok "ZSH y Oh My Zsh instalados."

# ── Paso 4: Plugins, tema y perfil Ptyxis ────────────────────────────────────
printf "\n${BOLD}[4/4] Plugins, tema ZSH y perfil Ptyxis${RESET}\n"
log "Ejecutando install_profile.sh..."
bash "$SCRIPT_DIR/install_profile.sh"
ok "Perfil Ptyxis, tema y plugins instalados."

# ── Resumen ───────────────────────────────────────────────────────────────────
printf "\n${BOLD}${GREEN}"
printf "╔══════════════════════════════════════════╗\n"
printf "║   Instalación completada correctamente   ║\n"
printf "╚══════════════════════════════════════════╝\n"
printf "${RESET}\n"

printf "  Shell activo:  ${BOLD}$(which zsh)${RESET}\n"
printf "  Tema ZSH:      ${BOLD}powerlevel10k (paleta Pixegami)${RESET}\n"
printf "  Paleta Ptyxis: ${BOLD}pixegami${RESET}\n"
printf "  Fuente:        ${BOLD}Roboto Mono for Powerline 14${RESET}\n"
printf "  Plugins ZSH:   ${BOLD}git z fzf extract colored-man-pages history${RESET}\n"
printf "                 ${BOLD}history-substring-search docker tmux kubectl aws${RESET}\n"
printf "                 ${BOLD}zsh-syntax-highlighting zsh-autosuggestions${RESET}\n"
printf "\n  Herramientas CLI instaladas:\n"
printf "    ${BOLD}bat${RESET}         cat con syntax highlighting\n"
printf "    ${BOLD}eza${RESET}         ls moderno con iconos y git\n"
printf "    ${BOLD}fd${RESET}          find moderno y rápido\n"
printf "    ${BOLD}rg${RESET}          ripgrep — grep ultrarrápido\n"
printf "    ${BOLD}delta${RESET}       diff con syntax highlighting\n"
printf "    ${BOLD}lazygit${RESET}     UI TUI para git  (alias: lg)\n"
printf "    ${BOLD}zoxide${RESET}      cd inteligente con ranking  (alias: z, j)\n"
printf "    ${BOLD}btop${RESET}        monitor de recursos visual\n"
printf "    ${BOLD}tmux${RESET}        multiplexador de terminal\n"
printf "    ${BOLD}glow${RESET}        render de Markdown  (alias: md, readme)\n"
printf "    ${BOLD}ncdu${RESET}        du interactivo navegable\n"
printf "    ${BOLD}jq / yq${RESET}     procesador JSON/YAML en terminal\n"
printf "    ${BOLD}entr${RESET}        re-ejecutar al cambiar archivos\n"
printf "    ${BOLD}tldr${RESET}        man pages simplificadas\n"
printf "\n  Atajos clave:\n"
printf "    ${BOLD}Ctrl+R${RESET}       búsqueda fuzzy en historial\n"
printf "    ${BOLD}Ctrl+T${RESET}       búsqueda fuzzy de archivos (preview con bat)\n"
printf "    ${BOLD}Alt+C${RESET}        saltar a directorio con fzf (preview con eza)\n"
printf "    ${BOLD}↑ / ↓${RESET}        buscar en historial por substring\n"
printf "    ${BOLD}Ctrl+Space${RESET}   aceptar sugerencia completa\n"
printf "    ${BOLD}x <archivo>${RESET}  descomprimir cualquier formato\n"
printf "    ${BOLD}fcd${RESET}          navegar directorios con fzf\n"
printf "    ${BOLD}fopen${RESET}        abrir archivo con fzf en \$EDITOR\n"
printf "    ${BOLD}fkill${RESET}        matar proceso con fzf\n"
printf "    ${BOLD}lg${RESET}           lazygit — UI TUI para git\n"
printf "    ${BOLD}ji${RESET}           selector de directorios con zoxide+fzf\n"

# Advertir si el shell activo no es zsh todavía (requiere logout/login)
if [[ "$(basename -- "$SHELL")" != "zsh" ]]; then
    printf "\n${YELLOW}AVISO:${RESET} El shell por defecto cambió a zsh.\n"
    printf "       Cierra sesión y vuelve a entrar para que tome efecto.\n"
fi

# Advertir si Ptyxis no estaba corriendo al momento de la instalación
if ! pgrep -x ptyxis >/dev/null 2>&1; then
    printf "\n${YELLOW}AVISO:${RESET} Ptyxis no estaba corriendo durante la instalación.\n"
    printf "       La paleta ya fue copiada al directorio de paletas.\n"
    printf "       Ábrela en Ptyxis: Preferencias → Paleta → Pixegami\n"
fi

# ── Recargar configuración en la sesión ZSH actual ───────────────────────────
# setup.sh corre en bash, por lo que no puede hacer source directamente en el
# ZSH padre. Instruimos al usuario con el comando exacto, y si ZSH ya es el
# shell activo, exec zsh recarga todo sin abrir una ventana nueva.
printf "\n${BOLD}Recargando configuración...${RESET}\n"
if [[ -n "${ZSH_VERSION:-}" ]]; then
    # Este caso ocurre si el usuario lanzó setup.sh desde zsh con bash explícito
    exec zsh
else
    printf "  Ejecuta este comando para aplicar los cambios en esta terminal:\n"
    printf "\n    ${BOLD}${CYAN}exec zsh${RESET}\n\n"
fi
