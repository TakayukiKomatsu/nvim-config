-- Intentional exception file:
-- grouped upstream-plugin disables live here so maintainers can find opt-out decisions in one place.
-- Keep this file focused on explicit disable/replace decisions only.
return {
  { "nvim-neo-tree/neo-tree.nvim",  enabled = false }, -- using nvim-tree instead
  { "folke/tokyonight.nvim",        enabled = false }, -- using witch instead
  { "catppuccin/nvim",              enabled = false }, -- using witch instead
  { "numToStr/Comment.nvim",        enabled = false }, -- LazyVim uses ts-comments.nvim
  { "shellRaining/hlchunk.nvim",    enabled = false }, -- trialing mini.indentscope instead
  { "mfussenegger/nvim-jdtls",      enabled = false }, -- replaced by nvim-java
}
