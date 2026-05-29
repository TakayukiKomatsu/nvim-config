-- snacks.picker — replaces telescope.nvim (and telescope-fzf-native / live-grep-args).
-- Picker keymaps mirror the old telescope.lua surface; LSP picker keys live in
-- lua/plugins/lsp/lspconfig.lua. snacks already maps <c-j>/<c-k> (nav) and <c-q>
-- (send to quickfix) by default, so only the Mac-style <A-*> keys are added here.
return {
  "folke/snacks.nvim",
  opts = {
    picker = {
      layout = { preset = "telescope" }, -- familiar prompt-on-top + side preview
      sources = {
        files = {
          -- Mac noise to ignore when searching outside a git project (rg already
          -- honors .gitignore inside projects).
          exclude = { "node_modules", ".git", "Library", "*.app", "*.dmg", "*.pkg", ".Trash" },
        },
      },
      win = {
        input = {
          keys = {
            -- Mac-style Option navigation (mirrors the old telescope mappings)
            ["<a-j>"] = { "list_down", mode = { "i", "n" } },
            ["<a-k>"] = { "list_up", mode = { "i", "n" } },
            ["<a-q>"] = { "qflist", mode = { "i", "n" } },
            ["<a-w>"] = { "close", mode = { "i", "n" } },
          },
        },
      },
    },
  },
  -- stylua: ignore
  keys = {
    -- Meta / palettes
    { "<leader>P",  function() Snacks.picker.commands() end, desc = "Command palette" },
    { "<leader>fk", function() Snacks.picker.keymaps() end,  desc = "Find keymaps" },
    { "<leader>fm", function() Snacks.picker.marks() end,    desc = "Find marks" },

    -- Files
    { "<leader>ff", function() Snacks.picker.files() end,                           desc = "Find files in cwd" },
    { "<A-p>",      function() Snacks.picker.files() end,                           desc = "Quick open file (⌥P)" },
    { "<leader>fp", function() Snacks.picker.files({ hidden = true }) end,          desc = "Project files (incl. hidden)" },
    { "<leader>fg", function() Snacks.picker.git_files({ untracked = true }) end,   desc = "Git files" },
    { "<leader>fr", function() Snacks.picker.recent() end,                          desc = "Recent files" },
    { "<A-r>",      function() Snacks.picker.recent({ filter = { cwd = true } }) end, desc = "Recent files (cwd) (⌥R)" },

    -- Grep
    { "<leader>fs", function() Snacks.picker.grep() end,      desc = "Grep in cwd (live)" },
    { "<leader>fs", function() Snacks.picker.grep_word() end, mode = "x", desc = "Grep selection" },
    { "<A-f>",      function() Snacks.picker.grep() end,      desc = "Find in files (⌥F)" },
    { "<leader>fc", function() Snacks.picker.grep_word() end, desc = "Grep word under cursor" },
    { "<leader>fw", function() Snacks.picker.grep_word() end, desc = "Grep word under cursor" },
    { "<leader>fW", function() Snacks.picker.grep({ search = vim.fn.expand("<cWORD>"), live = false }) end, desc = "Grep WORD under cursor" },
    { "<leader>f/", function() Snacks.picker.grep({ ft = vim.bo.filetype }) end, desc = "Grep in current filetype" },
    { "<leader>fS", function()
      vim.ui.input({ prompt = "Grep glob (e.g. *.lua): " }, function(g)
        if g and g ~= "" then Snacks.picker.grep({ glob = g }) else Snacks.picker.grep() end
      end)
    end, desc = "Grep with glob filter" },

    -- Buffers (snacks provides native `dd` / <c-x> delete; mru via sort_lastused)
    { "\\",         function() Snacks.picker.buffers({ current = false }) end, desc = "List open buffers" },
    { "<A-e>",      function() Snacks.picker.buffers({ current = false }) end, desc = "Switch buffer (⌥E)" },
    { "<leader>fb", function() Snacks.picker.buffers({ current = false }) end, desc = "Buffers" },
    { "<leader>fB", function() Snacks.picker.buffers() end,                    desc = "All buffers (incl. current)" },

    -- LSP symbol pickers
    { "<leader>fa", function() Snacks.picker.lsp_symbols() end,           desc = "Document symbols" },
    { "<leader>fY", function() Snacks.picker.lsp_workspace_symbols() end, desc = "Workspace symbols" },
    { "<leader>fi", function() Snacks.picker.lsp_implementations() end,   desc = "Implementations" },
    { "<leader>fT", function() Snacks.picker.lsp_type_definitions() end,  desc = "Type definitions" },

    -- Todos (snacks has no todo source → use Trouble's todo view)
    { "<leader>ft", "<cmd>Trouble todo toggle<cr>", desc = "Find todos (Trouble)" },
  },
}
