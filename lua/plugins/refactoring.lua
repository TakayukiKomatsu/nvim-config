-- refactoring.nvim: Extract function, variable, inline, etc.
return {
  "ThePrimeagen/refactoring.nvim",
  lazy = true,
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter",
  },
  opts = {
    prompt_func_return_type = {
      go = true,
      cpp = true,
      c = true,
      java = true,
    },
    prompt_func_param_type = {
      go = true,
      cpp = true,
      c = true,
      java = true,
    },
  },
  keys = {
    -- Extract operations (visual mode)
    {
      "<leader>re",
      function() require("refactoring").refactor("Extract Function") end,
      mode = "x",
      desc = "Extract function",
    },
    {
      "<leader>rf",
      function() require("refactoring").refactor("Extract Function To File") end,
      mode = "x",
      desc = "Extract function to file",
    },
    {
      "<leader>rv",
      function() require("refactoring").refactor("Extract Variable") end,
      mode = "x",
      desc = "Extract variable",
    },

    -- Inline operations
    {
      "<leader>ri",
      function() require("refactoring").refactor("Inline Variable") end,
      mode = { "n", "x" },
      desc = "Inline variable",
    },
    {
      "<leader>rI",
      function() require("refactoring").refactor("Inline Function") end,
      mode = "n",
      desc = "Inline function",
    },

    -- Extract block (normal mode)
    {
      "<leader>rb",
      function() require("refactoring").refactor("Extract Block") end,
      mode = "n",
      desc = "Extract block",
    },
    {
      "<leader>rB",
      function() require("refactoring").refactor("Extract Block To File") end,
      mode = "n",
      desc = "Extract block to file",
    },

    -- Telescope picker for all refactors
    {
      "<leader>rr",
      function() require("telescope").extensions.refactoring.refactors() end,
      mode = { "n", "x" },
      desc = "Refactoring menu",
    },

    -- Debug print statements
    {
      "<leader>rp",
      function() require("refactoring").debug.printf({ below = false }) end,
      mode = "n",
      desc = "Debug print",
    },
    {
      "<leader>rP",
      function() require("refactoring").debug.print_var() end,
      mode = { "n", "x" },
      desc = "Debug print variable",
    },
    {
      "<leader>rc",
      function() require("refactoring").debug.cleanup({}) end,
      mode = "n",
      desc = "Cleanup debug prints",
    },
  },
  config = function(_, opts)
    require("refactoring").setup(opts)
    -- Load telescope extension
    pcall(function()
      require("telescope").load_extension("refactoring")
    end)
  end,
}
