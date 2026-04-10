return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  opts = function(_, opts)
    -- Keep which-key available for plugins which register mappings via `wk.add()`,
    -- but let mini.clue handle the interactive prefix UI.
    opts.triggers = {}
    opts.notify = false
    opts.show_help = false
    opts.show_keys = false
    return opts
  end,
}
