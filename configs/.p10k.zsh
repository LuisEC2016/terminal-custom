# Powerlevel10k config — Pixegami palette + RobotoMono Nerd Font Mono
# Paleta Ptyxis Pixegami:
#   0=#1a2e3d  1=#e05555  2=#3dba6f  3=#e0a020  4=#2e86d4  5=#7c4daa
#   6=#1aa89a  7=#c5cdd6  8=#2d4455  9=#ff6b6b 10=#5edd8a 11=#ffc947
#  12=#5bb8ff 13=#a67dd4 14=#26c9b8 15=#ffffff

(( ${+functions[p10k]} )) && p10k finalize 2>/dev/null

typeset -g p10k_config_opts=()
[[ ! -o 'aliases'         ]] || p10k_config_opts+=('aliases')
[[ ! -o 'sh_glob'         ]] || p10k_config_opts+=('sh_glob')
[[ ! -o 'no_brace_expand' ]] || p10k_config_opts+=('no_brace_expand')
setopt no_aliases no_sh_glob brace_expand

() {
  emulate -L zsh -o extended_glob

  unset -m '(POWERLEVEL9K_*|DEFAULT_USER)~POWERLEVEL9K_GITSTATUS_DIR'

  [[ $ZSH_VERSION == (5.<1->*|<6->.*) ]] || return

  # ── Segmentos ─────────────────────────────────────────────────────────────
  typeset -g POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(
    os_icon
    dir
    vcs
    prompt_char
  )

  typeset -g POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(
    status
    command_execution_time
    virtualenv
    conda
    background_jobs
    time
  )

  # ── Modo y separadores ────────────────────────────────────────────────────
  typeset -g POWERLEVEL9K_MODE=nerdfont-v3
  # Sin padding extra — Nerd Font Mono ya tiene ancho correcto de 1 celda
  typeset -g POWERLEVEL9K_ICON_PADDING=none

  typeset -g POWERLEVEL9K_LEFT_SEGMENT_SEPARATOR=$''
  typeset -g POWERLEVEL9K_RIGHT_SEGMENT_SEPARATOR=$''
  typeset -g POWERLEVEL9K_LEFT_SUBSEGMENT_SEPARATOR=$''
  typeset -g POWERLEVEL9K_RIGHT_SUBSEGMENT_SEPARATOR=$''
  typeset -g POWERLEVEL9K_LEFT_PROMPT_LAST_SEGMENT_END_SYMBOL=$''
  typeset -g POWERLEVEL9K_RIGHT_PROMPT_FIRST_SEGMENT_START_SYMBOL=$''

  typeset -g POWERLEVEL9K_PROMPT_ADD_NEWLINE=false
  typeset -g POWERLEVEL9K_PROMPT_ON_NEWLINE=false
  typeset -g POWERLEVEL9K_RPROMPT_ON_NEWLINE=false
  typeset -g POWERLEVEL9K_INSTANT_PROMPT=verbose
  typeset -g POWERLEVEL9K_TRANSIENT_PROMPT=off

  # ── os_icon ───────────────────────────────────────────────────────────────
  typeset -g POWERLEVEL9K_OS_ICON_FOREGROUND=12
  typeset -g POWERLEVEL9K_OS_ICON_BACKGROUND=8

  # ── dir ───────────────────────────────────────────────────────────────────
  typeset -g POWERLEVEL9K_DIR_BACKGROUND=4
  typeset -g POWERLEVEL9K_DIR_FOREGROUND=15
  typeset -g POWERLEVEL9K_DIR_SHORTENED_FOREGROUND=7
  typeset -g POWERLEVEL9K_DIR_ANCHOR_FOREGROUND=15
  typeset -g POWERLEVEL9K_DIR_ANCHOR_BOLD=true
  typeset -g POWERLEVEL9K_SHORTEN_STRATEGY=truncate_to_unique
  typeset -g POWERLEVEL9K_SHORTEN_DELIMITER=''
  typeset -g POWERLEVEL9K_DIR_MAX_LENGTH=40

  # Iconos BMP (U+E000-U+FFFF): VTE 0.84 mide chars suplementarios (U+10000+) como ancho 0
  typeset -g POWERLEVEL9K_DIR_HOME_ICON=''
  typeset -g POWERLEVEL9K_DIR_HOME_SUBFOLDER_ICON=''
  typeset -g POWERLEVEL9K_DIR_ETC_ICON=''
  typeset -g POWERLEVEL9K_DIR_DEFAULT_ICON=''

  typeset -g POWERLEVEL9K_DIR_HOME_BACKGROUND=4
  typeset -g POWERLEVEL9K_DIR_HOME_FOREGROUND=15
  typeset -g POWERLEVEL9K_DIR_HOME_SUBFOLDER_BACKGROUND=4
  typeset -g POWERLEVEL9K_DIR_HOME_SUBFOLDER_FOREGROUND=15

  # ── vcs (git) ─────────────────────────────────────────────────────────────
  typeset -g POWERLEVEL9K_VCS_BRANCH_ICON=' '

  typeset -g POWERLEVEL9K_VCS_CLEAN_BACKGROUND=6
  typeset -g POWERLEVEL9K_VCS_CLEAN_FOREGROUND=0

  typeset -g POWERLEVEL9K_VCS_UNTRACKED_BACKGROUND=3
  typeset -g POWERLEVEL9K_VCS_UNTRACKED_FOREGROUND=0

  typeset -g POWERLEVEL9K_VCS_MODIFIED_BACKGROUND=3
  typeset -g POWERLEVEL9K_VCS_MODIFIED_FOREGROUND=0

  typeset -g POWERLEVEL9K_VCS_UNTRACKED_ICON='?'
  typeset -g POWERLEVEL9K_VCS_UNSTAGED_ICON='!'
  typeset -g POWERLEVEL9K_VCS_STAGED_ICON='+'
  typeset -g POWERLEVEL9K_VCS_STASH_ICON=''
  typeset -g POWERLEVEL9K_VCS_INCOMING_CHANGES_ICON=''
  typeset -g POWERLEVEL9K_VCS_OUTGOING_CHANGES_ICON=''

  # ── prompt_char ───────────────────────────────────────────────────────────
  typeset -g POWERLEVEL9K_PROMPT_CHAR_OK_VIINS_FOREGROUND=10
  typeset -g POWERLEVEL9K_PROMPT_CHAR_OK_VICMD_FOREGROUND=12
  typeset -g POWERLEVEL9K_PROMPT_CHAR_OK_VIVIS_FOREGROUND=13
  typeset -g POWERLEVEL9K_PROMPT_CHAR_ERROR_VIINS_FOREGROUND=9
  typeset -g POWERLEVEL9K_PROMPT_CHAR_ERROR_VICMD_FOREGROUND=9
  typeset -g POWERLEVEL9K_PROMPT_CHAR_ERROR_VIVIS_FOREGROUND=9
  typeset -g POWERLEVEL9K_PROMPT_CHAR_OVERWRITE_STATE=false
  typeset -g POWERLEVEL9K_PROMPT_CHAR_{OK,ERROR}_VIINS_CONTENT_EXPANSION='❯'
  typeset -g POWERLEVEL9K_PROMPT_CHAR_{OK,ERROR}_VICMD_CONTENT_EXPANSION='❮'
  typeset -g POWERLEVEL9K_PROMPT_CHAR_{OK,ERROR}_VIVIS_CONTENT_EXPANSION='V'

  # ── status ────────────────────────────────────────────────────────────────
  typeset -g POWERLEVEL9K_STATUS_EXTENDED_STATES=true
  typeset -g POWERLEVEL9K_STATUS_OK=false
  typeset -g POWERLEVEL9K_STATUS_ERROR_FOREGROUND=9
  typeset -g POWERLEVEL9K_STATUS_ERROR_BACKGROUND=0
  typeset -g POWERLEVEL9K_STATUS_ERROR_SIGNAL_FOREGROUND=9
  typeset -g POWERLEVEL9K_STATUS_ERROR_SIGNAL_BACKGROUND=0
  typeset -g POWERLEVEL9K_STATUS_ERROR_PIPE_FOREGROUND=9
  typeset -g POWERLEVEL9K_STATUS_ERROR_PIPE_BACKGROUND=0

  # ── command_execution_time ────────────────────────────────────────────────
  typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_THRESHOLD=3
  typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_PRECISION=1
  typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_FOREGROUND=11
  typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_BACKGROUND=0
  # Icono NF v3 para timer
  typeset -g POWERLEVEL9K_EXECUTION_TIME_ICON=''

  # ── virtualenv / conda ────────────────────────────────────────────────────
  typeset -g POWERLEVEL9K_VIRTUALENV_FOREGROUND=15
  typeset -g POWERLEVEL9K_VIRTUALENV_BACKGROUND=4
  typeset -g POWERLEVEL9K_VIRTUALENV_SHOW_PYTHON_VERSION=false
  typeset -g POWERLEVEL9K_VIRTUALENV_{LEFT,RIGHT}_DELIMITER=

  typeset -g POWERLEVEL9K_CONDA_FOREGROUND=15
  typeset -g POWERLEVEL9K_CONDA_BACKGROUND=4
  typeset -g POWERLEVEL9K_CONDA_SHOW_PYTHON_VERSION=false
  typeset -g POWERLEVEL9K_CONDA_{LEFT,RIGHT}_DELIMITER=

  # ── background_jobs ───────────────────────────────────────────────────────
  typeset -g POWERLEVEL9K_BACKGROUND_JOBS_VERBOSE=false
  typeset -g POWERLEVEL9K_BACKGROUND_JOBS_FOREGROUND=12
  typeset -g POWERLEVEL9K_BACKGROUND_JOBS_BACKGROUND=0

  # ── time ──────────────────────────────────────────────────────────────────
  typeset -g POWERLEVEL9K_TIME_FOREGROUND=8
  typeset -g POWERLEVEL9K_TIME_BACKGROUND=0
  typeset -g POWERLEVEL9K_TIME_FORMAT='%D{%H:%M}'
  typeset -g POWERLEVEL9K_TIME_UPDATE_ON_COMMAND=false

}

(( ${#p10k_config_opts} == 0 )) || setopt $p10k_config_opts
unset p10k_config_opts
