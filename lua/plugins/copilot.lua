return {
  "zbirenbaum/copilot.lua",
  optional = true,
  opts = function(_, opts)
    opts.suggestion = vim.tbl_deep_extend("force", opts.suggestion or {}, {
      enabled = false,
      auto_trigger = false,
      keymap = {
        accept = false,
        next = false,
        prev = false,
      },
    })
  end,
}
