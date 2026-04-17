-- Editing: select, duplicate, delete, indent, move, join.
local keymap = vim.keymap

-- Select all
keymap.set("n", "<leader>a", "ggVG", { desc = "Select all" })
keymap.set("n", "<A-a>", "ggVG", { desc = "Select all (⌥A)" })

-- Duplicate
keymap.set("n", "<A-D>", "yyp", { desc = "Duplicate line (⌥⇧D)" })
keymap.set("v", "<A-D>", "y'>p", { desc = "Duplicate selection (⌥⇧D)" })

-- Delete without yank (<leader>d* prefix is DAP; <leader>cd shows diagnostics)
keymap.set({ "n", "v" }, "<leader>dd", [["_d]], { desc = "Delete without yank" })
keymap.set({ "n", "v" }, "x", [["_x]], { desc = "Delete char without yank" })
keymap.set("n", "<A-x>", '"_dd', { desc = "Delete line without yank (⌥X)" })
keymap.set("v", "<A-x>", '"_d', { desc = "Delete selection without yank (⌥X)" })

-- Line movement (leader alternative — mini.move owns <A-J>/<A-K>)
keymap.set("n", "<leader>mj", ":m .+1<CR>==", { desc = "Move line down" })
keymap.set("n", "<leader>mk", ":m .-2<CR>==", { desc = "Move line up" })
keymap.set("v", "<leader>mj", ":m '>+1<CR>gv=gv", { desc = "Move selection down" })
keymap.set("v", "<leader>mk", ":m '<-2<CR>gv=gv", { desc = "Move selection up" })

-- Indent/unindent (keep visual selection)
keymap.set("v", "<Tab>", ">gv", { desc = "Indent" })
keymap.set("v", "<S-Tab>", "<gv", { desc = "Unindent" })
keymap.set("v", "<", "<gv", { desc = "Unindent" })
keymap.set("v", ">", ">gv", { desc = "Indent" })

-- Join/increment/macros
keymap.set("n", "J", "mzJ`z", { desc = "Join lines without moving cursor" })
keymap.set("n", "<leader>+", "<C-a>", { desc = "Increment number" })
keymap.set("n", "<leader>-", "<C-x>", { desc = "Decrement number" })
keymap.set("n", "Q", "@@", { desc = "Replay last macro" })
