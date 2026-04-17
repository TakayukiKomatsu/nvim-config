-- Keymap loader.
--
-- Keymaps are split by feature under lua/config/keymaps/ for discoverability.
-- Plugin-coupled keys live in the plugin spec (keys = {...}) to preserve lazy loading.
--
-- Layer order:
--   1. Base Option-key / <leader> mappings registered here (all modes).
--   2. LSP buffer-local mappings via LspAttach (see lua/plugins/lsp/lspconfig.lua).
--   3. Plugin-local mappings via each plugin's keys spec.
local keymap = vim.keymap

-- Remove LazyVim default mappings we override (pcall in case the plugin isn't loaded yet).
pcall(keymap.del, "n", "<leader>e")
pcall(keymap.del, "n", "<C-down>")

for _, module in ipairs({
  "file",
  "navigation",
  "search",
  "editing",
  "window",
  "clipboard",
  "insert",
  "toggle",
}) do
  require("config.keymaps." .. module)
end
