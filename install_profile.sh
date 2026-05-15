#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# UUID canónico del perfil Ptyxis Pixegami
PTYXIS_UUID="fb358fc9-49ea-4252-ad34-1d25c649e633"

# UUID canónico del perfil GNOME Terminal Pixegami
GT_UUID="b1dcc9dd-5262-4d8d-a863-c897e6d979b9"
GT_DCONF="/org/gnome/terminal/legacy/profiles:/:${GT_UUID}"

# ── Plugins Oh My Zsh ─────────────────────────────────────────────────────────
_plugin() {
  local repo=$1
  local dir="$HOME/.oh-my-zsh/custom/plugins/$(basename "$repo")"
  if [[ -d "$dir" ]]; then
    git -C "$dir" pull --ff-only --quiet
  else
    git clone --depth=1 "https://github.com/$repo" "$dir"
  fi
}

_plugin zsh-users/zsh-syntax-highlighting
_plugin zsh-users/zsh-autosuggestions

# ── Powerlevel10k ─────────────────────────────────────────────────────────────
P10K_DIR="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k"
if [[ -d "$P10K_DIR" ]]; then
  git -C "$P10K_DIR" pull --ff-only --quiet
else
  git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$P10K_DIR"
fi

# ── fzf ───────────────────────────────────────────────────────────────────────
if [[ -d "$HOME/.fzf" ]]; then
  git -C "$HOME/.fzf" pull --ff-only --quiet
else
  git clone --depth=1 https://github.com/junegunn/fzf.git "$HOME/.fzf"
fi
"$HOME/.fzf/install" --all --no-update-rc --no-bash --no-fish

# ── Configs ZSH ───────────────────────────────────────────────────────────────
cp "$SCRIPT_DIR/configs/.zshrc"    ~/.zshrc
cp "$SCRIPT_DIR/configs/.p10k.zsh" ~/.p10k.zsh

# Invalidar cache de p10k instant prompt para que se regenere con la config nueva
rm -f "${XDG_CACHE_HOME:-$HOME/.cache}"/p10k-instant-prompt-*.zsh{,.zwc}

# ── Config tmux ───────────────────────────────────────────────────────────────
if [[ ! -f "$HOME/.tmux.conf" ]]; then
  cp "$SCRIPT_DIR/configs/.tmux.conf" ~/.tmux.conf
fi

# ── Config neovim ─────────────────────────────────────────────────────────────
if command -v nvim >/dev/null 2>&1 && [[ ! -f "$HOME/.config/nvim/init.lua" ]]; then
  mkdir -p "$HOME/.config/nvim"
  cp "$SCRIPT_DIR/configs/init.lua" "$HOME/.config/nvim/init.lua"
fi

# ── Shell por defecto ─────────────────────────────────────────────────────────
if [[ "$(basename -- "$SHELL")" != "zsh" ]]; then
  chsh -s "$(command -v zsh)"
fi

# ════════════════════════════════════════════════════════════════════════════════
# GNOME Terminal
# ════════════════════════════════════════════════════════════════════════════════

# Registrar el UUID en la lista y como default (idempotente)
CURRENT_LIST="$(gsettings get org.gnome.Terminal.ProfilesList list 2>/dev/null || echo "[]")"
if [[ "$CURRENT_LIST" != *"$GT_UUID"* ]]; then
  gsettings set org.gnome.Terminal.ProfilesList list   "['$GT_UUID']"
fi
gsettings set org.gnome.Terminal.ProfilesList default "$GT_UUID"

# ── Apariencia ────────────────────────────────────────────────────────────────
dconf write "${GT_DCONF}/visible-name"              "'Pixegami'"
dconf write "${GT_DCONF}/use-system-font"           "false"
dconf write "${GT_DCONF}/font"                      "'RobotoMono Nerd Font Mono 14'"
dconf write "${GT_DCONF}/use-theme-colors"          "false"
dconf write "${GT_DCONF}/background-color"          "'#0d1b26'"
dconf write "${GT_DCONF}/foreground-color"          "'#a8e6c0'"
dconf write "${GT_DCONF}/bold-color"                "'#ffffff'"
dconf write "${GT_DCONF}/bold-color-same-as-fg"     "false"
dconf write "${GT_DCONF}/bold-is-bright"            "true"
dconf write "${GT_DCONF}/palette"                   "['#1a2e3d','#e05555','#3dba6f','#e0a020','#2e86d4','#7c4daa','#1aa89a','#c5cdd6','#2d4455','#ff6b6b','#5edd8a','#ffc947','#5bb8ff','#a67dd4','#26c9b8','#ffffff']"

# ── Cursor ────────────────────────────────────────────────────────────────────
dconf write "${GT_DCONF}/cursor-shape"              "'block'"
dconf write "${GT_DCONF}/cursor-blink-mode"         "'on'"
dconf write "${GT_DCONF}/cursor-colors-set"         "true"
dconf write "${GT_DCONF}/cursor-background-color"   "'#5bb8ff'"
dconf write "${GT_DCONF}/cursor-foreground-color"   "'#0d1b26'"

# ── Selección ─────────────────────────────────────────────────────────────────
dconf write "${GT_DCONF}/highlight-colors-set"       "true"
dconf write "${GT_DCONF}/highlight-background-color" "'#2e86d4'"
dconf write "${GT_DCONF}/highlight-foreground-color" "'#ffffff'"

# ── Scroll y tamaño ───────────────────────────────────────────────────────────
dconf write "${GT_DCONF}/scrollback-unlimited"      "true"
dconf write "${GT_DCONF}/scrollbar-policy"          "'never'"
dconf write "${GT_DCONF}/scroll-on-output"          "true"
dconf write "${GT_DCONF}/scroll-on-keystroke"       "true"
dconf write "${GT_DCONF}/scroll-on-insert"          "true"
dconf write "${GT_DCONF}/rewrap-on-resize"          "true"
dconf write "${GT_DCONF}/default-size-columns"      "120"
dconf write "${GT_DCONF}/default-size-rows"         "35"

# ── Celda ─────────────────────────────────────────────────────────────────────
dconf write "${GT_DCONF}/cell-height-scale"         "1.1"
dconf write "${GT_DCONF}/cell-width-scale"          "1.0"
# narrow: VTE cuenta glifos NF Mono como 1 celda; 'wide' los dobla y rompe el prompt
dconf write "${GT_DCONF}/cjk-utf8-ambiguous-width"  "'narrow'"

# ── Renderizado de texto ──────────────────────────────────────────────────────
# bidi y shaping OFF: evita que VTE reordene o sustituya separadores Powerline
dconf write "${GT_DCONF}/enable-bidi"               "false"
dconf write "${GT_DCONF}/enable-shaping"            "false"
dconf write "${GT_DCONF}/text-blink-mode"           "'never'"

# ── Misc ──────────────────────────────────────────────────────────────────────
dconf write "${GT_DCONF}/audible-bell"              "false"
dconf write "${GT_DCONF}/backspace-binding"         "'ascii-delete'"
dconf write "${GT_DCONF}/delete-binding"            "'delete-sequence'"
dconf write "${GT_DCONF}/use-transparent-background" "false"
dconf write "${GT_DCONF}/use-theme-transparency"    "false"

# ── Configuración global de GNOME Terminal ────────────────────────────────────
GT_GLOBAL="org.gnome.Terminal.Legacy.Settings"
gsettings set $GT_GLOBAL default-show-menubar      false
gsettings set $GT_GLOBAL theme-variant             'dark'
gsettings set $GT_GLOBAL confirm-close             false
gsettings set $GT_GLOBAL new-terminal-mode         'tab'
gsettings set $GT_GLOBAL tab-position              'top'
gsettings set $GT_GLOBAL shell-integration-enabled true

# ════════════════════════════════════════════════════════════════════════════════
# Ptyxis
# ════════════════════════════════════════════════════════════════════════════════

# ── Paleta ────────────────────────────────────────────────────────────────────
PALETTE_DIR="$HOME/.local/share/org.gnome.Ptyxis/palettes"
mkdir -p "$PALETTE_DIR"
cp "$SCRIPT_DIR/configs/pixegami.palette" "$PALETTE_DIR/pixegami.palette"

# ── Perfiles: dejar solo Pixegami ─────────────────────────────────────────────
while IFS= read -r uuid; do
  uuid="${uuid%/}"
  if [[ -n "$uuid" && "$uuid" != "$PTYXIS_UUID" ]]; then
    dconf reset -f "/org/gnome/Ptyxis/Profiles/$uuid/" 2>/dev/null || true
  fi
done < <(dconf list /org/gnome/Ptyxis/Profiles/ 2>/dev/null || true)

gsettings set org.gnome.Ptyxis profile-uuids      "['$PTYXIS_UUID']"
gsettings set org.gnome.Ptyxis default-profile-uuid "$PTYXIS_UUID"

# ── Configuración global Ptyxis ───────────────────────────────────────────────
gsettings set org.gnome.Ptyxis interface-style    'dark'
gsettings set org.gnome.Ptyxis use-system-font    false
gsettings set org.gnome.Ptyxis font-name          'RobotoMono Nerd Font Mono 14'
gsettings set org.gnome.Ptyxis scrollbar-policy   'never'
gsettings set org.gnome.Ptyxis visual-bell        false
gsettings set org.gnome.Ptyxis audible-bell       false
# Desactivar parpadeo de texto — interfiere con el renderer de glifos PUA en VTE 0.84
gsettings set org.gnome.Ptyxis text-blink-mode    'never'

# ── Perfil Pixegami ───────────────────────────────────────────────────────────
PP="/org/gnome/Ptyxis/Profiles/$PTYXIS_UUID"
dconf write "$PP/label"                 "'Pixegami'"
dconf write "$PP/palette"               "'pixegami'"
dconf write "$PP/bold-is-bright"        "true"
dconf write "$PP/limit-scrollback"      "false"
# cell-height-scale=1.0 — valores >1.0 deforman los separadores Powerline en VTE 0.84
dconf write "$PP/cell-height-scale"     "1.0"
dconf write "$PP/cell-width-scale"      "1.0"
dconf write "$PP/cursor-shape"          "'block'"
dconf write "$PP/cursor-blink-mode"     "'on'"
dconf write "$PP/opacity"               "1.0"
# Tratar glifos PUA (iconos Nerd Font) como ancho 1 — evita desalineación de separadores
gsettings set org.gnome.Ptyxis.Profile:/org/gnome/Ptyxis/Profiles/$PTYXIS_UUID/ cjk-ambiguous-width 'narrow'
