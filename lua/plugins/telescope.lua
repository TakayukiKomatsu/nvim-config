-- Delete the highlighted buffer inside any Telescope buffer picker
local function delete_buf(prompt_bufnr)
  local action_state = require("telescope.actions.state")
  local current_picker = action_state.get_current_picker(prompt_bufnr)
  local entry = action_state.get_selected_entry()
  if not entry then
    return
  end
  local bufnr = entry.bufnr
  local ok = require("mini.bufremove").delete(bufnr, false)
  if ok then
    current_picker:delete_selection(function(e)
      return e.bufnr == bufnr
    end)
  end
end

return {
  "nvim-telescope/telescope.nvim",
  branch = "0.1.x",
  lazy = true,
  cmd = "Telescope",
  keys = {
    { "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Fuzzy find files in cwd" },
    { "<leader>fr", "<cmd>Telescope oldfiles<cr>", desc = "Fuzzy find recent files" },
    { "<leader>fs", "<cmd>Telescope live_grep<cr>", desc = "Find string in cwd" },
    { "<leader>fS", function()
      require("telescope").extensions.live_grep_args.live_grep_args()
    end, desc = "Find string (with args)" },
    { "<leader>fc", "<cmd>Telescope grep_string<cr>", desc = "Find string under cursor in cwd" },
    { "<leader>ft", "<cmd>TodoTelescope<cr>", desc = "Find todos" },
    { "<leader>fm", "<cmd>Telescope marks<cr>", desc = "Find marks" },
    { "<leader>fk", "<cmd>Telescope keymaps<cr>", desc = "Find keymaps" },
    { "<leader>fp", function()
      require("telescope.builtin").find_files({ prompt_title = "🚀 Project Files", cwd = vim.fn.getcwd(), hidden = true })
    end, desc = "Project files" },
    { "<leader>fg", function()
      require("telescope.builtin").git_files({ prompt_title = "📝 Git Files", show_untracked = true })
    end, desc = "Git files" },
    { "<leader>fw", function()
      local word = vim.fn.expand("<cword>")
      if word == "" then
        print("No word under cursor")
        return
      end
      require("telescope.builtin").grep_string({ search = word, prompt_title = "🎯 Word: '" .. word .. "'", word_match = "-w" })
    end, desc = "Search word under cursor" },
    { "<leader>fW", function()
      local word = vim.fn.expand("<cWORD>")
      if word == "" then
        print("No word under cursor")
        return
      end
      require("telescope.builtin").grep_string({ search = word, prompt_title = "🎯 WORD: '" .. word .. "'" })
    end, desc = "Search WORD under cursor" },
    { "<leader>f/", function()
      require("telescope").extensions.live_grep_args.live_grep_args({ default_text = "-t " .. vim.bo.filetype .. " " })
    end, desc = "Grep in current filetype" },
    { "<leader>fY", function()
      require("telescope.builtin").lsp_dynamic_workspace_symbols()
    end, desc = "Workspace symbols" },
    { "<leader>fa", function()
      require("telescope.builtin").lsp_document_symbols()
    end, desc = "Search document symbols" },
    { "\\", function()
      require("telescope.builtin").buffers({
        sort_mru = true,
        ignore_current_buffer = true,
        attach_mappings = function(_, map)
          map("n", "dd", delete_buf)
          map("i", "<C-d>", delete_buf)
          return true
        end,
      })
    end, desc = "Lists open buffers" },
    { "<leader>fb", function()
      require("telescope.builtin").buffers({
        prompt_title = "Buffers",
        sort_mru = true,
        ignore_current_buffer = true,
        attach_mappings = function(_, map)
          map("n", "dd", delete_buf)
          map("i", "<C-d>", delete_buf)
          return true
        end,
      })
    end, desc = "Buffers" },
    { "<leader>fB", function()
      require("telescope.builtin").buffers({
        prompt_title = "All Buffers",
        sort_mru = true,
        attach_mappings = function(_, map)
          map("n", "dd", delete_buf)
          map("i", "<C-d>", delete_buf)
          return true
        end,
      })
    end, desc = "All buffers" },
    { "<A-p>", "<cmd>Telescope find_files<cr>", desc = "Quick open file (⌥P)" },
    { "<A-f>", "<cmd>Telescope live_grep<cr>", desc = "Find in files (⌥F)" },
    { "<A-r>", function()
      require("telescope.builtin").oldfiles({ prompt_title = "📁 Recent Files", cwd_only = true })
    end, desc = "Recent files (⌥R)" },
    { "<A-e>", function()
      require("telescope.builtin").buffers({
        prompt_title = "📂 Open Buffers",
        sort_mru = true,
        ignore_current_buffer = true,
        attach_mappings = function(_, map)
          map("n", "dd", delete_buf)
          map("i", "<C-d>", delete_buf)
          return true
        end,
      })
    end, desc = "Switch buffer (⌥E)" },
  },
  dependencies = {
    "nvim-lua/plenary.nvim",
    { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    "nvim-tree/nvim-web-devicons",
    "folke/todo-comments.nvim",
    { "nvim-telescope/telescope-live-grep-args.nvim", version = "^1.0.0" },
  },
  config = function()
    local telescope = require("telescope")
    local actions = require("telescope.actions")
    local transform_mod = require("telescope.actions.mt").transform_mod

    local trouble = require("trouble")
    local trouble_telescope = require("trouble.sources.telescope")

    -- or create your custom action
    local custom_actions = transform_mod({
      open_trouble_qflist = function(prompt_bufnr)
        trouble.toggle("quickfix")
      end,
    })

    -- Workaround for treesitter ft_to_lang deprecation error
    -- Override the highlighter to use the new API
    local ts_utils = require("telescope.previewers.utils")
    local old_highlighter = ts_utils.highlighter
    ts_utils.highlighter = function(bufnr, ft)
      -- Use vim.treesitter.language.get_lang instead of deprecated ft_to_lang
      local ok, parser = pcall(vim.treesitter.get_parser, bufnr)
      if ok and parser then
        local lang = vim.treesitter.language.get_lang(ft) or ft
        return old_highlighter(bufnr, lang)
      end
      -- Fallback to regular syntax highlighting
      vim.bo[bufnr].syntax = ft
    end

    telescope.setup({
      defaults = {
        -- More Mac Spotlight-like behavior
        file_ignore_patterns = {
          "node_modules", ".git/", "*.DS_Store", ".Trash/*",
          "Library/", "*.app/", "*.dmg", "*.pkg"
        },
        path_display = { "smart" },
        sorting_strategy = "ascending",
        layout_config = {
          horizontal = {
            prompt_position = "top",
            preview_width = 0.55,
            results_width = 0.8,
          },
          vertical = {
            mirror = false,
          },
          width = 0.87,
          height = 0.80,
          preview_cutoff = 120,
        },
        -- Make search feel more responsive
        prompt_prefix = "🔍 ",
        selection_caret = "→ ",
        entry_prefix = "  ",
        initial_mode = "insert",
        selection_strategy = "reset",
        file_sorter = require("telescope.sorters").get_fuzzy_file,
        generic_sorter = require("telescope.sorters").get_generic_fuzzy_sorter,
        winblend = 0,
        border = {},
        borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
        color_devicons = true,
        use_less = true,
        mappings = {
          i = {
            -- Keep Ctrl for internal navigation (standard across editors)
            ["<C-k>"] = actions.move_selection_previous, -- move to prev result
            ["<C-j>"] = actions.move_selection_next, -- move to next result
            ["<C-q>"] = actions.send_selected_to_qflist,
            ["<C-t>"] = trouble_telescope.open,
            -- Option key navigation (Mac-friendly) - Note: these may conflict with global window nav
            ["<A-k>"] = actions.move_selection_previous,
            ["<A-j>"] = actions.move_selection_next,
            ["<A-q>"] = actions.send_selected_to_qflist,
            ["<A-t>"] = trouble_telescope.open,
            ["<A-w>"] = actions.close,
          },
          n = {
            -- Normal mode navigation
            ["<C-k>"] = actions.move_selection_previous,
            ["<C-j>"] = actions.move_selection_next,
            ["<C-q>"] = actions.send_selected_to_qflist,
            ["<C-t>"] = trouble_telescope.open,
            ["q"] = actions.close,
            ["<Esc>"] = actions.close,
          },
        },
      },
    })

    telescope.load_extension("fzf")
    telescope.load_extension("live_grep_args")

    -- Only keymaps not already covered by the `keys` spec above
    local keymap = vim.keymap

    -- Visual mode: search selected text
    keymap.set("v", "<leader>fs", function()
      vim.cmd('normal! "vy')
      local selected_text = vim.fn.getreg("v")
      if selected_text == "" then
        require("telescope.builtin").live_grep()
      else
        require("telescope.builtin").grep_string({
          search = selected_text,
          prompt_title = "Search: '" .. selected_text .. "'",
        })
      end
    end, { desc = "Search selected text" })

    -- LSP pickers not in keys spec
    keymap.set("n", "<leader>fi", function()
      require("telescope.builtin").lsp_implementations()
    end, { desc = "Search for implementations" })

    keymap.set("n", "<leader>fT", function()
      require("telescope.builtin").lsp_type_definitions()
    end, { desc = "Type definitions" })
  end,
}
