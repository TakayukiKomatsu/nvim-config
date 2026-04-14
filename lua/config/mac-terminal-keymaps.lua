-- Mac-Optimized Keymaps for Terminal Neovim
-- Uses Option/Alt keys and smart leader mappings since Command keys don't work in terminal

local keymap = vim.keymap

-- ═══════════════════════════════════════════════════════════════
-- 💾 ESSENTIAL FILE OPERATIONS (Leader + key for safety)
-- ═══════════════════════════════════════════════════════════════

-- Save with leader (most important operation)
keymap.set("n", "<leader>w", "<cmd>w<CR>", { desc = "Save file" })
keymap.set("n", "<leader>W", "<cmd>wa<CR>", { desc = "Save all files" })
keymap.set("i", "<C-s>", "<ESC><cmd>w<CR>a", { desc = "Save in insert mode" })

-- Quick save with Option+S (works in terminal)
keymap.set("n", "<A-s>", "<cmd>w<CR>", { desc = "Save (⌥S)" })
keymap.set("i", "<A-s>", "<ESC><cmd>w<CR>a", { desc = "Save (⌥S)" })
keymap.set("v", "<A-s>", "<ESC><cmd>w<CR>gv", { desc = "Save (⌥S)" })

-- File operations
keymap.set("n", "<leader>q", "<cmd>q<CR>", { desc = "Quit" })
keymap.set("n", "<leader>Q", "<cmd>qa!<CR>", { desc = "Quit all without saving" })
keymap.set("n", "<A-q>", "<cmd>q<CR>", { desc = "Quit (⌥Q)" })
keymap.set("n", "<A-w>", function()
  require("mini.bufremove").delete(0, false)
end, { desc = "Close buffer (⌥W)" })
-- Safe paste (terminal-friendly): temporarily enable paste, paste from "+, then restore
keymap.set("n", "<A-P>", function()
  local prev = vim.o.paste
  vim.o.paste = true
  vim.cmd('normal! "+p')
  vim.defer_fn(function()
    vim.o.paste = prev
  end, 50)
end, { desc = "Safe paste from clipboard (⌥⇧P)" })

-- Buffer management
keymap.set("n", "<leader>bo", ":%bd|e#|bd#<CR>|'\"", { desc = "Close all buffers except current" })
keymap.set("n", "<leader>bD", ":%bd<CR>", { desc = "Delete all buffers" })

-- ═══════════════════════════════════════════════════════════════
-- 🚀 NAVIGATION WITH OPTION KEYS (Mac-friendly)
-- ═══════════════════════════════════════════════════════════════

-- Half-page scrolling with Option
keymap.set("n", "<A-d>", "<C-d>zz", { desc = "Half page down (⌥D)" })
keymap.set("n", "<A-u>", "<C-u>zz", { desc = "Half page up (⌥U)" })
keymap.set("n", "<A-b>", "<C-b>zz", { desc = "Full page up (⌥B)" })

-- Word navigation (Mac-style)
keymap.set({ "n", "v" }, "<A-Left>", "b", { desc = "Word backward (⌥←)" })
keymap.set({ "n", "v" }, "<A-Right>", "w", { desc = "Word forward (⌥→)" })
keymap.set("i", "<A-Left>", "<C-o>b", { desc = "Word backward (⌥←)" })
keymap.set("i", "<A-Right>", "<C-o>w", { desc = "Word forward (⌥→)" })

-- Line navigation (use 0 and $ in normal mode, these are for insert mode only)
keymap.set("i", "<A-h>", "<C-o>^", { desc = "Line start in insert (⌥H)" })
keymap.set("i", "<A-l>", "<C-o>$", { desc = "Line end in insert (⌥L)" })

-- Quickfix & Location list navigation
-- Quickfix: global list (Telescope results with <C-q>, grep results, etc.)
keymap.set("n", "<A-[>", "<cmd>cprev<CR>zz", { desc = "Previous quickfix (⌥[)" })
keymap.set("n", "<A-]>", "<cmd>cnext<CR>zz", { desc = "Next quickfix (⌥])" })
keymap.set("n", "<leader>qo", "<cmd>copen<CR>", { desc = "Open quickfix list" })
keymap.set("n", "<leader>qc", "<cmd>cclose<CR>", { desc = "Close quickfix list" })

-- Location list: buffer-local list (LSP references, etc.)
keymap.set("n", "[l", "<cmd>lprev<CR>zz", { desc = "Previous location" })
keymap.set("n", "]l", "<cmd>lnext<CR>zz", { desc = "Next location" })
keymap.set("n", "<leader>lo", "<cmd>lopen<CR>", { desc = "Open location list" })
keymap.set("n", "<leader>lc", "<cmd>lclose<CR>", { desc = "Close location list" })

-- Note: <leader>xq and <leader>xl open quickfix/location in Trouble.nvim (fancy UI)

-- Note: Buffer navigation via <Tab>/<S-Tab> or <A-e> (Telescope)

-- Note: Git hunk navigation ]h/[h is handled by gitsigns.lua

-- Change list navigation (go to previous/next edit location)
keymap.set("n", "g;", "g;zz", { desc = "Go to previous change" })
keymap.set("n", "g,", "g,zz", { desc = "Go to next change" })

-- Tab navigation
keymap.set("n", "<A-t>", "<cmd>tabnew<CR>", { desc = "New tab (⌥T)" })
keymap.set("n", "<A-T>", "<cmd>tabclose<CR>", { desc = "Close tab (⌥⇧T)" })
keymap.set("n", "<A-}>", "<cmd>tabn<CR>", { desc = "Next tab (⌥})" })
keymap.set("n", "<A-{>", "<cmd>tabp<CR>", { desc = "Previous tab (⌥{)" })
keymap.set("n", "<A-1>", "1gt", { desc = "Tab 1 (⌥1)" })
keymap.set("n", "<A-2>", "2gt", { desc = "Tab 2 (⌥2)" })
keymap.set("n", "<A-3>", "3gt", { desc = "Tab 3 (⌥3)" })
keymap.set("n", "<A-4>", "4gt", { desc = "Tab 4 (⌥4)" })
keymap.set("n", "<A-5>", "5gt", { desc = "Tab 5 (⌥5)" })

-- ═══════════════════════════════════════════════════════════════
-- 🔍 SEARCH AND FIND (Leader-based for safety)
-- ═══════════════════════════════════════════════════════════════

-- Find and replace
keymap.set("n", "<leader>/", "/", { desc = "Search" })

-- Find with Option
keymap.set("n", "<A-/>", "/", { desc = "Find (⌥/)" })
keymap.set("n", "<A-n>", "n", { desc = "Next match (⌥N)" })
keymap.set("n", "<A-N>", "N", { desc = "Previous match (⌥⇧N)" })

-- Clear search highlights
keymap.set("n", "<Esc>", "<cmd>nohl<CR>", { desc = "Clear search highlights" })
keymap.set("n", "<leader>nh", "<cmd>nohl<CR>", { desc = "Clear highlights" })

-- ═══════════════════════════════════════════════════════════════
-- ✂️ EDITING WITH OPTION KEYS
-- ═══════════════════════════════════════════════════════════════

-- Select all (Leader+A for safety)
keymap.set("n", "<leader>a", "ggVG", { desc = "Select all" })
keymap.set("n", "<A-a>", "ggVG", { desc = "Select all (⌥A)" })

-- Duplicate line/selection
keymap.set("n", "<A-D>", "yyp", { desc = "Duplicate line (⌥⇧D)" })
keymap.set("v", "<A-D>", "y'>p", { desc = "Duplicate selection (⌥⇧D)" })

-- Delete operations (to void register, won't pollute clipboard)
keymap.set("n", "<A-x>", '"_dd', { desc = "Delete line without yank (⌥X)" })
keymap.set("v", "<A-x>", '"_d', { desc = "Delete selection without yank (⌥X)" })

-- Line manipulation (mini.move handles <A-J>/<A-K> for move up/down)
-- These are kept as alternative leader-based mappings
keymap.set("n", "<leader>mj", ":m .+1<CR>==", { desc = "Move line down" })
keymap.set("n", "<leader>mk", ":m .-2<CR>==", { desc = "Move line up" })
keymap.set("v", "<leader>mj", ":m '>+1<CR>gv=gv", { desc = "Move selection down" })
keymap.set("v", "<leader>mk", ":m '<-2<CR>gv=gv", { desc = "Move selection up" })

-- Indent/Unindent (use >> and << in normal mode, Tab in visual)
keymap.set("v", "<Tab>", ">gv", { desc = "Indent" })
keymap.set("v", "<S-Tab>", "<gv", { desc = "Unindent" })
-- Removed <A-[> and <A-]> indent mappings - they conflict with buffer navigation

-- ═══════════════════════════════════════════════════════════════
-- 🔧 WINDOW MANAGEMENT
-- ═══════════════════════════════════════════════════════════════

-- Split windows with leader
keymap.set("n", "<leader>sv", "<C-w>v", { desc = "Split vertically" })
keymap.set("n", "<leader>sh", "<C-w>s", { desc = "Split horizontally" })
keymap.set("n", "<leader>se", "<C-w>=", { desc = "Equal windows" })
keymap.set("n", "<leader>sx", "<cmd>close<CR>", { desc = "Close split" })

-- Split with Option
keymap.set("n", "<A-\\>", "<C-w>v", { desc = "Split vertically (⌥\\)" })
keymap.set("n", "<A-->", "<C-w>s", { desc = "Split horizontally (⌥-)" })

-- Window navigation with Option+HJKL (Vim-style)
keymap.set("n", "<A-h>", "<C-w>h", { desc = "Focus left window (⌥H)" })
keymap.set("n", "<A-j>", "<C-w>j", { desc = "Focus down window (⌥J)" })
keymap.set("n", "<A-k>", "<C-w>k", { desc = "Focus up window (⌥K)" })
keymap.set("n", "<A-l>", "<C-w>l", { desc = "Focus right window (⌥L)" })

-- Resize windows with Option+Shift
keymap.set("n", "<A-S-h>", "<C-w>5<", { desc = "Decrease width (⌥⇧H)" })
keymap.set("n", "<A-S-l>", "<C-w>5>", { desc = "Increase width (⌥⇧L)" })
keymap.set("n", "<A-S-k>", "<C-w>5-", { desc = "Decrease height (⌥⇧K)" })
keymap.set("n", "<A-S-j>", "<C-w>5+", { desc = "Increase height (⌥⇧J)" })
keymap.set("n", "<A-=>", "<C-w>=", { desc = "Equal windows (⌥=)" })

-- ═══════════════════════════════════════════════════════════════
-- 🎨 QUICK ACTIONS
-- ═══════════════════════════════════════════════════════════════

-- File operations - consolidated to avoid duplicates
-- Note: <leader>ff is the main file finder (defined in telescope.lua)
keymap.set("n", "<leader>P", "<cmd>Telescope commands<cr>", { desc = "Command palette" })

-- File explorers:
--   <leader>e  = NvimTree toggle (tree view, lua/plugins/nvim-tree.lua)
keymap.set("n", "<leader>e", "<cmd>NvimTreeToggle<cr>", { desc = "Toggle NvimTree (right)" })
keymap.set("n", "<leader>ef", "<cmd>NvimTreeFindFileToggle<CR>", { desc = "Find file in NvimTree" })
keymap.set("n", "<leader>ec", "<cmd>NvimTreeCollapse<CR>", { desc = "Collapse NvimTree" })
keymap.set("n", "<leader>er", "<cmd>NvimTreeRefresh<CR>", { desc = "Refresh NvimTree" })

-- Note: Buffer switcher <A-e> is defined in telescope.lua
-- Note: Recent files <A-r> is defined in telescope.lua
-- Note: Find in files <A-f> is defined in telescope.lua

-- Terminal toggle (Option+backtick works in most terminals)
keymap.set("n", "<A-`>", "<cmd>ToggleTerm<cr>", { desc = "Toggle terminal (⌥`)" })

-- Format buffer (Option shortcut)
keymap.set("n", "<A-F>", function()
  require("conform").format({ async = true, lsp_fallback = true })
end, { desc = "Format buffer (⌥F)" })

-- Format buffer (manual formatting when format-on-save is disabled)
keymap.set("n", "<leader>cf", function()
  require("conform").format({ async = true, lsp_fallback = true })
end, { desc = "Format buffer" })

-- ═══════════════════════════════════════════════════════════════
-- 📋 CLIPBOARD OPERATIONS
-- ═══════════════════════════════════════════════════════════════

-- System clipboard operations with Option (Mac-style)
keymap.set("v", "<A-c>", '"+y', { desc = "Copy to clipboard (⌥C)" })
keymap.set("v", "<A-C>", '"+x', { desc = "Cut to clipboard (⌥⇧C)" })
keymap.set({ "n", "v" }, "<A-v>", '"+p', { desc = "Paste from clipboard (⌥V)" })
keymap.set("i", "<A-v>", "<C-r>+", { desc = "Paste in insert (⌥V)" })

-- Leader-based clipboard operations
keymap.set("v", "<leader>y", '"+y', { desc = "Copy to clipboard" })

-- note: <a-x> is used for delete-without-yank (see above)

-- ═══════════════════════════════════════════════════════════════
-- 🔄 keep essential vim mappings
-- ═══════════════════════════════════════════════════════════════

-- Quick escape (jk is in keymaps.lua, adding jj as alternative)
keymap.set("i", "jj", "<ESC>", { desc = "Exit insert mode (jj)" })

-- better navigation in insert mode
keymap.set("i", "<c-h>", "<left>", { desc = "move left" })
keymap.set("i", "<C-l>", "<Right>", { desc = "Move right" })
keymap.set("i", "<C-j>", "<Down>", { desc = "Move down" })
keymap.set("i", "<C-k>", "<Up>", { desc = "Move up" })

-- Keep centered when jumping
keymap.set("n", "n", "nzzzv", { desc = "Next search result" })
keymap.set("n", "N", "Nzzzv", { desc = "Previous search result" })
keymap.set("n", "*", "*zzzv", { desc = "Search word under cursor" })
keymap.set("n", "#", "#zzzv", { desc = "Search word under cursor backward" })

-- Keep visual mode after indenting
keymap.set("v", "<", "<gv", { desc = "Unindent" })
keymap.set("v", ">", ">gv", { desc = "Indent" })

-- Don't yank on delete operations (use dd prefix to avoid conflict with LSP <leader>d for diagnostics)
keymap.set({ "n", "v" }, "<leader>dd", [["_d]], { desc = "Delete without yank" })
keymap.set({ "n", "v" }, "x", [["_x]], { desc = "Delete char without yank" })

-- Note: <leader>d is used by LSP for "show line diagnostics" (buffer-local in lspconfig.lua)

-- Better join lines
keymap.set("n", "J", "mzJ`z", { desc = "Join lines without moving cursor" })

-- Quick actions
keymap.set("n", "<leader>+", "<C-a>", { desc = "Increment number" })
keymap.set("n", "<leader>-", "<C-x>", { desc = "Decrement number" })

-- Macros: Q replays last macro (q to record, @ to play)
keymap.set("n", "Q", "@@", { desc = "Replay last macro" })

-- Toggle auto-save plugin
keymap.set("n", "<A-S-s>", function()
  vim.cmd("ASToggle")
  local ok, autocmds = pcall(vim.api.nvim_get_autocmds, { group = "AutoSave" })
  local enabled = ok and #autocmds > 0
  local state = enabled and "ON" or "OFF"
  vim.notify("Auto-save: " .. state, vim.log.levels.INFO)
end, { desc = "Toggle auto-save (⌥⇧S)" })
