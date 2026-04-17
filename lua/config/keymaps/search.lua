-- Search: finding, clearing highlights, centered jumps.
local keymap = vim.keymap

-- Entry points for /
keymap.set("n", "<leader>/", "/", { desc = "Search" })
keymap.set("n", "<A-/>", "/", { desc = "Find (⌥/)" })

-- Next/prev match
keymap.set("n", "<A-n>", "n", { desc = "Next match (⌥N)" })
keymap.set("n", "<A-N>", "N", { desc = "Previous match (⌥⇧N)" })
keymap.set("n", "n", "nzzzv", { desc = "Next search result" })
keymap.set("n", "N", "Nzzzv", { desc = "Previous search result" })
keymap.set("n", "*", "*zzzv", { desc = "Search word under cursor" })
keymap.set("n", "#", "#zzzv", { desc = "Search word under cursor backward" })

-- Clear search highlights
keymap.set("n", "<Esc>", "<cmd>nohl<CR>", { desc = "Clear search highlights" })
keymap.set("n", "<leader>uh", "<cmd>nohl<CR>", { desc = "Clear highlights" })
