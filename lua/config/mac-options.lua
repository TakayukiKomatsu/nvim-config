-- Mac-specific optimizations and options
-- This file contains settings specifically optimized for Mac terminal usage

local opt = vim.opt

-- ═══════════════════════════════════════════════════════════════
-- MAC SYSTEM INTEGRATION
-- ═══════════════════════════════════════════════════════════════

-- Clipboard integration
opt.clipboard:append("unnamedplus") -- Use system clipboard as default register

-- Mouse and trackpad settings
opt.mouse = "a" -- Enable mouse support in all modes
opt.mousescroll = "ver:3,hor:6" -- Smooth scrolling for trackpad

-- Terminal integration
opt.titlestring = "%t - Neovim" -- Better title for Mac windows
opt.title = true -- Enable window titles

-- ═══════════════════════════════════════════════════════════════
-- UI ENHANCEMENTS
-- ═══════════════════════════════════════════════════════════════

-- Visual feedback
opt.cursorline = true -- Highlight current line
opt.cursorcolumn = false -- Don't highlight column (can be distracting)
opt.termguicolors = true -- Enable true color support (Retina displays)
opt.signcolumn = "yes" -- Always show sign column to prevent text shifting

-- Popup menu settings
opt.pumheight = 10 -- Limit popup menu height
opt.pumwidth = 15 -- Minimum popup menu width

-- Split behavior
opt.splitbelow = true -- Horizontal splits go below
opt.splitright = true -- Vertical splits go right
opt.equalalways = true -- Keep splits equal size

-- ═══════════════════════════════════════════════════════════════
-- KEYBOARD OPTIMIZATIONS
-- ═══════════════════════════════════════════════════════════════

-- Timeout settings
opt.timeout = true
opt.timeoutlen = 300 -- Shorter timeout for key combinations
opt.updatetime = 250 -- Faster update time

-- Backspace behavior
opt.backspace = "indent,eol,start" -- Allow backspace to work properly

-- ═══════════════════════════════════════════════════════════════
-- SEARCH SETTINGS
-- ═══════════════════════════════════════════════════════════════

opt.ignorecase = true -- Case-insensitive search
opt.smartcase = true -- Case-sensitive with capitals

-- Wildmenu
opt.wildmenu = true
opt.wildmode = "longest:full,full"

-- Scroll context (better for trackpad)
opt.scrolloff = 8 -- Keep 8 lines visible above/below cursor
opt.sidescrolloff = 8 -- Keep 8 columns visible left/right

-- ═══════════════════════════════════════════════════════════════
-- PERFORMANCE OPTIMIZATIONS
-- ═══════════════════════════════════════════════════════════════

-- File handling (Mac has Time Machine, SSDs are fast)
opt.backup = false -- Don't create backup files
opt.writebackup = false -- Don't create backup before writing
opt.swapfile = false -- Disable swap files

-- Persistent undo
opt.undofile = true -- Enable persistent undo
opt.undodir = vim.fn.expand("~/.local/state/nvim/undo") -- Centralized undo directory

-- ═══════════════════════════════════════════════════════════════
-- FILE SYSTEM INTEGRATION
-- ═══════════════════════════════════════════════════════════════

-- File format detection
opt.fileformats = "unix,mac,dos" -- Support multiple file formats

-- Ignore Mac-specific files
opt.wildignore:append({
  "*.DS_Store", -- Mac folder metadata
  ".Trash/*", -- Mac trash
  "*.localized", -- Mac localization files
  "*/.fseventsd/*", -- Mac file system events
})

-- ═══════════════════════════════════════════════════════════════
-- AUTOCMDS
-- ═══════════════════════════════════════════════════════════════

local mac_group = vim.api.nvim_create_augroup("MacOptimizations", { clear = true })

-- GUI font for Mac GUI versions (VimR, Neovide, etc.)
vim.api.nvim_create_autocmd("VimEnter", {
  group = mac_group,
  callback = function()
    if vim.fn.has("gui_running") == 1 then
      vim.o.guifont = "SF Mono:h14"
    end
  end,
  desc = "Set Mac-optimized GUI font",
})

-- Auto-reload files changed externally (Xcode, other Mac tools)
vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter", "CursorHold", "CursorHoldI" }, {
  group = mac_group,
  pattern = "*",
  command = "if mode() != 'c' | checktime | endif",
  desc = "Auto-reload files changed externally",
})

-- Terminal appearance
vim.api.nvim_create_autocmd("TermOpen", {
  group = mac_group,
  pattern = "*",
  callback = function()
    vim.opt_local.number = false
    vim.opt_local.relativenumber = false
    vim.opt_local.scrolloff = 0
    vim.opt_local.sidescrolloff = 0
  end,
  desc = "Optimize terminal appearance",
})
