#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# ── Powerline para Vim ────────────────────────────────────────────────────────
sudo apt install -y python3-pip fonts-powerline
pip3 install --user --quiet --upgrade --break-system-packages powerline-status
cp "$SCRIPT_DIR/configs/.vimrc" ~/.vimrc

# ── RobotoMono Powerline (Vim) ────────────────────────────────────────────────
rm -rf ~/.fonts/RobotoMono
mkdir -p ~/.fonts/RobotoMono
cp -a "$SCRIPT_DIR/fonts/RobotoMono/." ~/.fonts/RobotoMono/

# ── RobotoMono Nerd Font Mono (terminal + p10k) ───────────────────────────────
NF_VERSION="v3.4.0"
NF_ZIP="/tmp/RobotoMonoNF.zip"
NF_EXTRACT="/tmp/RobotoMonoNF_extracted"
NF_DIR="$HOME/.fonts/RobotoMonoNF"

rm -rf "$NF_DIR" "$NF_EXTRACT"
mkdir -p "$NF_DIR"

echo "Descargando RobotoMono Nerd Font ${NF_VERSION}..."
curl -fsSLo "$NF_ZIP" \
  "https://github.com/ryanoasis/nerd-fonts/releases/download/${NF_VERSION}/RobotoMono.zip"
unzip -q "$NF_ZIP" -d "$NF_EXTRACT"
cp "$NF_EXTRACT"/RobotoMonoNerdFontMono-*.ttf "$NF_DIR/"
cp "$NF_EXTRACT"/RobotoMonoNerdFont-*.ttf     "$NF_DIR/"
rm -rf "$NF_EXTRACT" "$NF_ZIP"

# ── Fontconfig ────────────────────────────────────────────────────────────────
mkdir -p ~/.config/fontconfig
cp "$SCRIPT_DIR/configs/fonts.conf" ~/.config/fontconfig/fonts.conf
sudo cp "$SCRIPT_DIR/configs/fonts.conf" /etc/fonts/local.conf

fc-cache -f ~/.fonts/ ~/.config/fontconfig/
sudo fc-cache -f
