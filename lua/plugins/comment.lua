-- Disabled: LazyVim uses ts-comments.nvim which is better maintained
-- and already handles tsx, jsx, html with treesitter context
-- Use gc/gcc to toggle comments (same keymaps)
return {
  "numToStr/Comment.nvim",
  enabled = false,
}
