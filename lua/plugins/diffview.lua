-- Diffview.nvim - Beautiful diff/merge views and file history
return {
  "sindrets/diffview.nvim",
  dependencies = { "nvim-lua/plenary.nvim" },
  cmd = { "DiffviewOpen", "DiffviewFileHistory", "DiffviewClose" },
  keys = {
    { "<leader>gd", "<cmd>DiffviewOpen<CR>", desc = "Open diff view" },
    { "<leader>gD", "<cmd>DiffviewOpen HEAD~1<CR>", desc = "Diff with last commit" },
    { "<leader>gh", "<cmd>DiffviewFileHistory %<CR>", desc = "File history (current)" },
    { "<leader>gH", "<cmd>DiffviewFileHistory<CR>", desc = "File history (all)" },
    { "<leader>gq", "<cmd>DiffviewClose<CR>", desc = "Close diff view" },
  },
  opts = {
    diff_binaries = false,
    enhanced_diff_hl = true,
    use_icons = true,
    icons = {
      folder_closed = "",
      folder_open = "",
    },
    signs = {
      fold_closed = "",
      fold_open = "",
      done = "",
    },
    view = {
      default = {
        layout = "diff2_horizontal",
        winbar_info = true,
      },
      merge_tool = {
        layout = "diff3_horizontal",
        disable_diagnostics = true,
        winbar_info = true,
      },
      file_history = {
        layout = "diff2_horizontal",
        winbar_info = true,
      },
    },
    file_panel = {
      listing_style = "tree",
      tree_options = {
        flatten_dirs = true,
        folder_statuses = "only_folded",
      },
      win_config = {
        position = "left",
        width = 35,
      },
    },
    file_history_panel = {
      log_options = {
        git = {
          single_file = {
            diff_merges = "combined",
            follow = true,
          },
          multi_file = {
            diff_merges = "first-parent",
          },
        },
      },
      win_config = {
        position = "bottom",
        height = 16,
      },
    },
    keymaps = {
      view = {
        { "n", "<tab>", "<cmd>DiffviewToggleFiles<CR>", { desc = "Toggle file panel" } },
        { "n", "q", "<cmd>DiffviewClose<CR>", { desc = "Close diffview" } },
      },
      file_panel = {
        { "n", "j", "<cmd>DiffviewFocusFiles<CR>j", { desc = "Next file" } },
        { "n", "k", "<cmd>DiffviewFocusFiles<CR>k", { desc = "Prev file" } },
        { "n", "q", "<cmd>DiffviewClose<CR>", { desc = "Close diffview" } },
      },
    },
  },
}
