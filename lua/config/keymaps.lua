-- Base Neovim keymaps
-- Note: Mac-specific Option key mappings are in mac-terminal-keymaps.lua
-- This file contains essential keymaps that work everywhere

local keymap = vim.keymap

-- ═══════════════════════════════════════════════════════════════
-- ESSENTIAL KEYMAPS (not duplicated in mac-terminal-keymaps.lua)
-- ═══════════════════════════════════════════════════════════════

-- Quick escape
keymap.set("i", "jk", "<ESC>", { desc = "Exit insert mode with jk" })

-- Tab management (moved from <leader>t* to avoid Neotest conflict)
keymap.set("n", "<leader><Tab>n", "<cmd>tabnew<CR>", { desc = "New tab" })
keymap.set("n", "<leader><Tab>x", "<cmd>tabclose<CR>", { desc = "Close tab" })
keymap.set("n", "<leader><Tab>]", "<cmd>tabn<CR>", { desc = "Next tab" })
keymap.set("n", "<leader><Tab>[", "<cmd>tabp<CR>", { desc = "Prev tab" })
keymap.set("n", "<leader><Tab>f", "<cmd>tabnew %<CR>", { desc = "Buffer in new tab" })

-- Buffer navigation with Tab
keymap.set("n", "<Tab>", "<cmd>bnext<CR>", { desc = "Next buffer" })
keymap.set("n", "<S-Tab>", "<cmd>bprev<CR>", { desc = "Previous buffer" })

-- Remove default LazyVim bindings that we override (wrapped in pcall for safety)
pcall(keymap.del, "n", "<leader>e")
pcall(keymap.del, "n", "<C-down>")

-- Keep Ctrl versions for fallback (Option versions in mac-terminal-keymaps.lua)
keymap.set("n", "<C-d>", "<C-d>zz", { desc = "Half page down" })
keymap.set("n", "<C-u>", "<C-u>zz", { desc = "Half page up" })
