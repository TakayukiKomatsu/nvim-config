-- Options are automatically loaded before lazy.nvim startup.
-- LazyVim defaults: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua

local opt = vim.opt

-- Disable netrw early so nvim-tree can hijack directory opens (file explorer is nvim-tree)
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- ═══════════════════════════════════════════════════════════════
-- EDITOR BASICS
-- ═══════════════════════════════════════════════════════════════

-- Line numbers
opt.relativenumber = true
opt.number = true

-- Tabs & indentation
opt.tabstop = 2
opt.shiftwidth = 2
opt.expandtab = true
opt.autoindent = true

-- Whitespace hints (helps spot mixed indentation)
opt.list = true
opt.listchars = { tab = "→ ", lead = "·", trail = "·" }

-- Line wrapping
opt.wrap = true

-- Folding (treesitter-based, no extra plugin needed)
opt.foldmethod = "expr"
opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
opt.foldlevel = 99
opt.foldlevelstart = 99
opt.foldenable = true

-- Colorscheme bias
opt.background = "dark"

-- LazyVim behavior
vim.g.autoformat = false -- format manually via <leader>cf / <A-F>
vim.g.lazyvim_picker = "telescope"

-- ═══════════════════════════════════════════════════════════════
-- MAC SYSTEM INTEGRATION
-- ═══════════════════════════════════════════════════════════════

opt.clipboard:append("unnamedplus") -- system clipboard as default register
opt.mouse = "a"
opt.mousescroll = "ver:3,hor:6" -- smooth trackpad scroll
opt.title = true
opt.titlestring = "%t - Neovim"

-- ═══════════════════════════════════════════════════════════════
-- UI
-- ═══════════════════════════════════════════════════════════════

opt.cursorline = true
opt.cursorcolumn = false
opt.termguicolors = true
opt.signcolumn = "yes"
opt.pumheight = 10
opt.pumwidth = 15
opt.splitbelow = true
opt.splitright = true
opt.equalalways = true

-- ═══════════════════════════════════════════════════════════════
-- KEYBOARD / TIMING
-- ═══════════════════════════════════════════════════════════════

opt.timeout = true
opt.timeoutlen = 300
opt.updatetime = 250
opt.backspace = "indent,eol,start"

-- ═══════════════════════════════════════════════════════════════
-- SEARCH / COMPLETION
-- ═══════════════════════════════════════════════════════════════

opt.ignorecase = true
opt.smartcase = true
opt.wildmenu = true
opt.wildmode = "longest:full,full"
opt.scrolloff = 8
opt.sidescrolloff = 8

-- ═══════════════════════════════════════════════════════════════
-- PERFORMANCE (SSD + Time Machine → no swap/backup needed)
-- ═══════════════════════════════════════════════════════════════

opt.backup = false
opt.writebackup = false
opt.swapfile = false
opt.undofile = true
opt.undodir = vim.fn.expand("~/.local/state/nvim/undo")

-- ═══════════════════════════════════════════════════════════════
-- FILE SYSTEM / IGNORES
-- ═══════════════════════════════════════════════════════════════

opt.fileformats = "unix,mac,dos"
opt.wildignore:append({
  "*.DS_Store",
  ".Trash/*",
  "*.localized",
  "*/.fseventsd/*",
})
