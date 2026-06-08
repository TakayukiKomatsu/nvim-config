-- Native LSP setup (Neovim 0.11+): servers are configured with vim.lsp.config()
-- and turned on with vim.lsp.enable(). nvim-lspconfig is kept as a dependency for
-- the base server definitions it ships in its `lsp/` runtime directory.
return {
  "neovim/nvim-lspconfig",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    { "antosha417/nvim-lsp-file-operations", config = true },
    "mason-org/mason-lspconfig.nvim",
    "saghen/blink.cmp",
  },
  config = function()
    local keymap = vim.keymap

    -- ── Buffer-local keymaps on attach ────────────────────────────────────────
    vim.api.nvim_create_autocmd("LspAttach", {
      group = vim.api.nvim_create_augroup("UserLspConfig", {}),
      callback = function(ev)
        local opts = { buffer = ev.buf, silent = true }

        opts.desc = "Show LSP references (picker)"
        keymap.set("n", "gR", function() Snacks.picker.lsp_references() end, opts)

        opts.desc = "LSP references (quickfix)"
        keymap.set("n", "gr", vim.lsp.buf.references, opts)

        opts.desc = "Go to declaration"
        keymap.set("n", "gD", vim.lsp.buf.declaration, opts)

        opts.desc = "Show LSP definitions"
        keymap.set("n", "gd", function() Snacks.picker.lsp_definitions() end, opts)

        opts.desc = "Show LSP implementations"
        keymap.set("n", "gi", function() Snacks.picker.lsp_implementations() end, opts)

        opts.desc = "Show LSP type definitions"
        keymap.set("n", "gt", function() Snacks.picker.lsp_type_definitions() end, opts)

        opts.desc = "See available code actions"
        keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts)

        opts.desc = "Smart rename"
        keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)

        opts.desc = "Show buffer diagnostics"
        keymap.set("n", "<leader>D", function() Snacks.picker.diagnostics_buffer() end, opts)

        opts.desc = "Show line diagnostics"
        keymap.set("n", "<leader>cd", vim.diagnostic.open_float, opts)

        opts.desc = "Go to previous diagnostic"
        keymap.set("n", "[d", function()
          vim.diagnostic.jump({ count = -1, float = true })
        end, opts)

        opts.desc = "Go to next diagnostic"
        keymap.set("n", "]d", function()
          vim.diagnostic.jump({ count = 1, float = true })
        end, opts)

        opts.desc = "Show documentation for what is under cursor"
        keymap.set("n", "K", vim.lsp.buf.hover, opts)

        opts.desc = "Restart LSP"
        keymap.set("n", "<leader>rs", "<cmd>LspRestart<CR>", opts)

        local client = vim.lsp.get_client_by_id(ev.data.client_id)

        -- Enable inlay hints for servers that support them (toggle with <leader>uI)
        if client and client.server_capabilities and client.server_capabilities.inlayHintProvider then
          vim.lsp.inlay_hint.enable(true, { bufnr = ev.buf })
        end

        -- vtsls: TypeScript/JavaScript import & fix helpers via tsserver source actions.
        -- (Replaces the old typescript-tools.nvim <leader>ct* commands.)
        if client and client.name == "vtsls" then
          local function ts_action(kind)
            return function()
              vim.lsp.buf.code_action({
                apply = true,
                context = { only = { kind }, diagnostics = {} },
              })
            end
          end
          local function ts_map(lhs, kind, desc)
            keymap.set("n", lhs, ts_action(kind), { buffer = ev.buf, silent = true, desc = desc })
          end
          ts_map("<leader>cto", "source.organizeImports", "Organize imports")
          ts_map("<leader>cta", "source.addMissingImports.ts", "Add missing imports")
          ts_map("<leader>ctr", "source.removeUnused.ts", "Remove unused")
          ts_map("<leader>ctf", "source.fixAll.ts", "Fix all")
        end

        -- eslint: auto-apply `eslint --fix` (safe, fixable rules) before each
        -- write. `LspEslintFixAll` is the buffer-local command the eslint server
        -- registers; it runs synchronously so the save picks up the fixes.
        -- Guarded on pending eslint diagnostics so clean buffers save instantly
        -- (matters because auto-save.nvim writes frequently).
        if client and client.name == "eslint" then
          local group = vim.api.nvim_create_augroup("EslintFixOnSave", { clear = false })
          vim.api.nvim_clear_autocmds({ group = group, buffer = ev.buf })
          vim.api.nvim_create_autocmd("BufWritePre", {
            group = group,
            buffer = ev.buf,
            desc = "ESLint --fix on save",
            callback = function()
              local ok, ns = pcall(vim.lsp.diagnostic.get_namespace, client.id)
              local diags = ok and vim.diagnostic.get(ev.buf, { namespace = ns })
                or vim.diagnostic.get(ev.buf)
              if #diags > 0 then
                pcall(vim.cmd, "LspEslintFixAll")
              end
            end,
          })
        end
      end,
    })

    -- ── Capabilities (blink.cmp) applied to every server ──────────────────────
    vim.lsp.config("*", {
      capabilities = require("blink.cmp").get_lsp_capabilities(),
    })

    local util = require("lspconfig.util")

    -- ── Per-server overrides ──────────────────────────────────────────────────
    vim.lsp.config("gopls", {
      settings = {
        gopls = {
          gofumpt = true,
          codelenses = {
            gc_details = false,
            generate = true,
            regenerate_cgo = true,
            run_govulncheck = true,
            test = true,
            tidy = true,
            upgrade_dependency = true,
            vendor = true,
          },
          hints = {
            assignVariableTypes = true,
            compositeLiteralFields = true,
            compositeLiteralTypes = true,
            constantValues = true,
            functionTypeParameters = true,
            parameterNames = true,
            rangeVariableTypes = true,
          },
          analyses = {
            fieldalignment = true,
            nilness = true,
            unusedparams = true,
            unusedwrite = true,
            useany = true,
          },
          usePlaceholders = true,
          completeUnimported = true,
          staticcheck = true,
          directoryFilters = { "-.git", "-.vscode", "-.idea", "-.vscode-test", "-node_modules" },
          semanticTokens = true,
        },
      },
    })

    -- Ruff (Python): fast linter/formatter only; pyright handles navigation/hover.
    vim.lsp.config("ruff", {
      init_options = {
        settings = {
          args = {},
        },
      },
      on_attach = function(client)
        client.server_capabilities.hoverProvider = false
        client.server_capabilities.definitionProvider = false
        client.server_capabilities.referencesProvider = false
        client.server_capabilities.renameProvider = false
        client.server_capabilities.declarationProvider = false
        client.server_capabilities.implementationProvider = false
        client.server_capabilities.typeDefinitionProvider = false
      end,
    })

    vim.lsp.config("graphql", {
      filetypes = { "graphql", "gql", "typescriptreact", "javascriptreact" },
    })

    vim.lsp.config("emmet_ls", {
      filetypes = { "html", "typescriptreact", "javascriptreact", "css", "sass", "scss", "less" },
    })

    -- Silence "unknown at-rule" noise from Tailwind directives (@tailwind, @apply, etc.).
    vim.lsp.config("cssls", {
      settings = {
        css = { lint = { unknownAtRules = "ignore" } },
        scss = { lint = { unknownAtRules = "ignore" } },
        less = { lint = { unknownAtRules = "ignore" } },
      },
    })

    -- Keep vtsls out of Angular workspaces so it doesn't fight angularls.
    vim.lsp.config("vtsls", {
      single_file_support = false,
      root_dir = function(bufnr, on_dir)
        local fname = vim.api.nvim_buf_get_name(bufnr)
        if util.root_pattern("angular.json")(fname) then
          return -- defer to angularls
        end
        local root = util.root_pattern("tsconfig.json", "jsconfig.json", "package.json", ".git")(fname)
        if root then
          on_dir(root)
        end
      end,
    })

    vim.lsp.config("lua_ls", {
      settings = {
        Lua = {
          diagnostics = { globals = { "vim" } },
          completion = { callSnippet = "Replace" },
        },
      },
    })

    -- ── Enable installed servers, minus ones we must not start ────────────────
    --   jdtls         -> owned by nvim-java
    --   rust_analyzer -> owned by rustaceanvim
    --   stylua        -> a formatter (run by conform); mason-lspconfig lists it
    --                    because nvim-lspconfig ships a bogus lsp/stylua.lua
    local skip = { jdtls = true, rust_analyzer = true, stylua = true }
    local to_enable = {}
    for _, name in ipairs(require("mason-lspconfig").get_installed_servers()) do
      if not skip[name] then
        table.insert(to_enable, name)
      end
    end
    vim.lsp.enable(to_enable)
  end,
}
