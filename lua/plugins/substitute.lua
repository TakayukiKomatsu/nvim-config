return {
  "gbprod/substitute.nvim",
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    local substitute = require("substitute")

    substitute.setup()

    -- set keymaps
    local keymap = vim.keymap -- for conciseness

    keymap.set("n", "<leader>ms", substitute.operator, { desc = "Substitute with motion" })
    keymap.set("n", "<leader>ml", substitute.line, { desc = "Substitute line" })
    keymap.set("n", "<leader>mS", substitute.eol, { desc = "Substitute to end of line" })
    keymap.set("x", "<leader>ms", substitute.visual, { desc = "Substitute in visual mode" })
  end,
}
