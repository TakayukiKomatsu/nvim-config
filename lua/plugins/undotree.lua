return {
  "mbbill/undotree",

  config = function()
    vim.keymap.set("n", "<leader>j", vim.cmd.UndotreeToggle, { desc = "Toggle undotree" })
  end,
}
