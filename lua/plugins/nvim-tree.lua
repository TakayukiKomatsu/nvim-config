return {
  "nvim-tree/nvim-tree.lua",
  lazy = true,
  dependencies = "nvim-tree/nvim-web-devicons",
  cmd = {
    "NvimTreeOpen",
    "NvimTreeToggle",
    "NvimTreeFocus",
    "NvimTreeFindFile",
    "NvimTreeFindFileToggle",
    "NvimTreeCollapse",
    "NvimTreeRefresh",
  },
  keys = {
    { "<leader>e", "<cmd>NvimTreeToggle<cr>", desc = "Toggle NvimTree (right)" },
    { "<leader>ef", "<cmd>NvimTreeFindFileToggle<CR>", desc = "Find file in NvimTree" },
    { "<leader>ec", "<cmd>NvimTreeCollapse<CR>", desc = "Collapse NvimTree" },
    { "<leader>er", "<cmd>NvimTreeRefresh<CR>", desc = "Refresh NvimTree" },
    {
      "<leader>eg",
      function()
        require("nvim-tree.api").tree.toggle_gitignore_filter()
      end,
      desc = "Toggle git-ignored files (NvimTree)",
    },
  },
  init = function()
    -- Load nvim-tree at startup only when launched on a directory (hijack_directories handles the rest)
    vim.api.nvim_create_autocmd("VimEnter", {
      once = true,
      callback = function(ev)
        local path = vim.fn.argv(0)
        if type(path) == "string" and path ~= "" and vim.fn.isdirectory(path) == 1 then
          require("lazy").load({ plugins = { "nvim-tree.lua" } })
        end
      end,
    })
  end,
  config = function()
    require("nvim-tree").setup({
      hijack_directories = {
        enable = true,   -- open nvim-tree instead of netrw when opening a directory
        auto_open = true,
      },
      view = {
        width = 35,
        side = "right",
        relativenumber = true,
      },
      -- change folder arrow icons
      renderer = {
        indent_markers = {
          enable = true,
        },
        icons = {
          glyphs = {
            folder = {
              arrow_closed = "", -- arrow when folder is closed
              arrow_open = "", -- arrow when folder is open
            },
          },
        },
      },
      -- disable window_picker for
      -- explorer to work well with
      -- window splits
      actions = {
        open_file = {
          window_picker = {
            enable = false,
          },
        },
      },
      filters = {
        custom = { ".DS_Store", "node_modules", ".git" },
        git_ignored = true,
      },
    })

  end,
}
