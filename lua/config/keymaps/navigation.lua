-- Navigation: scrolling, word motion, tabs, quickfix/location lists, change list.
local keymap = vim.keymap

-- Page scrolling (Option for Mac-friendly, centered)
keymap.set("n", "<A-d>", "<C-d>zz", { desc = "Half page down (⌥D)" })
keymap.set("n", "<A-u>", "<C-u>zz", { desc = "Half page up (⌥U)" })
keymap.set("n", "<A-b>", "<C-b>zz", { desc = "Full page up (⌥B)" })
keymap.set("n", "<C-d>", "<C-d>zz", { desc = "Half page down" })
keymap.set("n", "<C-u>", "<C-u>zz", { desc = "Half page up" })

-- Word navigation (Mac-style Option+arrows)
keymap.set({ "n", "v" }, "<A-Left>", "b", { desc = "Word backward (⌥←)" })
keymap.set({ "n", "v" }, "<A-Right>", "w", { desc = "Word forward (⌥→)" })

-- Buffer navigation
keymap.set("n", "<Tab>", "<cmd>bnext<CR>", { desc = "Next buffer" })
keymap.set("n", "<S-Tab>", "<cmd>bprev<CR>", { desc = "Previous buffer" })

-- Tabs
keymap.set("n", "<A-t>", "<cmd>tabnew<CR>", { desc = "New tab (⌥T)" })
keymap.set("n", "<A-T>", "<cmd>tabclose<CR>", { desc = "Close tab (⌥⇧T)" })
keymap.set("n", "<A-}>", "<cmd>tabn<CR>", { desc = "Next tab (⌥})" })
keymap.set("n", "<A-{>", "<cmd>tabp<CR>", { desc = "Previous tab (⌥{)" })
for i = 1, 5 do
  keymap.set("n", "<A-" .. i .. ">", i .. "gt", { desc = "Tab " .. i .. " (⌥" .. i .. ")" })
end

-- Leader-based tab commands (also covered by <A-t> etc. — these are the discoverable path)
keymap.set("n", "<leader><Tab>n", "<cmd>tabnew<CR>", { desc = "New tab" })
keymap.set("n", "<leader><Tab>x", "<cmd>tabclose<CR>", { desc = "Close tab" })
keymap.set("n", "<leader><Tab>]", "<cmd>tabn<CR>", { desc = "Next tab" })
keymap.set("n", "<leader><Tab>[", "<cmd>tabp<CR>", { desc = "Prev tab" })
keymap.set("n", "<leader><Tab>f", "<cmd>tabnew %<CR>", { desc = "Buffer in new tab" })

-- Quickfix list (global)
keymap.set("n", "<A-[>", "<cmd>cprev<CR>zz", { desc = "Previous quickfix (⌥[)" })
keymap.set("n", "<A-]>", "<cmd>cnext<CR>zz", { desc = "Next quickfix (⌥])" })
keymap.set("n", "<leader>qo", "<cmd>copen<CR>", { desc = "Open quickfix list" })
keymap.set("n", "<leader>qc", "<cmd>cclose<CR>", { desc = "Close quickfix list" })

-- Location list (buffer-local: LSP references, etc.)
keymap.set("n", "[l", "<cmd>lprev<CR>zz", { desc = "Previous location" })
keymap.set("n", "]l", "<cmd>lnext<CR>zz", { desc = "Next location" })
keymap.set("n", "<leader>lo", "<cmd>lopen<CR>", { desc = "Open location list" })
keymap.set("n", "<leader>lc", "<cmd>lclose<CR>", { desc = "Close location list" })

-- Change list (previous/next edit location)
keymap.set("n", "g;", "g;zz", { desc = "Go to previous change" })
keymap.set("n", "g,", "g,zz", { desc = "Go to next change" })
