-- Autocmds are automatically loaded on the VeryLazy event.
-- LazyVim defaults: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua

-- Diagnostic display
vim.diagnostic.config({
  float = { border = "rounded" },
  severity_sort = true,
  virtual_text = {
    prefix = "●",
  },
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = " ",
      [vim.diagnostic.severity.WARN]  = " ",
      [vim.diagnostic.severity.HINT]  = "󰠠 ",
      [vim.diagnostic.severity.INFO]  = " ",
    },
  },
})

-- ═══════════════════════════════════════════════════════════════
-- Mac-specific autocommands
-- ═══════════════════════════════════════════════════════════════

local mac_group = vim.api.nvim_create_augroup("MacOptimizations", { clear = true })

-- GUI font for Mac GUI frontends (VimR, Neovide, etc.)
vim.api.nvim_create_autocmd("VimEnter", {
  group = mac_group,
  callback = function()
    if vim.fn.has("gui_running") == 1 then
      vim.o.guifont = "SF Mono:h14"
    end
  end,
  desc = "Set Mac-optimized GUI font",
})

-- Auto-reload files changed externally (Xcode, other Mac tools)
vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter", "CursorHold", "CursorHoldI" }, {
  group = mac_group,
  pattern = "*",
  command = "if mode() != 'c' | checktime | endif",
  desc = "Auto-reload files changed externally",
})

-- Terminal appearance: hide line numbers, disable scrolloff
vim.api.nvim_create_autocmd("TermOpen", {
  group = mac_group,
  pattern = "*",
  callback = function()
    vim.opt_local.number = false
    vim.opt_local.relativenumber = false
    vim.opt_local.scrolloff = 0
    vim.opt_local.sidescrolloff = 0
  end,
  desc = "Optimize terminal appearance",
})
