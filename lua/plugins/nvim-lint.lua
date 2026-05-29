-- nvim-lint: standalone linters that aren't provided by an LSP server.
--   Python -> mypy  (stricter type checking on top of pyright + ruff)
--
-- Go is intentionally NOT linted here: gopls already runs staticcheck and the
-- analyses configured in lspconfig.lua (nilness, unusedparams, fieldalignment,
-- ...), and golangci-lint v2 integration via nvim-lint is noisy/fragile.
--
-- mypy is installed via mason-tool-installer (mason.lua); run `:MasonToolsInstall`
-- once if it's missing. Linters whose binary isn't on PATH are skipped silently.
return {
  "mfussenegger/nvim-lint",
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    local lint = require("lint")

    lint.linters_by_ft = {
      python = { "mypy" },
    }

    -- Run only the linters whose executable is actually available.
    local function lint_if_available()
      if not (vim.bo.modifiable and vim.bo.buftype == "") then
        return
      end
      local names = lint.linters_by_ft[vim.bo.filetype] or {}
      local available = {}
      for _, name in ipairs(names) do
        local linter = lint.linters[name]
        local cmd = type(linter) == "table" and linter.cmd or nil
        cmd = type(cmd) == "function" and cmd() or cmd
        if cmd and vim.fn.executable(cmd) == 1 then
          table.insert(available, name)
        end
      end
      if #available > 0 then
        lint.try_lint(available)
      end
    end

    -- mypy / golangci-lint are slow; lint on read & save only (not on every keystroke).
    vim.api.nvim_create_autocmd({ "BufReadPost", "BufWritePost" }, {
      group = vim.api.nvim_create_augroup("NvimLint", { clear = true }),
      callback = lint_if_available,
    })

    vim.keymap.set("n", "<leader>cL", lint_if_available, { desc = "Lint current buffer" })
  end,
}
