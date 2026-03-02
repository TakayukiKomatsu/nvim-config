return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  opts = function(_, opts)
    opts.preset = "modern"
    opts.delay = 300
    opts.icons = {
      breadcrumb = "»",
      separator = "➜",
      group = "+",
    }

    opts.spec = opts.spec or {}
    vim.list_extend(opts.spec, {
      -- Keep only project-specific additions to avoid duplicating LazyVim groups.
      { "<leader>R", group = "rust" },
      { "<leader>rc", group = "crates (rust)" },
      { "<leader>ct", group = "typescript" },
      { "<leader>gc", group = "conflict" },
      { "<leader>T", desc = "terminal" },
      { "<A-s>", desc = "Save (⌥S)" },
      { "<A-F>", desc = "Format buffer (⌥F)" },
      { "<A-P>", desc = "Safe paste clipboard (⌥⇧P)" },
      { "<A-p>", desc = "Quick open file (⌥P)" },
      { "<A-r>", desc = "Recent files (⌥R)" },
      { "<A-e>", desc = "Switch buffer (⌥E)" },
    })
  end,
}
