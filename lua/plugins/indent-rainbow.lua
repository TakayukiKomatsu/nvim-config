return {
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    event = "BufReadPost",
    config = function()
      local hl = vim.api.nvim_set_hl
      hl(0, "RainbowRed",    { fg = "#ff5874" })
      hl(0, "RainbowYellow", { fg = "#f0a421" })
      hl(0, "RainbowBlue",   { fg = "#629df2" })
      hl(0, "RainbowOrange", { fg = "#f99635" })
      hl(0, "RainbowGreen",  { fg = "#5bcf75" })
      hl(0, "RainbowViolet", { fg = "#b278ea" })
      hl(0, "RainbowCyan",   { fg = "#7dcfff" })
      require("ibl").setup({
        indent = {
          highlight = {
            "RainbowRed", "RainbowYellow", "RainbowBlue",
            "RainbowOrange", "RainbowGreen", "RainbowViolet", "RainbowCyan",
          },
          char = "│",
        },
        scope = { enabled = false }, -- ponytail: mini.indentscope handles scope line
      })
    end,
  },
  -- Disable snacks.indent — ibl replaces it
  {
    "folke/snacks.nvim",
    opts = {
      indent = { enabled = false },
    },
  },
}
