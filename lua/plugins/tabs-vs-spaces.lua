return {
  "tenxsoydev/tabs-vs-spaces.nvim",
  event = { "BufReadPre", "BufNewFile" },
  opts = {
    indentation = "auto", -- detects dominant style per buffer, highlights deviations
    highlight = { fg = "#E06C75", undercurl = true }, -- red undercurl for wrong indentation
    ignore = {
      filetypes = { "go" }, -- Go requires tabs; skip deviation check
      buftypes = { "acwrite", "help", "nofile", "nowrite", "quickfix", "terminal", "prompt" },
    },
  },
}
