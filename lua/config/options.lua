-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Note: Mac-specific settings are in mac-options.lua (loaded via init.lua)

local opt = vim.opt

-- Line numbers
opt.relativenumber = true
opt.number = true

-- Tabs & indentation
opt.tabstop = 2 -- 2 spaces for tabs (prettier default)
opt.shiftwidth = 2 -- 2 spaces for indent width
opt.expandtab = true -- expand tab to spaces
opt.autoindent = true -- copy indent from current line when starting new one

-- Show tabs as → and trailing spaces as · (helps spot mixed indentation)
opt.list = true
opt.listchars = { tab = "→ ", lead = "·", trail = "·" }

-- Line wrapping
opt.wrap = true

-- Folding (treesitter-based, no extra plugin needed)
opt.foldmethod = "expr"
opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
opt.foldlevel = 99 -- open all folds by default
opt.foldlevelstart = 99 -- start every buffer with all folds open
opt.foldenable = true

-- Colorscheme
opt.background = "dark" -- colorschemes that can be light or dark will be made dark

-- Disable auto format-on-save (use <leader>cf to format manually)
vim.g.autoformat = false

-- Use Telescope as LazyVim's internal picker (instead of fzf-lua auto-detect)
vim.g.lazyvim_picker = "telescope"
