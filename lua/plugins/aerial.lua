return {
  "stevearc/aerial.nvim",
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    "nvim-tree/nvim-web-devicons",
  },
  keys = {
    { "<leader>O",  "<cmd>AerialToggle<cr>",    desc = "Toggle outline (aerial)" },
    { "<leader>cs", "<cmd>Telescope aerial<cr>", desc = "Symbol search (aerial)" },
    { "[a", "<cmd>AerialPrev<cr>", desc = "Prev symbol" },
    { "]a", "<cmd>AerialNext<cr>", desc = "Next symbol" },
  },
  opts = {
    backends = { "lsp", "treesitter", "markdown", "man" },
    layout = {
      default_direction = "prefer_right",
      min_width = 25,
      max_width = { 40, 0.2 },
    },
    show_guides = true,
    guides = {
      mid_item   = "├─ ",
      last_item  = "└─ ",
      nested_top = "│  ",
      whitespace = "   ",
    },
    attach_mode = "global",
    filter_kind = false, -- show all symbol kinds
  },
  config = function(_, opts)
    require("aerial").setup(opts)
    require("telescope").load_extension("aerial")
  end,
}
