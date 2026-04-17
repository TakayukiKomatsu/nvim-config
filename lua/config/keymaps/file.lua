-- File and buffer operations: save, quit, buffer management.
local keymap = vim.keymap

-- Save
keymap.set("n", "<leader>w", "<cmd>w<CR>", { desc = "Save file" })
keymap.set("n", "<leader>W", "<cmd>wa<CR>", { desc = "Save all files" })
keymap.set("n", "<A-s>", "<cmd>w<CR>", { desc = "Save (⌥S)" })
keymap.set("i", "<A-s>", "<ESC><cmd>w<CR>a", { desc = "Save (⌥S)" })
keymap.set("v", "<A-s>", "<ESC><cmd>w<CR>gv", { desc = "Save (⌥S)" })

-- Quit (<leader>q* submenu is preserved for quickfix/session plugins)
keymap.set("n", "<leader>qq", "<cmd>q<CR>", { desc = "Quit window" })
keymap.set("n", "<leader>qQ", "<cmd>qa!<CR>", { desc = "Quit all without saving" })

-- Buffers
keymap.set("n", "<A-w>", function()
  require("mini.bufremove").delete(0, false)
end, { desc = "Close buffer (⌥W)" })
keymap.set("n", "<leader>bo", ":%bd|e#|bd#<CR>|'\"", { desc = "Close all buffers except current" })
keymap.set("n", "<leader>bD", ":%bd<CR>", { desc = "Delete all buffers" })
