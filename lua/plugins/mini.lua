return {
  -- Mini.icons
  {
    "nvim-mini/mini.icons",
    version = false,
    config = function()
      require("mini.icons").setup()
    end,
  },

  -- Mini.move - Move lines/blocks with Alt+hjkl
  {
    "nvim-mini/mini.move",
    version = false,
    event = "VeryLazy",
    opts = {
      mappings = {
        -- Move visual selection in Visual mode
        left = "<A-H>",
        right = "<A-L>",
        down = "<A-J>",
        up = "<A-K>",
        -- Move current line in Normal mode
        line_left = "<A-H>",
        line_right = "<A-L>",
        line_down = "<A-J>",
        line_up = "<A-K>",
      },
    },
  },

  -- Mini.splitjoin - Toggle between single line and multiline
  {
    "nvim-mini/mini.splitjoin",
    version = false,
    keys = {
      { "<leader>sj", function() require("mini.splitjoin").toggle() end, desc = "Toggle split/join" },
    },
    opts = {
      mappings = {
        toggle = "", -- We define our own above (<leader>sj)
      },
    },
  },

  -- Mini.bracketed - Navigate with [/] brackets
  {
    "nvim-mini/mini.bracketed",
    version = false,
    event = "VeryLazy",
    opts = {
      buffer = { suffix = "b", options = {} },
      comment = { suffix = "c", options = {} },
      conflict = { suffix = "x", options = {} },
      diagnostic = { suffix = "d", options = {} },
      file = { suffix = "f", options = {} },
      indent = { suffix = "i", options = {} },
      jump = { suffix = "j", options = {} },
      location = { suffix = "l", options = {} },
      oldfile = { suffix = "o", options = {} },
      quickfix = { suffix = "q", options = {} },
      treesitter = { suffix = "" }, -- Disabled: [t/]t used by todo-comments
      undo = { suffix = "u", options = {} },
      window = { suffix = "w", options = {} },
      yank = { suffix = "y", options = {} },
    },
  },

  -- Mini.operators - Text operators (evaluate, exchange, replace, sort)
  {
    "nvim-mini/mini.operators",
    version = false,
    event = "VeryLazy",
    opts = {
      evaluate = { prefix = "g=" }, -- g= to evaluate math expressions
      exchange = { prefix = "gX" }, -- gX to exchange (gx opens links)
      multiply = { prefix = "gm" }, -- gm to multiply/duplicate
      replace = { prefix = "" }, -- Disabled (substitute.nvim handles this)
      sort = { prefix = "" }, -- Disabled (gS is Flash treesitter)
    },
  },
}