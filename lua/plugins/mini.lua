-- Intentional exception to the one-file-per-plugin rule: this file groups the
-- `mini.nvim` module family (icons, move, splitjoin, bracketed, operators,
-- bufremove, clue, trailspace, indentscope). They share an upstream and a
-- design philosophy, so keeping them together makes the opt-in surface easier
-- to scan. Do not split unless a single module grows substantially.
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
      indent = { suffix = "" }, -- Disabled: mini.indentscope uses [i/]i
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

  -- Mini.bufremove - Delete buffers while preserving window layout
  {
    "nvim-mini/mini.bufremove",
    version = false,
    keys = {
      {
        "<leader>bd",
        function()
          require("mini.bufremove").delete(0, false)
        end,
        desc = "Delete buffer",
      },
      {
        "<leader>bw",
        function()
          require("mini.bufremove").wipeout(0, false)
        end,
        desc = "Wipeout buffer",
      },
    },
    opts = {
      silent = true,
    },
  },

  -- Mini.clue - Prefix key hints without relying on timeoutlen
  {
    "nvim-mini/mini.clue",
    version = false,
    event = "VeryLazy",
    config = function()
      local miniclue = require("mini.clue")

      miniclue.setup({
        triggers = {
          { mode = { "n", "x" }, keys = "<Leader>" },
          { mode = "n", keys = "[" },
          { mode = "n", keys = "]" },
          { mode = { "n", "x" }, keys = "g" },
          { mode = { "n", "x" }, keys = "'" },
          { mode = { "n", "x" }, keys = "`" },
          { mode = { "n", "x" }, keys = '"' },
          { mode = { "i", "c" }, keys = "<C-r>" },
          { mode = "n", keys = "<C-w>" },
          { mode = { "n", "x" }, keys = "z" },
        },
        clues = {
          miniclue.gen_clues.square_brackets(),
          miniclue.gen_clues.g(),
          miniclue.gen_clues.marks(),
          miniclue.gen_clues.registers(),
          miniclue.gen_clues.windows(),
          miniclue.gen_clues.z(),

          { mode = "n", keys = "<Leader><Tab>", desc = "+tabs" },
          { mode = { "n", "x" }, keys = "<Leader>b", desc = "+buffers" },
          { mode = "n", keys = "<Leader>c", desc = "+code" },
          { mode = "n", keys = "<Leader>d", desc = "+debug" },
          { mode = "n", keys = "<Leader>e", desc = "+explorer" },
          { mode = "n", keys = "<Leader>f", desc = "+find" },
          { mode = "n", keys = "<Leader>g", desc = "+git" },
          { mode = "n", keys = "<Leader>h", desc = "+harpoon" },
          { mode = "n", keys = "<Leader>j", desc = "+java" },
          { mode = "n", keys = "<Leader>l", desc = "+lists" },
          { mode = "n", keys = "<Leader>m", desc = "+edit" },
          { mode = "n", keys = "<Leader>n", desc = "+npm" },
          { mode = "n", keys = "<Leader>q", desc = "+quit / quickfix / session" },
          { mode = "n", keys = "<Leader>r", desc = "+refactor / rust" },
          { mode = "n", keys = "<Leader>s", desc = "+split / search" },
          { mode = "n", keys = "<Leader>t", desc = "+test" },
          { mode = "n", keys = "<Leader>u", desc = "+ui / utils" },
          { mode = "n", keys = "<Leader>x", desc = "+trouble" },
          { mode = "n", keys = "<Leader>z", desc = "+zen" },
        },
        window = {
          delay = 200,
          config = {
            border = "rounded",
            width = "auto",
          },
        },
      })
    end,
  },

  -- Mini.trailspace - Highlight and trim trailing whitespace
  {
    "nvim-mini/mini.trailspace",
    version = false,
    event = { "BufReadPre", "BufNewFile" },
    keys = {
      {
        "<leader>uS",
        function()
          MiniTrailspace.trim()
        end,
        desc = "Trim trailing whitespace",
      },
      {
        "<leader>uL",
        function()
          MiniTrailspace.trim_last_lines()
        end,
        desc = "Trim trailing blank lines",
      },
    },
    opts = {
      only_in_normal_buffers = true,
    },
  },

  -- Mini.indentscope - Active indent scope with motions and textobjects
  {
    "nvim-mini/mini.indentscope",
    version = false,
    event = "LazyFile",
    opts = function()
      return {
        symbol = "│",
        options = { try_as_border = true },
        draw = {
          animation = require("mini.indentscope").gen_animation.none(),
        },
      }
    end,
    init = function()
      vim.api.nvim_create_autocmd("FileType", {
        pattern = {
          "Trouble",
          "alpha",
          "dashboard",
          "fzf",
          "help",
          "lazy",
          "mason",
          "neo-tree",
          "notify",
          "qf",
          "sidekick_terminal",
          "snacks_dashboard",
          "snacks_notif",
          "snacks_terminal",
          "snacks_win",
          "trouble",
        },
        callback = function()
          vim.b.miniindentscope_disable = true
        end,
      })

      vim.api.nvim_create_autocmd("User", {
        pattern = "SnacksDashboardOpened",
        callback = function(data)
          vim.b[data.buf].miniindentscope_disable = true
        end,
      })
    end,
  },
}
