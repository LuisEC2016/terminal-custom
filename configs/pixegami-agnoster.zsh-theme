# vim:ft=zsh ts=2 sw=2 sts=2
# Pixegami ZSH Theme
# Colores 0-15 mapeados desde pixegami.palette:
#  0=#1a2e3d  1=#e05555  2=#3dba6f  3=#e0a020  4=#2e86d4  5=#7c4daa
#  6=#1aa89a  7=#c5cdd6  8=#2d4455  9=#ff6b6b 10=#5edd8a 11=#ffc947
# 12=#5bb8ff 13=#a67dd4 14=#26c9b8 15=#ffffff

CURRENT_BG='NONE'
SEP=''   # U+E0B0 powerline right arrow (requiere RobotoMono Powerline)
BRANCH=''  # U+E0A0 powerline branch symbol

# ── Segment builder ───────────────────────────────────────────────────────────
prompt_segment() {
  local bg fg
  [[ -n $1 ]] && bg="%K{$1}" || bg="%k"
  [[ -n $2 ]] && fg="%F{$2}" || fg="%f"
  if [[ $CURRENT_BG != 'NONE' && $1 != $CURRENT_BG ]]; then
    print -Pn " %{$bg%F{$CURRENT_BG}%}$SEP%{$fg%} "
  else
    print -Pn "%{$bg%}%{$fg%} "
  fi
  CURRENT_BG=$1
  [[ -n $3 ]] && print -Pn $3
}

prompt_end() {
  if [[ -n $CURRENT_BG ]]; then
    print -Pn " %{%k%F{$CURRENT_BG}%}$SEP"
  else
    print -Pn "%{%k%}"
  fi
  print -Pn "%{%f%}"
  CURRENT_BG=''
}

# ── vcs_info ──────────────────────────────────────────────────────────────────
autoload -Uz vcs_info add-zsh-hook
zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:*' check-for-changes true
zstyle ':vcs_info:*' stagedstr ' ✚'
zstyle ':vcs_info:*' unstagedstr ' !'
zstyle ':vcs_info:*' formats '%u%c'
zstyle ':vcs_info:*' actionformats '%u%c'

# ── Directorio (línea superior) ──────────────────────────────────────────────
prompt_head() {
  print -Pn "\r%E"
  if [[ $PWD == $HOME ]]; then
    print -Pn "\r  %F{12}%B~%b%f"
  else
    print -Pn "\r  %F{12}%B~%b%F{7}${PWD#$HOME}%f"
  fi
  print -Pn "\n"
}

# ── Usuario ───────────────────────────────────────────────────────────────────
prompt_context() {
  if [[ -n $SSH_CLIENT ]] || [[ -n $SSH_TTY ]]; then
    prompt_segment 8 14 "%(!.%F{11}⚡.)%B%n%b%F{7}@%m"
  else
    prompt_segment 8 14 "%(!.%F{11}⚡.)%B%n%b"
  fi
}

# ── Git ──────────────────────────────────────────────────────────────────────
prompt_git() {
  (( $+commands[git] )) || return
  git rev-parse --is-inside-work-tree >/dev/null 2>&1 || return
  vcs_info
  local dirty ref mode repo_path
  dirty=$(parse_git_dirty)
  ref=$(git symbolic-ref HEAD 2>/dev/null) \
    || ref="⦿ $(git rev-parse --short HEAD 2>/dev/null)"
  ref="${ref/refs\/heads\//}"
  repo_path=$(git rev-parse --git-dir 2>/dev/null)
  if   [[ -e "${repo_path}/BISECT_LOG"   ]]; then mode=" ➦B"
  elif [[ -e "${repo_path}/MERGE_HEAD"   ]]; then mode=" ⚡M"
  elif [[ -e "${repo_path}/rebase"        \
       || -e "${repo_path}/rebase-apply"  \
       || -e "${repo_path}/rebase-merge"  ]]; then mode=" ↷R"
  fi
  if [[ -n $dirty ]]; then
    prompt_segment 3 0 "$BRANCH %B${ref}%b${vcs_info_msg_0_}${mode}"
  else
    prompt_segment 6 0 "$BRANCH %B${ref}%b${vcs_info_msg_0_}${mode}"
  fi
}

# ── Virtualenv / Conda ───────────────────────────────────────────────────────
prompt_virtualenv() {
  local env_name=""
  if [[ -n ${CONDA_PROMPT_MODIFIER:-} ]]; then
    env_name="${CONDA_PROMPT_MODIFIER:1:-2}"
  elif [[ -n ${VIRTUAL_ENV:-} ]]; then
    env_name="$(basename $VIRTUAL_ENV)"
  fi
  [[ -z $env_name ]] && return
  prompt_segment 4 15 "🐍 %B${env_name}%b"
}

# ── Estado ───────────────────────────────────────────────────────────────────
prompt_status() {
  local -a sym
  [[ $RETVAL -ne 0 ]]             && sym+="%F{1}✘ %F{9}$RETVAL%f"
  [[ $UID -eq 0 ]]                && sym+="%F{11}⚡%f"
  [[ $(jobs -l | wc -l) -gt 0 ]] && sym+="%F{12}⚙%f"
  [[ -n "${sym[*]}" ]] && prompt_segment 0 default "${(j:  :)sym}"
}

# ── Timer ────────────────────────────────────────────────────────────────────
_cmd_start=-1
_record_cmd_start() { _cmd_start=$SECONDS; }
add-zsh-hook preexec _record_cmd_start

_build_rprompt() {
  (( _cmd_start < 0 )) && return
  local e=$(( SECONDS - _cmd_start ))
  (( e < 3 )) && return
  if   (( e >= 3600 )); then print -Pn "%F{3}▶ $(( e/3600 ))h$(( (e%3600)/60 ))m%f"
  elif (( e >= 60 ));   then print -Pn "%F{3}▶ $(( e/60 ))m$(( e%60 ))s%f"
  else                       print -Pn "%F{3}▶ ${e}s%f"
  fi
}

# ── Main ─────────────────────────────────────────────────────────────────────
build_prompt() {
  RETVAL=$?
  prompt_head
  prompt_status
  prompt_virtualenv
  prompt_context
  prompt_git
  prompt_end
}

setopt promptsubst

PROMPT='%{%f%b%k%}$(build_prompt) '
RPROMPT='%{%f%b%k%}$(_build_rprompt)'
