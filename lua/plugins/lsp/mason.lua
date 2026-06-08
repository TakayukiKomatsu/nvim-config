return {
  "mason-org/mason.nvim",
  dependencies = {
    "mason-org/mason-lspconfig.nvim",
    "WhoIsSethDaniel/mason-tool-installer.nvim",
  },
  config = function()
    -- import mason
    local mason = require("mason")

    -- import mason-lspconfig
    local mason_lspconfig = require("mason-lspconfig")

    local mason_tool_installer = require("mason-tool-installer")

    -- enable mason and configure icons
    mason.setup({
      ui = {
        icons = {
          package_installed = "✓",
          package_pending = "➜",
          package_uninstalled = "✗",
        },
      },
    })

    mason_lspconfig.setup({
      -- list of servers for mason to install
      ensure_installed = {
        -- TypeScript/JavaScript
        "vtsls", -- TS/JS language server (configured in lspconfig.lua)
        "eslint", -- ESLint language server
        "angularls", -- Angular language server

        -- Web
        "html",
        "cssls",
        "tailwindcss",
        "emmet_ls",
        "graphql",
        "prismals",

        -- Go
        "gopls", -- Go language server

        -- Python
        "pyright", -- Python language server
        "ruff", -- Fast Python linter/formatter (replaces black, isort, pylint)

        -- Lua
        "lua_ls",

        -- Rust handled by rustaceanvim (rust-analyzer)
      },
      -- Enabling is handled in lspconfig.lua via vim.lsp.enable() so config
      -- registration and enabling stay in one deterministic place.
      automatic_enable = false,
    })

    mason_tool_installer.setup({
      -- Run `:MasonToolsInstall` on demand; avoid startup I/O
      run_on_start = false,
      auto_update = false,
      start_delay = 3000,
      debounce_hours = 24,
      ensure_installed = {
        -- JavaScript/TypeScript
        "prettierd", -- faster prettier formatter
        "prettier", -- prettier formatter fallback
        "eslint_d", -- faster eslint

        -- Lua
        "stylua", -- lua formatter

        -- Python
        "mypy", -- type checker

        -- Go (linting handled by gopls staticcheck/analyses, not golangci-lint)
        "gofumpt", -- stricter gofmt
        "goimports", -- auto imports
        "delve", -- debugger

        -- Java
        "google-java-format", -- java formatter for conform

        -- Rust (rust-analyzer installed via rustup, not mason)
      },
    })
  end,
}
