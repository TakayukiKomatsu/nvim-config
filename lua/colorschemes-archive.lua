-- Colorscheme archive
-- This file is NOT loaded by lazy.nvim (it's outside lua/plugins/).
--
-- To switch colorscheme:
--   1. Copy the desired spec below into lua/plugins/colorschema.lua
--   2. Disable witch (enabled = false) and remove its colorscheme from lazy.lua opts
--   3. :Lazy sync

return {

  -- Tokyo Night (classic dark, popular)
  {
    "folke/tokyonight.nvim",
    enabled = false,
    priority = 1000,
    lazy = false,
    opts = {
      style = "night",
      transparent = false,
      styles = {
        sidebars = "dark",
        floats = "dark",
      },
    },
    config = function(_, opts)
      require("tokyonight").setup(opts)
      vim.cmd("colorscheme tokyonight")
    end,
  },

  -- Catppuccin (soft pastel, multiple flavours)
  {
    "catppuccin/nvim",
    name = "catppuccin",
    enabled = false,
    priority = 1000,
    lazy = false,
    opts = {
      flavour = "mocha", -- latte, frappe, macchiato, mocha
    },
    config = function(_, opts)
      require("catppuccin").setup(opts)
      vim.cmd("colorscheme catppuccin")
    end,
  },

  -- Nightfox / Carbonfox
  {
    "EdenEast/nightfox.nvim",
    enabled = false,
    priority = 1000,
    lazy = false,
    config = function()
      vim.cmd("colorscheme carbonfox")
    end,
  },

  -- Neofusion (dark purple gradient)
  {
    "diegoulloao/neofusion.nvim",
    enabled = false,
    priority = 1000,
    lazy = false,
    config = function()
      require("neofusion").setup()
      vim.cmd("colorscheme neofusion")
    end,
  },

  -- Night Owl (VS Code Night Owl port)
  {
    "oxfist/night-owl.nvim",
    enabled = false,
    priority = 1000,
    lazy = false,
    config = function()
      require("night-owl").setup()
      vim.cmd("colorscheme night-owl")
    end,
  },

  -- Oxocarbon (IBM design, dark minimal)
  {
    "nyoom-engineering/oxocarbon.nvim",
    enabled = false,
    priority = 1000,
    lazy = false,
    config = function()
      vim.cmd("colorscheme oxocarbon")
    end,
  },

  -- Aura Dark
  {
    "baliestri/aura-theme",
    enabled = false,
    priority = 1000,
    lazy = false,
    config = function(plugin)
      vim.opt.rtp:append(plugin.dir .. "/packages/neovim")
      vim.cmd("colorscheme aura-dark")
    end,
  },

  -- OneDark Pro
  {
    "olimorris/onedarkpro.nvim",
    enabled = false,
    priority = 1000,
    lazy = false,
    config = function()
      vim.cmd("colorscheme onedark_dark")
    end,
  },

}
