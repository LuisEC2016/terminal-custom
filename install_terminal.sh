#!/usr/bin/env bash
set -euo pipefail

sudo apt install -y git-core zsh curl unzip

if [[ -d "$HOME/.oh-my-zsh" ]]; then
  git -C "$HOME/.oh-my-zsh" fetch --all --quiet
  git -C "$HOME/.oh-my-zsh" reset --hard origin/master --quiet
else
  RUNZSH=no CHSH=no OVERWRITE_CONFIRMATION=no \
    sh "$(dirname "$0")/install.sh" --unattended
fi
