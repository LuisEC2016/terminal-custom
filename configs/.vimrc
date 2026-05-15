" VIM Configuration Profile — Pixegami
" Powerline + herramientas completas para programar desde terminal

" ── Powerline ─────────────────────────────────────────────────────────────────
let s:py3 = system('python3 -c "import sys; print(\"python\"+\".\".join(map(str,sys.version_info[:2])))"')[:-1]
execute 'set rtp+=' . $HOME . '/.local/lib/' . s:py3 . '/site-packages/powerline/bindings/vim/'
set laststatus=2
set t_Co=256
set noshowmode

" ── Apariencia ────────────────────────────────────────────────────────────────
syntax on
set number
set relativenumber
set cursorline
set colorcolumn=88
set scrolloff=8
set signcolumn=yes
set wrap!
set splitbelow
set splitright
set termguicolors
set background=dark

" ── Indentación ───────────────────────────────────────────────────────────────
set expandtab
set tabstop=4
set shiftwidth=4
set softtabstop=4
set smartindent
set autoindent

" ── Búsqueda ──────────────────────────────────────────────────────────────────
set incsearch
set hlsearch
set ignorecase
set smartcase

" ── Comportamiento ────────────────────────────────────────────────────────────
set showcmd
set wildmenu
set wildmode=list:longest,full
set wildignore+=*.pyc,*.o,*.obj,*/.git/*,*/node_modules/*,*/__pycache__/*
set backspace=indent,eol,start
set encoding=utf-8
set fileencoding=utf-8
set hidden
set noswapfile
set autoread
set mouse=a
set clipboard=unnamedplus          " portapapeles del sistema
set updatetime=100                 " refresco más rápido (sign column, gitgutter)
set timeoutlen=500                 " timeout de key sequences

" ── netrw: explorador de archivos integrado ───────────────────────────────────
let g:netrw_banner    = 0
let g:netrw_liststyle = 3          " vista de árbol
let g:netrw_winsize   = 25
let g:netrw_altv      = 1          " abrir splits a la derecha

" ── Líder ─────────────────────────────────────────────────────────────────────
let mapleader = " "

" ── Atajos esenciales ─────────────────────────────────────────────────────────
" Limpiar búsqueda
nnoremap <leader>h :nohlsearch<CR>

" Navegar entre splits con Ctrl+hjkl
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" Guardar con Ctrl+S
nnoremap <C-s> :w<CR>
inoremap <C-s> <Esc>:w<CR>a

" Cerrar buffer sin cerrar ventana
nnoremap <leader>q :bd<CR>

" Explorador de archivos
nnoremap <leader>e :Explore<CR>
nnoremap <leader>E :Vexplore<CR>

" Splits
nnoremap <leader>v :vsplit<CR>
nnoremap <leader>s :split<CR>

" Mover líneas en modo visual con J/K
vnoremap J :m '>+1<CR>gv=gv
vnoremap K :m '<-2<CR>gv=gv

" Reseleccionar después de indentar en visual
vnoremap < <gv
vnoremap > >gv

" Saltar al matching bracket con Tab en normal
nnoremap <Tab> %

" ── Terminales ───────────────────────────────────────────────────────────────
" Ctrl+T abre terminal en split horizontal
nnoremap <C-t> :below terminal<CR>
" Salir del modo terminal con Esc
tnoremap <Esc> <C-\><C-n>

" ── Auto-cerrar pares ────────────────────────────────────────────────────────
inoremap ( ()<Left>
inoremap { {}<Left>
inoremap [ []<Left>
inoremap " ""<Left>
inoremap ' ''<Left>

" ── FZF: búsqueda difusa si está disponible ───────────────────────────────────
if executable('fzf')
  " Buscar archivos con leader+f
  nnoremap <leader>f :call fzf#run(fzf#wrap({'source': 'fd --type f --hidden --exclude .git', 'sink': 'e'}))<CR>
  " Buscar en historial de buffers con leader+b
  nnoremap <leader>b :buffers<CR>:b<Space>
endif

" ── Ripgrep: buscar en proyecto ───────────────────────────────────────────────
if executable('rg')
  set grepprg=rg\ --vimgrep\ --smart-case
  set grepformat=%f:%l:%c:%m
  " leader+r: grep interactivo
  nnoremap <leader>r :grep! ""<Left>
  " leader+w: grep la palabra bajo el cursor
  nnoremap <leader>w :grep! "\b<C-R><C-W>\b"<CR>:cw<CR>
endif

" ── Quickfix: navegar resultados de búsqueda ─────────────────────────────────
nnoremap <leader>co :copen<CR>
nnoremap <leader>cc :cclose<CR>
nnoremap [q :cprev<CR>
nnoremap ]q :cnext<CR>

" ── Recargar archivo si cambió en disco ──────────────────────────────────────
augroup auto_read
  autocmd!
  autocmd FocusGained,BufEnter * checktime
augroup END

" ── Resaltar al pegar ────────────────────────────────────────────────────────
augroup yank_highlight
  autocmd!
  autocmd TextYankPost * silent! lua vim.highlight.on_yank {higroup="IncSearch", timeout=150}
augroup END

" ── Quitar espacios al final al guardar ──────────────────────────────────────
augroup trim_whitespace
  autocmd!
  autocmd BufWritePre * :%s/\s\+$//e
augroup END

" ── Indentación por tipo de archivo ──────────────────────────────────────────
augroup filetype_indent
  autocmd!
  autocmd FileType javascript,typescript,html,css,json,yaml,toml
        \ setlocal tabstop=2 shiftwidth=2 softtabstop=2
  autocmd FileType go
        \ setlocal noexpandtab tabstop=4 shiftwidth=4
  autocmd FileType markdown
        \ setlocal wrap linebreak spell spelllang=en,es
augroup END

" ── Mostrar caracteres especiales ────────────────────────────────────────────
set list
set listchars=tab:→\ ,trail:·,extends:›,precedes:‹,nbsp:·
