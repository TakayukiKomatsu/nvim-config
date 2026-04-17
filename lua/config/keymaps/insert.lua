-- Insert-mode helpers: escape shortcuts, arrow-free motion, quick save.
local keymap = vim.keymap

-- Escape alternatives
keymap.set("i", "jk", "<ESC>", { desc = "Exit insert mode with jk" })
keymap.set("i", "jj", "<ESC>", { desc = "Exit insert mode (jj)" })

-- Arrow-free navigation within insert mode
keymap.set("i", "<C-h>", "<Left>", { desc = "Move left" })
keymap.set("i", "<C-l>", "<Right>", { desc = "Move right" })
keymap.set("i", "<C-j>", "<Down>", { desc = "Move down" })
keymap.set("i", "<C-k>", "<Up>", { desc = "Move up" })

-- Line start/end (Option) and word motion
keymap.set("i", "<A-h>", "<C-o>^", { desc = "Line start in insert (⌥H)" })
keymap.set("i", "<A-l>", "<C-o>$", { desc = "Line end in insert (⌥L)" })
keymap.set("i", "<A-Left>", "<C-o>b", { desc = "Word backward (⌥←)" })
keymap.set("i", "<A-Right>", "<C-o>w", { desc = "Word forward (⌥→)" })

-- Save from insert mode
keymap.set("i", "<C-s>", "<ESC><cmd>w<CR>a", { desc = "Save in insert mode" })
