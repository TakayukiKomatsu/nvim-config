-- Show colors inline (#ff0000 -> red highlight)
return {
  {
    "NvChad/nvim-colorizer.lua",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      filetypes = {
        "*", -- Highlight all files, but customize some others.
        css = { parsers = { rgb = { enable = true } } }, -- Enable rgb(...) functions in css.
        scss = { parsers = { rgb = { enable = true } } },
        sass = { parsers = { rgb = { enable = true } } },
        html = { parsers = { names = { enable = false } } }, -- Disable parsing "names" like Blue or gray
        "!lazy", -- Exclude lazy.nvim UI
      },
      options = {
        parsers = {
          names = { enable = false }, -- "Name" codes like Blue or red (can be noisy)
          hex = {
            rgb = true, -- #RGB
            rrggbb = true, -- #RRGGBB
            rrggbbaa = true, -- #RRGGBBAA
            aarrggbb = true, -- 0xAARRGGBB
          },
          rgb = { enable = false }, -- CSS rgb() and rgba() functions
          hsl = { enable = false }, -- CSS hsl() and hsla() functions
          tailwind = { enable = true }, -- Tailwind colors (e.g., bg-blue-500)
          sass = { enable = true, parsers = { css = true } }, -- Sass variables/colors
        },
        display = {
          mode = "background", -- Available: background, foreground, virtualtext
          virtualtext = {
            char = "■",
          },
        },
        always_update = false,
      },
      -- all the sub-options of filetypes apply to buftypes
      buftypes = {},
    },
    keys = {
      {
        "<leader>uc",
        "<cmd>ColorizerToggle<cr>",
        desc = "Toggle Colorizer",
      },
    },
  },
}
