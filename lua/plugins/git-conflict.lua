-- Git-conflict - Visual merge conflict resolution
return {
  "akinsho/git-conflict.nvim",
  version = "*",
  event = "BufReadPre",
  opts = {
    default_mappings = true, -- Use default mappings
    default_commands = true, -- Use default commands
    disable_diagnostics = false, -- Disable diagnostics in merge mode
    list_opener = "copen", -- command for opening quickfix
    highlights = {
      incoming = "DiffAdd",
      current = "DiffText",
    },
  },
  keys = {
    { "<leader>gco", "<cmd>GitConflictChooseOurs<CR>", desc = "Choose ours" },
    { "<leader>gct", "<cmd>GitConflictChooseTheirs<CR>", desc = "Choose theirs" },
    { "<leader>gcb", "<cmd>GitConflictChooseBoth<CR>", desc = "Choose both" },
    { "<leader>gc0", "<cmd>GitConflictChooseNone<CR>", desc = "Choose none" },
    { "[x", "<cmd>GitConflictPrevConflict<CR>", desc = "Prev conflict" },
    { "]x", "<cmd>GitConflictNextConflict<CR>", desc = "Next conflict" },
    { "<leader>gcq", "<cmd>GitConflictListQf<CR>", desc = "List conflicts" },
  },
}
