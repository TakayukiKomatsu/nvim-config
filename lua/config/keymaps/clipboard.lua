-- Clipboard: system clipboard helpers (⌥-key Mac-style).
local keymap = vim.keymap

keymap.set("v", "<A-c>", '"+y', { desc = "Copy to clipboard (⌥C)" })
keymap.set("v", "<A-C>", '"+x', { desc = "Cut to clipboard (⌥⇧C)" })
keymap.set({ "n", "v" }, "<A-v>", '"+p', { desc = "Paste from clipboard (⌥V)" })
keymap.set("i", "<A-v>", "<C-r>+", { desc = "Paste in insert (⌥V)" })
keymap.set("v", "<leader>y", '"+y', { desc = "Copy to clipboard" })

-- Safe paste (terminal-friendly): temporarily enable paste, paste from "+, then restore
keymap.set("n", "<A-P>", function()
  local prev = vim.o.paste
  vim.o.paste = true
  vim.cmd('normal! "+p')
  vim.defer_fn(function()
    vim.o.paste = prev
  end, 50)
end, { desc = "Safe paste from clipboard (⌥⇧P)" })

