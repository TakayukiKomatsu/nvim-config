return {
  "nvim-treesitter/nvim-treesitter",
  event = { "BufReadPre", "BufNewFile" },
  build = ":TSUpdate",
  dependencies = {
    "windwp/nvim-ts-autotag",
  },
  config = function()
    -- configure treesitter
    local status_ok, configs = pcall(require, "nvim-treesitter.configs")
    if not status_ok then
      return
    end

    configs.setup({
      -- A list of parser names, or "all" (the listed parsers MUST always be installed)
      ensure_installed = {
        "json",
        "javascript",
        "typescript",
        "tsx",
        "yaml",
        "html",
        "css",
        "prisma",
        "markdown",
        "markdown_inline",
        "graphql",
        "bash",
        "lua",
        "vim",
        "vimdoc",
        "dockerfile",
        "gitignore",
        "query",
        "regex",
        "c",
        "python",
        "go",
        "rust",
        "toml",
      },

      -- Install parsers synchronously (only applied to `ensure_installed`)
      sync_install = false,

      -- Deterministic: grow `ensure_installed` above rather than auto-installing on buffer open
      auto_install = false,

      highlight = {
        enable = true,
        -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
        -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
        -- Using this option may slow down your editor, and you may see some duplicate highlights.
        -- Instead of true it can also be a list of languages
        additional_vim_regex_highlighting = false,
        -- Or use a function for more flexibility, e.g. to disable slow treesitter highlight for large files
        disable = function(lang, buf)
          local max_filesize = 100 * 1024 -- 100 KB
          local ok, stats = pcall(vim.uv.fs_stat, vim.api.nvim_buf_get_name(buf))
          if ok and stats and stats.size > max_filesize then
            return true
          end
        end,
      },

      -- Enable indentation
      indent = {
        enable = true,
        -- Disable for languages that have poor indentation support
        disable = { "python", "yaml" },
      },

      -- Enable autotagging (w/ nvim-ts-autotag plugin)
      autotag = {
        enable = true,
      },
      -- Incremental selection based on the named nodes from the grammar
      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = "<A-i>", -- Option+I for init selection
          node_incremental = "<A-i>", -- expand selection
          scope_incremental = false,
          node_decremental = "<bs>", -- backspace works well
          -- Alternative mappings
          -- init_selection = "<C-space>", -- fallback for muscle memory users
        },
      },
    })
  end,
}
