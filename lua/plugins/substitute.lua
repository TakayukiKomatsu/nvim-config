return {
  "gbprod/substitute.nvim",
  keys = {
    { "<leader>ms", function() require("substitute").operator() end, desc = "Substitute with motion" },
    { "<leader>ml", function() require("substitute").line() end,     desc = "Substitute line" },
    { "<leader>mS", function() require("substitute").eol() end,      desc = "Substitute to end of line" },
    { "<leader>ms", function() require("substitute").visual() end,   mode = "x", desc = "Substitute in visual mode" },
  },
  opts = {},
}
