return {
  "MagicDuck/grug-far.nvim",
  cmd = "GrugFar",
  keys = {
    {
      "<leader>sr",
      function() require("grug-far").open() end,
      desc = "Search & replace (grug-far)",
    },
    {
      "<leader>sr",
      function()
        require("grug-far").open({ prefills = { search = vim.fn.expand("<cword>") } })
      end,
      mode = "v",
      desc = "Search & replace selection",
    },
    {
      "<leader>sf",
      function()
        require("grug-far").open({ prefills = { paths = vim.fn.expand("%") } })
      end,
      desc = "Search & replace in current file",
    },
  },
  opts = {
    headerMaxWidth = 80,
  },
}
