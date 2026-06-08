return {
  {
    "stevearc/conform.nvim",
    keys = {
      {
        "<leader>cf",
        function() require("conform").format({ async = true, lsp_fallback = true }) end,
        mode = { "n", "v" },
        desc = "Format buffer",
      },
      {
        "<A-F>",
        function() require("conform").format({ async = true, lsp_fallback = true }) end,
        mode = { "n", "v" },
        desc = "Format buffer (⌥F)",
      },
      {
        "<leader>uF",
        function()
          vim.g.disable_autoformat = not vim.g.disable_autoformat
          if vim.g.disable_autoformat then
            vim.notify("Format on save: OFF", vim.log.levels.WARN)
          else
            vim.notify("Format on save: ON", vim.log.levels.INFO)
          end
        end,
        desc = "Toggle format on save (global)",
      },
    },
    opts = function(_, opts)
      -- Format on save for every configured filetype. Toggle globally with
      -- <leader>uF (sets vim.g.disable_autoformat).
      opts.format_on_save = function(_)
        if vim.g.disable_autoformat then
          return
        end
        return { timeout_ms = 1500, lsp_format = "fallback" }
      end

      opts.formatters_by_ft = vim.tbl_extend("force", opts.formatters_by_ft or {}, {
        python          = { "ruff_organize_imports", "ruff_format" },
        lua             = { "stylua" },
        javascript      = { "prettierd", "prettier", stop_after_first = true },
        typescript      = { "prettierd", "prettier", stop_after_first = true },
        javascriptreact = { "prettierd", "prettier", stop_after_first = true },
        typescriptreact = { "prettierd", "prettier", stop_after_first = true },
        json            = { "prettierd", "prettier", stop_after_first = true },
        jsonc           = { "prettierd", "prettier", stop_after_first = true },
        css             = { "prettierd", "prettier", stop_after_first = true },
        scss            = { "prettierd", "prettier", stop_after_first = true },
        html            = { "prettierd", "prettier", stop_after_first = true },
        markdown        = { "prettierd", "prettier", stop_after_first = true },
        graphql         = { "prettierd", "prettier", stop_after_first = true },
        go              = { "goimports", "gofumpt" },
        java            = { "google-java-format" },
      })
      return opts
    end,
  },
}
