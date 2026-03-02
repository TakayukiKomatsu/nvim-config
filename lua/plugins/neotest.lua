return {
  -- Disable the golang adapter from LazyVim extras (causes conflicts)
  {
    "fredrikaverpil/neotest-golang",
    enabled = false,
  },

  {
    "nvim-neotest/neotest",
    dependencies = {
      "nvim-neotest/neotest-go", -- Go tests
      "nvim-neotest/neotest-jest", -- Jest (JS/TS)
      "marilari88/neotest-vitest", -- Vitest (modern JS/TS)
      "nvim-neotest/neotest-python", -- Python tests
      "rouge8/neotest-rust", -- Rust tests (cargo test)
    },
    keys = {
      { "<leader>ta", function() require("neotest").run.run(vim.fn.getcwd()) end, desc = "Run all tests" },
      { "<leader>tf", function() require("neotest").run.run(vim.fn.expand("%")) end, desc = "Run file tests" },
      { "<leader>td", function() require("neotest").run.run({ strategy = "dap" }) end, desc = "Debug nearest test" },
    },
    opts = function(_, opts)
      opts.adapters = {
        -- Vitest (preferred for modern TS/JS projects using Vite)
        require("neotest-vitest")({
          vitestCommand = "npx vitest",
        }),

        -- Jest (fallback for older projects)
        require("neotest-jest")({
          jestCommand = "npm test --",
          env = { CI = true },
          cwd = function()
            return vim.fn.getcwd()
          end,
        }),

        -- Go
        require("neotest-go")({
          experimental = {
            test_table = true,
          },
          args = { "-count=1", "-timeout=60s" },
        }),

        -- Python (pytest, unittest)
        require("neotest-python")({
          dap = { justMyCode = false },
          args = { "--log-level", "DEBUG" },
          runner = "pytest",
        }),

        -- Rust (cargo test)
        require("neotest-rust")({
          args = { "--no-capture" },
        }),
      }

      return opts
    end,
  },
}
