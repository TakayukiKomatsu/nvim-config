return {
  "kevinhwang91/nvim-bqf",
  ft = "qf",
  opts = {
    preview = {
      border = "rounded",
      winblend = 0,
    },
    func_map = {
      open      = "<CR>",
      openc     = "o",
      tab       = "t",
      vsplit    = "v",
      split     = "s",
      fzffilter = "zf",  -- fuzzy filter the quickfix list
      pscrollup = "<C-b>",
      pscrolldown = "<C-f>",
    },
  },
}
