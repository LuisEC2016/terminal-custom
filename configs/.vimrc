" VIM Configuration Profile — Pixegami
" Powerline + mejoras para uso intensivo en terminal

" ── Powerline ─────────────────────────────────────────────────────────────────
" Detecta la versión de Python 3 activa en tiempo de ejecución
let s:py3 = system('python3 -c "import sys; print(\"python\"+\".\".join(map(str,sys.version_info[:2])))"')[:-1]
execute 'set rtp+=' . $HOME . '/.local/lib/' . s:py3 . '/site-packages/powerline/bindings/vim/'
set laststatus=2
set t_Co=256
set noshowmode      " Powerline ya muestra el modo, no duplicar

" ── Apariencia ────────────────────────────────────────────────────────────────
syntax on
set number              " números de línea
set relativenumber      " números relativos (facilita saltos con <N>j/<N>k)
set cursorline          " resaltar línea actual
set colorcolumn=88      " guía visual en columna 88 (compatible con black/ruff)
set scrolloff=8         " mantener 8 líneas de contexto al hacer scroll
set signcolumn=yes      " columna para signos de git/lsp siempre visible

" ── Indentación ───────────────────────────────────────────────────────────────
set expandtab           " espacios en lugar de tabs
set tabstop=4
set shiftwidth=4
set softtabstop=4
set smartindent
set autoindent

" ── Búsqueda ──────────────────────────────────────────────────────────────────
set incsearch
set hlsearch
set ignorecase
set smartcase           " case-sensitive si hay mayúsculas en el patrón

" ── Comportamiento ────────────────────────────────────────────────────────────
set showcmd
set wildmenu            " autocompletado de comandos con Tab
set wildmode=list:longest,full
set backspace=indent,eol,start
set encoding=utf-8
set fileencoding=utf-8
set hidden              " permite cambiar buffer sin guardar
set noswapfile          " sin archivos .swp
set autoread            " recargar si el archivo cambió fuera de vim
set mouse=a             " ratón en terminal

" ── Splits más naturales ──────────────────────────────────────────────────────
set splitbelow
set splitright

" ── Atajos ───────────────────────────────────────────────────────────────────
let mapleader = " "
" Limpiar resaltado de búsqueda con Space+h
nnoremap <leader>h :nohlsearch<CR>
" Navegar entre splits con Ctrl+hjkl
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l
" Guardar con Ctrl+S
nnoremap <C-s> :w<CR>
inoremap <C-s> <Esc>:w<CR>a
