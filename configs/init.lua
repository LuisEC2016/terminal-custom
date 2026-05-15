-- ── Neovim config — Pixegami ─────────────────────────────────────────────────
-- Configuración mínima pero completa para programar desde terminal

-- ── Opciones generales ────────────────────────────────────────────────────────
vim.opt.number         = true
vim.opt.relativenumber = true
vim.opt.cursorline     = true
vim.opt.scrolloff      = 8
vim.opt.signcolumn     = "yes"
vim.opt.colorcolumn    = "88"
vim.opt.wrap           = false
vim.opt.splitbelow     = true
vim.opt.splitright     = true
vim.opt.termguicolors  = true

-- ── Indentación ───────────────────────────────────────────────────────────────
vim.opt.expandtab   = true
vim.opt.tabstop     = 4
vim.opt.shiftwidth  = 4
vim.opt.softtabstop = 4
vim.opt.smartindent = true

-- ── Búsqueda ──────────────────────────────────────────────────────────────────
vim.opt.incsearch  = true
vim.opt.hlsearch   = true
vim.opt.ignorecase = true
vim.opt.smartcase  = true

-- ── Comportamiento ────────────────────────────────────────────────────────────
vim.opt.hidden    = true
vim.opt.swapfile  = false
vim.opt.autoread  = true
vim.opt.mouse     = "a"
vim.opt.encoding  = "utf-8"
vim.opt.clipboard = "unnamedplus"   -- portapapeles del sistema

-- ── Líder ─────────────────────────────────────────────────────────────────────
vim.g.mapleader      = " "
vim.g.maplocalleader = " "

-- ── Atajos esenciales ─────────────────────────────────────────────────────────
local map = vim.keymap.set
local opts = { noremap = true, silent = true }

-- Limpiar búsqueda
map("n", "<leader>h", ":nohlsearch<CR>", opts)

-- Navegar entre splits con Ctrl+hjkl
map("n", "<C-h>", "<C-w>h", opts)
map("n", "<C-j>", "<C-w>j", opts)
map("n", "<C-k>", "<C-w>k", opts)
map("n", "<C-l>", "<C-w>l", opts)

-- Guardar con Ctrl+S
map({ "n", "i" }, "<C-s>", "<Esc>:w<CR>", opts)

-- Cerrar buffer sin cerrar ventana
map("n", "<leader>q", ":bd<CR>", opts)

-- Mover líneas en visual con J/K
map("v", "J", ":m '>+1<CR>gv=gv", opts)
map("v", "K", ":m '<-2<CR>gv=gv", opts)

-- Explorador de archivos integrado
map("n", "<leader>e", ":Ex<CR>", opts)

-- Splits rápidos
map("n", "<leader>v", ":vsplit<CR>", opts)
map("n", "<leader>s", ":split<CR>", opts)

-- ── Netrw (explorador nativo) ─────────────────────────────────────────────────
vim.g.netrw_banner    = 0      -- ocultar banner
vim.g.netrw_liststyle = 3      -- vista de árbol
vim.g.netrw_winsize   = 25     -- ancho 25%

-- ── Colores: tokyonight si está disponible, si no colorscheme base ────────────
local ok_color, _ = pcall(vim.cmd, "colorscheme tokyonight-night")
if not ok_color then
  vim.cmd("colorscheme habamax")
end

-- ── Highlight al pegar ────────────────────────────────────────────────────────
local highlight_group = vim.api.nvim_create_augroup("YankHighlight", { clear = true })
vim.api.nvim_create_autocmd("TextYankPost", {
  group    = highlight_group,
  callback = function() vim.highlight.on_yank() end,
})

-- ── Auto-cerrar corchetes ─────────────────────────────────────────────────────
local pairs_map = { ["("] = ")", ["{"] = "}", ["["] = "]", ['"'] = '"', ["'"] = "'" }
for open, close in pairs(pairs_map) do
  map("i", open, open .. close .. "<Left>", opts)
end

-- ── Statusline minimalista (sin plugins) ──────────────────────────────────────
vim.opt.laststatus = 2
vim.opt.showmode   = false

local function statusline()
  local mode_map = {
    n = "NORMAL", i = "INSERT", v = "VISUAL", V = "V-LINE",
    ["\22"] = "V-BLOCK", c = "COMMAND", R = "REPLACE", s = "SELECT",
  }
  local mode = mode_map[vim.fn.mode()] or vim.fn.mode()
  local file = vim.fn.expand("%:t") ~= "" and vim.fn.expand("%:~:.") or "[sin nombre]"
  local modified = vim.bo.modified and " [+]" or ""
  local ft = vim.bo.filetype ~= "" and ("  " .. vim.bo.filetype) or ""
  local pos = " %l:%c "
  return string.format(" %s  %s%s%s %%=%s%s", mode, file, modified, ft, pos, "")
end

vim.opt.statusline = "%!v:lua.require'vim'._statusline()"
-- Fallback simple si la función falla
vim.api.nvim_create_autocmd({ "ModeChanged", "BufEnter", "BufWritePost" }, {
  callback = function()
    vim.opt.statusline = statusline()
  end,
})
vim.opt.statusline = statusline()
