-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here

vim.diagnostic.config({
  float = { border = "rounded" },
  severity_sort = true,
  virtual_text = {
    prefix = "●",
  },
})
