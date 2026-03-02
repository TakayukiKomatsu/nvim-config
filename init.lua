-- Leader keys must be set before lazy/plugin setup
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")

-- 🍎 Mac-optimized configuration
require("config.mac-options") -- Mac system integration and optimizations
require("config.mac-terminal-keymaps") -- Clean Option key mappings
