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
-- Personal default is real tabs. A project's .editorconfig overrides these
-- per-buffer (Neovim's built-in EditorConfig support, enabled below).
opt.tabstop = 2
opt.shiftwidth = 2
opt.expandtab = false
opt.autoindent = true

-- Respect .editorconfig per project (indent_style/size, end_of_line, charset, …).
-- On by default in Neovim, set explicitly so the intent is visible.
vim.g.editorconfig = true

-- Whitespace hints. `lead` is intentionally omitted: mini.indentscope shows the
-- indent structure and tabs-vs-spaces.nvim flags indentation that deviates from
-- the buffer's dominant style (both directions), so per-space lead dots would
-- only add noise. `nbsp` catches non-breaking spaces pasted from the web.
-- Trailing whitespace is owned by mini.trailspace (highlight + auto-trim on save).
opt.list = true
opt.listchars = { tab = "→ ", nbsp = "␣", trail = "·" }

-- Line wrapping
opt.wrap = true

-- Folding (provided by nvim-ufo, see lua/plugins/nvim-ufo.lua).
-- ufo manages the fold provider (treesitter -> indent), so we only set the
-- "everything open" defaults it requires and leave foldmethod at its default.
opt.foldlevel = 99
opt.foldlevelstart = 99
opt.foldenable = true

-- Live preview of :substitute (s/foo/bar) in a split as you type.
opt.inccommand = "split"

-- Colorscheme bias
opt.background = "dark"

-- LazyVim behavior
vim.g.disable_autoformat = false -- conform format-on-save enabled; toggle with <leader>uF
vim.g.lazyvim_picker = "snacks" -- snacks.picker (see lua/plugins/snacks-picker.lua)

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
