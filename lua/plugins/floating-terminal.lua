return {
  {
    "akinsho/toggleterm.nvim",
    cmd = "ToggleTerm",
    keys = {
      { "<A-`>", "<cmd>ToggleTerm<cr>", desc = "Toggle terminal" },
      { "<leader>T", "<cmd>ToggleTerm<cr>", desc = "Toggle terminal" },
    },
    opts = {
      direction = "float",
      shade_filetypes = {},
      hide_numbers = true,
      insert_mappings = true,
      terminal_mappings = true,
      start_in_insert = true,
      close_on_exit = true,
      float_opts = {
        border = "rounded",
        width = function() return math.floor(vim.o.columns * 0.85) end,
        height = function() return math.floor(vim.o.lines * 0.8) end,
        winblend = 0,
      },
    },
    config = function(_, opts)
      require("toggleterm").setup(opts)

      -- Better terminal keymaps
      local function set_terminal_keymaps()
        local term_opts = { buffer = 0, silent = true }
        -- Easy ways to close/toggle terminal from inside
        vim.keymap.set("t", "<A-`>", [[<Cmd>ToggleTerm<CR>]], term_opts)
        vim.keymap.set("t", "<leader>T", [[<C-\><C-n><Cmd>ToggleTerm<CR>]], term_opts)
        vim.keymap.set("t", "<Esc><Esc>", [[<C-\><C-n>]], term_opts) -- Double Esc to exit terminal mode
        vim.keymap.set("t", "<C-q>", [[<Cmd>ToggleTerm<CR>]], term_opts) -- Ctrl+Q to close
        -- Window navigation from terminal
        vim.keymap.set("t", "<C-h>", [[<Cmd>wincmd h<CR>]], term_opts)
        vim.keymap.set("t", "<C-j>", [[<Cmd>wincmd j<CR>]], term_opts)
        vim.keymap.set("t", "<C-k>", [[<Cmd>wincmd k<CR>]], term_opts)
        vim.keymap.set("t", "<C-l>", [[<Cmd>wincmd l<CR>]], term_opts)
      end

      vim.api.nvim_create_autocmd("TermOpen", {
        pattern = "term://*toggleterm#*",
        callback = function()
          set_terminal_keymaps()
        end,
      })
    end,
  },
}
