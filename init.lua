-- Leader keys must be set before lazy/plugin setup
vim.g.mapleader = " "
vim.g.maplocalleader = ","

-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")

