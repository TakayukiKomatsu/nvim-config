return {
  "stevearc/oil.nvim",
  lazy = true,
  cmd = "Oil",
  dependencies = { "nvim-mini/mini.icons" },
  keys = {
    { "<leader>o", "<cmd>Oil<cr>", desc = "Open Oil file editor" },
  },
  opts = {
    -- Keep nvim-tree as the primary/default explorer.
    default_file_explorer = false,
    columns = {
      "icon",
    },
    delete_to_trash = true,
    skip_confirm_for_simple_edits = true,
    watch_for_changes = true,
    view_options = {
      show_hidden = true,
      natural_order = true,
    },
    win_options = {
      signcolumn = "yes:2",
    },
    keymaps = {
      ["q"] = "actions.close",
      ["<C-c>"] = "actions.close",
      ["<CR>"] = "actions.select",
      ["<C-s>"] = "actions.select_split",
      ["<C-v>"] = "actions.select_vsplit",
      ["<C-t>"] = "actions.select_tab",
      ["-"] = "actions.parent",
      ["_"] = "actions.open_cwd",
      ["g."] = "actions.toggle_hidden",
      ["gs"] = "actions.change_sort",
      ["gx"] = "actions.open_external",
      ["g?"] = "actions.show_help",
    },
  },
}
