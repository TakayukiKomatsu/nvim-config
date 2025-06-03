return {
  { "echasnovski/mini.nvim", version = false },
  {
    "echasnovski/mini.icons",
    version = false,
    config = function()
      require("mini.icons").setup()
    end,
  },
  {
    "echasnovski/mini.files",
    version = false,
    config = function()
      require("mini.files").setup({})
    end,
    keys = {
      {
        "<leader>mf",
        function()
          require("mini.files").open()
        end,
        desc = "Open Mini.files",
      },
    },
  },
  { "echasnovski/mini.nvim", version = false },
}
