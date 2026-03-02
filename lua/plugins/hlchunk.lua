return {
  "shellRaining/hlchunk.nvim",
  event = { "BufReadPre", "BufNewFile" },
  opts = {
    -- Highlight current scope/block (like a bracket matcher for indent blocks)
    chunk = {
      enable = true,
      style = {
        { fg = "#806d9e" }, -- muted purple for current scope
      },
      chars = {
        horizontal_line = "─",
        vertical_line = "│",
        left_top = "╭",
        left_bottom = "╰",
        right_arrow = "─",
      },
    },

    -- Rainbow indent guides
    indent = {
      enable = true,
      chars = { "│" },
      style = {
        "#E06C75", -- red
        "#E5C07B", -- yellow
        "#61AFEF", -- blue
        "#D19A66", -- amber
        "#98C379", -- green
        "#C678DD", -- purple
        "#56B6C2", -- cyan
      },
    },

    line_num = { enable = false },
    blank = { enable = false },
  },
}
