return {
  "stevearc/dressing.nvim",
  event = "VeryLazy",
  opts = {
    input = {
      enabled = true,
      default_prompt = "➤ ",
      border = "rounded",
      relative = "cursor",
      prefer_width = 50,
      win_options = {
        winblend = 0,
      },
    },
    select = {
      enabled = true,
      backend = { "builtin" },
      builtin = {
        border = "rounded",
        win_options = {
          winblend = 0,
        },
      },
    },
  },
}
