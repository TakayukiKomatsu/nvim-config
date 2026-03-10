-- Disable LazyVim default plugins we don't use
return {
  { "nvim-neo-tree/neo-tree.nvim",  enabled = false }, -- using nvim-tree instead
  { "folke/tokyonight.nvim",        enabled = false }, -- using witch instead
  { "catppuccin/nvim",              enabled = false }, -- using witch instead
  { "numToStr/Comment.nvim",        enabled = false }, -- LazyVim uses ts-comments.nvim
}
