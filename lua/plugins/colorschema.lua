-- Active colorscheme: witch
-- To switch: see lua/colorschemes-archive.lua for ready-to-use specs
return {
  {
    "sontungexpt/witch",
    priority = 1000,
    lazy = false,
    opts = {
      dim_inactive = { enabled = false },
    },
    config = function(_, opts)
      require("witch").setup(opts)
      vim.cmd.colorscheme("witch-dark")
      require("config.dim-inactive").setup()
    end,
  },
}
