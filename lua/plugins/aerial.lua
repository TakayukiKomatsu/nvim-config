return {
  "stevearc/aerial.nvim",
  lazy = true,
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    "nvim-tree/nvim-web-devicons",
  },
  keys = {
    { "<leader>aa", "<cmd>AerialToggle<cr>",                       desc = "Toggle outline" },
    { "<leader>af", "<cmd>AerialToggle float<cr>",                 desc = "Toggle floating outline" },
    { "<leader>ao", "<cmd>AerialOpen<cr>",                         desc = "Open outline" },
    { "<leader>ac", "<cmd>AerialClose<cr>",                        desc = "Close outline" },
    { "<leader>an", "<cmd>AerialNavToggle<cr>",                    desc = "Toggle nav popup" },
    { "<leader>ai", "<cmd>AerialInfo<cr>",                         desc = "Aerial info" },
    { "<leader>as", function() Snacks.picker.lsp_symbols() end,    desc = "Symbol search" },
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
  end,
}
