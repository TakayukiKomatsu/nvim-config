-- Disable LazyVim default plugins we don't use
return {
  { "nvim-neo-tree/neo-tree.nvim",  enabled = false }, -- using nvim-tree instead
  { "folke/tokyonight.nvim",        enabled = false }, -- using witch instead
  { "catppuccin/nvim",              enabled = false }, -- using witch instead
  { "numToStr/Comment.nvim",        enabled = false }, -- LazyVim uses ts-comments.nvim
  { "shellRaining/hlchunk.nvim",    enabled = false }, -- trialing mini.indentscope instead
  { "mfussenegger/nvim-jdtls",      enabled = false }, -- replaced by nvim-java
}
