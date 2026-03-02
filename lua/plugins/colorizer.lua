-- Show colors inline (#ff0000 -> red highlight)
return {
  {
    "NvChad/nvim-colorizer.lua",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      filetypes = {
        "*", -- Highlight all files, but customize some others.
        css = { rgb_fn = true }, -- Enable parsing rgb(...) functions in css.
        scss = { rgb_fn = true },
        sass = { rgb_fn = true },
        html = { names = false }, -- Disable parsing "names" like Blue or gray
        "!lazy", -- Exclude lazy.nvim UI
      },
      user_default_options = {
        RGB = true, -- #RGB hex codes
        RRGGBB = true, -- #RRGGBB hex codes
        names = false, -- "Name" codes like Blue or red (can be noisy)
        RRGGBBAA = true, -- #RRGGBBAA hex codes
        AARRGGBB = true, -- 0xAARRGGBB hex codes
        rgb_fn = false, -- CSS rgb() and rgba() functions
        hsl_fn = false, -- CSS hsl() and hsla() functions
        css = false, -- Enable all CSS features: rgb_fn, hsl_fn, names, RGB, RRGGBB
        css_fn = false, -- Enable all CSS *functions*: rgb_fn, hsl_fn
        -- Available modes for `mode`: foreground, background,  virtualtext
        mode = "background", -- Set the display mode (Mac-friendly: background highlights)
        -- Available methods are false / true / "normal" / "lsp" / "both"
        tailwind = true, -- Enable tailwind colors (e.g., bg-blue-500)
        sass = { enable = true, parsers = { "css" } }, -- Enable sass colors
        virtualtext = "■", -- Character to show in virtual text mode
        -- update color values even if buffer is not focused
        always_update = false,
      },
      -- all the sub-options of filetypes apply to buftypes
      buftypes = {},
      suppress_deprecation = true,
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
