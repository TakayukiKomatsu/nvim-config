-- Intentional exception file:
-- shared foundational plugins that do not justify their own standalone spec files yet.
-- Keep this file small and limited to truly cross-cutting dependencies.
return {
  "nvim-lua/plenary.nvim", -- lua functions that many plugins use
  "christoomey/vim-tmux-navigator", -- tmux & split window navigation
}
