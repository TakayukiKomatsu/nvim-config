-- UI toggles: auto-save, inlay hints, diagnostic display.
local keymap = vim.keymap

-- Auto-save plugin
keymap.set("n", "<A-S-s>", function()
  vim.cmd("ASToggle")
  local ok, autocmds = pcall(vim.api.nvim_get_autocmds, { group = "AutoSave" })
  local enabled = ok and #autocmds > 0
  vim.notify("Auto-save: " .. (enabled and "ON" or "OFF"), vim.log.levels.INFO)
end, { desc = "Toggle auto-save (⌥⇧S)" })

-- LSP inlay hints (buffer-local)
keymap.set("n", "<leader>uI", function()
  local enabled = vim.lsp.inlay_hint.is_enabled({ bufnr = 0 })
  vim.lsp.inlay_hint.enable(not enabled, { bufnr = 0 })
  vim.notify("Inlay hints: " .. (enabled and "OFF" or "ON"), vim.log.levels.INFO)
end, { desc = "Toggle inlay hints (buffer)" })

-- Diagnostic display: virtual_text (compact) ↔ virtual_lines (verbose)
keymap.set("n", "<leader>uV", function()
  local cfg = vim.diagnostic.config() or {}
  local using_lines = cfg.virtual_lines ~= nil and cfg.virtual_lines ~= false
  if using_lines then
    vim.diagnostic.config({ virtual_lines = false, virtual_text = { prefix = "●" } })
    vim.notify("Diagnostics: virtual_text", vim.log.levels.INFO)
  else
    vim.diagnostic.config({ virtual_lines = { current_line = false }, virtual_text = false })
    vim.notify("Diagnostics: virtual_lines", vim.log.levels.INFO)
  end
end, { desc = "Toggle diagnostic virtual_lines" })
