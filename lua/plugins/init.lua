-- Intentional exception file:
-- shared foundational plugins that do not justify their own standalone spec files yet.
-- Keep this file small and limited to truly cross-cutting dependencies.
return {
  "nvim-lua/plenary.nvim", -- lua functions that many plugins use
  {
    "christoomey/vim-tmux-navigator",
    cmd = {
      "TmuxNavigateLeft",
      "TmuxNavigateDown",
      "TmuxNavigateUp",
      "TmuxNavigateRight",
      "TmuxNavigatePrevious",
    },
    keys = {
      { "<C-h>", "<cmd>TmuxNavigateLeft<cr>",  desc = "Navigate left (tmux/win)" },
      { "<C-j>", "<cmd>TmuxNavigateDown<cr>",  desc = "Navigate down (tmux/win)" },
      { "<C-k>", "<cmd>TmuxNavigateUp<cr>",    desc = "Navigate up (tmux/win)" },
      { "<C-l>", "<cmd>TmuxNavigateRight<cr>", desc = "Navigate right (tmux/win)" },
    },
  },
}
