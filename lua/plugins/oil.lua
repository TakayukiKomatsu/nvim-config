local function oil_or_current_dir()
  local ok, oil = pcall(require, "oil")
  local cwd = ok and oil.get_current_dir() or nil
  if cwd then
    return cwd
  end

  local file = vim.api.nvim_buf_get_name(0)
  return file ~= "" and vim.fn.fnamemodify(file, ":p:h") or vim.uv.cwd()
end

return {
  "stevearc/oil.nvim",
  lazy = true,
  cmd = "Oil",
  dependencies = { "nvim-mini/mini.icons" },
  keys = {
    {
      "<leader>oo",
      function()
        require("oil").open(vim.uv.cwd())
      end,
      desc = "Open Oil at launch cwd",
    },
    {
      "<leader>od",
      function()
        require("oil").open(oil_or_current_dir())
      end,
      desc = "Open Oil at current file dir",
    },

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
