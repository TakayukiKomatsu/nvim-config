return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  opts = {
    preset = "modern",
    delay = 300,
    icons = {
      breadcrumb = "»",
      separator = "➜",
      group = "+",
    },
    spec = {
      -- Top-level groups
      { "<leader>b", group = "buffer" },
      { "<leader>c", group = "code" },
      { "<leader>O",  desc = "outline (aerial)" },
      { "<leader>cs", desc = "symbols (aerial)" },
      { "<leader>ct", group = "typescript" },
      { "<leader>d", group = "debug" },
      { "<leader>f", group = "find/file" },
      { "<leader>g", group = "git" },
      { "<leader>gc", group = "conflict" },
      { "<leader>h", group = "harpoon/hunk" },
      { "<leader>l", group = "location list" },
      { "<leader>m", group = "move/substitute" },
      { "<leader>n", group = "npm/package" },
      { "<leader>q", group = "quickfix/quit" },
      { "<leader>r", group = "refactor/rename" },
      { "<leader>R", group = "rust" },
      { "<leader>rc", group = "crates (rust)" },
      { "<leader>s", group = "split/search" },
      { "<leader>t", group = "test" },
      { "<leader>u", group = "ui/undo" },
      { "<leader>x", group = "trouble/diagnostics" },
      { "<leader>z", group = "zen" },
      { "<leader>T", desc = "terminal" },
      { "<leader><Tab>", group = "tabs" },

      -- Brackets navigation info
      { "[", group = "prev" },
      { "]", group = "next" },

      -- g prefix
      { "g", group = "goto/operators" },
      { "gs", desc = "flash jump" },
      { "gS", desc = "flash treesitter" },

      -- z prefix
      { "z", group = "fold" },

      -- Option key highlights (Mac terminal)
      { "<A-s>", desc = "Save (⌥S)" },
      { "<A-F>", desc = "Format buffer (⌥F)" },
      { "<A-P>", desc = "Safe paste clipboard (⌥⇧P)" },
      { "<A-S-s>", desc = "Toggle auto-save (⌥⇧S)" },
      { "<A-p>", desc = "Quick open file (⌥P)" },
      { "<A-r>", desc = "Recent files (⌥R)" },
      { "<A-e>", desc = "Switch buffer (⌥E)" },
    },
  },
}
