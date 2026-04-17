-- Window management: splits, focus, resize.
local keymap = vim.keymap

-- Splits
keymap.set("n", "<leader>sv", "<C-w>v", { desc = "Split vertically" })
keymap.set("n", "<leader>sh", "<C-w>s", { desc = "Split horizontally" })
keymap.set("n", "<leader>se", "<C-w>=", { desc = "Equal windows" })
keymap.set("n", "<leader>sx", "<cmd>close<CR>", { desc = "Close split" })
keymap.set("n", "<A-\\>", "<C-w>v", { desc = "Split vertically (⌥\\)" })
keymap.set("n", "<A-->", "<C-w>s", { desc = "Split horizontally (⌥-)" })

-- Focus (Vim-style Option+hjkl)
keymap.set("n", "<A-h>", "<C-w>h", { desc = "Focus left window (⌥H)" })
keymap.set("n", "<A-j>", "<C-w>j", { desc = "Focus down window (⌥J)" })
keymap.set("n", "<A-k>", "<C-w>k", { desc = "Focus up window (⌥K)" })
keymap.set("n", "<A-l>", "<C-w>l", { desc = "Focus right window (⌥L)" })

-- Resize (Option+Shift)
keymap.set("n", "<A-S-h>", "<C-w>5<", { desc = "Decrease width (⌥⇧H)" })
keymap.set("n", "<A-S-l>", "<C-w>5>", { desc = "Increase width (⌥⇧L)" })
keymap.set("n", "<A-S-k>", "<C-w>5-", { desc = "Decrease height (⌥⇧K)" })
keymap.set("n", "<A-S-j>", "<C-w>5+", { desc = "Increase height (⌥⇧J)" })
keymap.set("n", "<A-=>", "<C-w>=", { desc = "Equal windows (⌥=)" })
