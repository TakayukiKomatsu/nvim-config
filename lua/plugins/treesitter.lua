local extra_parsers = {
  "bash",
  "c",
  "css",
  "dockerfile",
  "gitignore",
  "go",
  "gomod",
  "gosum",
  "gowork",
  "graphql",
  "html",
  "javascript",
  "json",
  "lua",
  "markdown",
  "markdown_inline",
  "prisma",
  "python",
  "query",
  "regex",
  "rust",
  "toml",
  "tsx",
  "typescript",
  "vim",
  "vimdoc",
  "yaml",
}

local max_treesitter_filesize = 100 * 1024 -- 100 KB

local function extend_unique(list, additions)
  list = list or {}
  local seen = {}

  for _, item in ipairs(list) do
    seen[item] = true
  end

  for _, item in ipairs(additions) do
    if not seen[item] then
      table.insert(list, item)
      seen[item] = true
    end
  end

  return list
end

return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      opts.ensure_installed = extend_unique(opts.ensure_installed, extra_parsers)

      -- LazyVim's nvim-treesitter main-branch config supports disable lists.
      -- Keep Python/YAML on regex indent because their TS indentation is noisy.
      opts.indent = vim.tbl_deep_extend("force", opts.indent or {}, {
        enable = true,
        disable = extend_unique(opts.indent and opts.indent.disable or {}, { "python", "yaml" }),
      })

      opts.highlight = vim.tbl_deep_extend("force", opts.highlight or {}, {
        enable = true,
      })

      return opts
    end,
    init = function()
      -- Native nvim-treesitter main no longer supports the old module-style
      -- `highlight.disable = function(lang, buf)` hook. Stop TS after FileType
      -- for very large files to preserve the old performance guard.
      vim.api.nvim_create_autocmd("BufReadPre", {
        group = vim.api.nvim_create_augroup("UserTreesitterLargeFile", { clear = true }),
        callback = function(args)
          local ok, stats = pcall(vim.uv.fs_stat, vim.api.nvim_buf_get_name(args.buf))
          if ok and stats and stats.size > max_treesitter_filesize then
            vim.b[args.buf].user_disable_treesitter = true
          end
        end,
      })

      vim.api.nvim_create_autocmd("FileType", {
        group = vim.api.nvim_create_augroup("UserTreesitterLargeFileStop", { clear = true }),
        callback = function(args)
          if not vim.b[args.buf].user_disable_treesitter then
            return
          end

          vim.schedule(function()
            if vim.api.nvim_buf_is_valid(args.buf) then
              pcall(vim.treesitter.stop, args.buf)
            end
          end)
        end,
      })

      -- Native incremental selection mappings. The old nvim-treesitter module
      -- API is gone on the main branch; Neovim now provides visual-mode node
      -- selection via `an`/`in`.
      vim.keymap.set("n", "<A-i>", "van", { desc = "Treesitter select node", remap = true })
      vim.keymap.set("x", "<A-i>", "an", { desc = "Treesitter expand selection", remap = true })
      vim.keymap.set("x", "<BS>", "in", { desc = "Treesitter shrink selection", remap = true })
    end,
  },

  {
    "windwp/nvim-ts-autotag",
    opts = {},
  },
}
