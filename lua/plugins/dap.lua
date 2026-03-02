-- Debug Adapter Protocol (DAP) - Full debugging in Neovim
return {
  {
    "mfussenegger/nvim-dap",
    lazy = true,
    cmd = { "DapContinue", "DapToggleBreakpoint", "DapTerminate", "DapLoadLaunchJSON" },
    dependencies = {
      -- UI for DAP
      {
        "rcarriga/nvim-dap-ui",
        dependencies = { "nvim-neotest/nvim-nio" },
        opts = {},
        config = function(_, opts)
          local dap = require("dap")
          local dapui = require("dapui")
          dapui.setup(opts)

          -- Auto open/close UI
          dap.listeners.after.event_initialized["dapui_config"] = function()
            dapui.open()
          end
          dap.listeners.before.event_terminated["dapui_config"] = function()
            dapui.close()
          end
          dap.listeners.before.event_exited["dapui_config"] = function()
            dapui.close()
          end
        end,
      },
      -- Virtual text for variables
      {
        "theHamsta/nvim-dap-virtual-text",
        opts = {},
      },
      -- Mason DAP installer
      {
        "jay-babu/mason-nvim-dap.nvim",
        dependencies = "mason.nvim",
        cmd = { "DapInstall", "DapUninstall" },
        opts = {
          automatic_installation = true,
          handlers = {},
          ensure_installed = {
            "delve",           -- Go
            "js-debug-adapter", -- JS/TS/Bun
            "codelldb",        -- Rust/C/C++
            "debugpy",         -- Python
          },
        },
      },
    },
    keys = {
      { "<leader>db", function() require("dap").toggle_breakpoint() end, desc = "Toggle Breakpoint" },
      { "<leader>dB", function() require("dap").set_breakpoint(vim.fn.input("Condition: ")) end, desc = "Conditional Breakpoint" },
      { "<leader>dc", function() require("dap").continue() end, desc = "Continue" },
      { "<leader>dC", function() require("dap").run_to_cursor() end, desc = "Run to Cursor" },
      { "<leader>di", function() require("dap").step_into() end, desc = "Step Into" },
      { "<leader>do", function() require("dap").step_over() end, desc = "Step Over" },
      { "<leader>dO", function() require("dap").step_out() end, desc = "Step Out" },
      { "<leader>dr", function() require("dap").repl.toggle() end, desc = "Toggle REPL" },
      { "<leader>dl", function() require("dap").run_last() end, desc = "Run Last" },
      { "<leader>dx", function() require("dap").terminate() end, desc = "Terminate" },
      { "<leader>du", function() require("dapui").toggle() end, desc = "Toggle DAP UI" },
      { "<leader>de", function() require("dapui").eval() end, desc = "Eval", mode = { "n", "v" } },
    },
    config = function()
      local dap = require("dap")

      -- Set up sign icons
      vim.fn.sign_define("DapBreakpoint", { text = "", texthl = "DiagnosticError" })
      vim.fn.sign_define("DapBreakpointCondition", { text = "", texthl = "DiagnosticWarn" })
      vim.fn.sign_define("DapLogPoint", { text = "", texthl = "DiagnosticInfo" })
      vim.fn.sign_define("DapStopped", { text = "", texthl = "DiagnosticOk", linehl = "DapStoppedLine" })
      vim.fn.sign_define("DapBreakpointRejected", { text = "", texthl = "DiagnosticError" })

      -- =====================
      -- JavaScript/TypeScript (Node, Bun, Deno)
      -- =====================
      local js_debug_adapter = vim.fn.stdpath("data") .. "/mason/packages/js-debug-adapter/js-debug/src/dapDebugServer.js"

      -- Check if adapter exists
      if vim.fn.filereadable(js_debug_adapter) == 1 then
        dap.adapters["pwa-node"] = {
          type = "server",
          host = "localhost",
          port = "${port}",
          executable = {
            command = "node",
            args = { js_debug_adapter, "${port}" },
          },
        }

        -- Node.js configurations
        for _, lang in ipairs({ "javascript", "typescript", "javascriptreact", "typescriptreact" }) do
          dap.configurations[lang] = {
            -- Launch current file with Node
            {
              type = "pwa-node",
              request = "launch",
              name = "Launch file (Node)",
              program = "${file}",
              cwd = "${workspaceFolder}",
              sourceMaps = true,
            },
            -- Launch with ts-node for TypeScript
            {
              type = "pwa-node",
              request = "launch",
              name = "Launch file (ts-node)",
              runtimeExecutable = "npx",
              runtimeArgs = { "ts-node" },
              program = "${file}",
              cwd = "${workspaceFolder}",
              sourceMaps = true,
            },
            -- Attach to running Node process
            {
              type = "pwa-node",
              request = "attach",
              name = "Attach to Node process",
              processId = require("dap.utils").pick_process,
              cwd = "${workspaceFolder}",
              sourceMaps = true,
            },
            -- Launch with Bun
            {
              type = "pwa-node",
              request = "launch",
              name = "Launch file (Bun)",
              runtimeExecutable = "bun",
              runtimeArgs = { "run" },
              program = "${file}",
              cwd = "${workspaceFolder}",
              sourceMaps = true,
            },
            -- Debug Jest tests
            {
              type = "pwa-node",
              request = "launch",
              name = "Debug Jest Tests",
              runtimeExecutable = "npx",
              runtimeArgs = { "jest", "--runInBand", "${file}" },
              rootPath = "${workspaceFolder}",
              cwd = "${workspaceFolder}",
              console = "integratedTerminal",
              internalConsoleOptions = "neverOpen",
            },
            -- Debug Vitest
            {
              type = "pwa-node",
              request = "launch",
              name = "Debug Vitest Tests",
              runtimeExecutable = "npx",
              runtimeArgs = { "vitest", "run", "${file}" },
              rootPath = "${workspaceFolder}",
              cwd = "${workspaceFolder}",
              console = "integratedTerminal",
            },
          }
        end
      end

      -- =====================
      -- Go (Delve)
      -- =====================
      dap.adapters.delve = {
        type = "server",
        port = "${port}",
        executable = {
          command = "dlv",
          args = { "dap", "-l", "127.0.0.1:${port}" },
        },
      }

      dap.configurations.go = {
        -- Debug current file
        {
          type = "delve",
          name = "Debug file",
          request = "launch",
          program = "${file}",
        },
        -- Debug package
        {
          type = "delve",
          name = "Debug package",
          request = "launch",
          program = "${fileDirname}",
        },
        -- Debug test
        {
          type = "delve",
          name = "Debug test",
          request = "launch",
          mode = "test",
          program = "${file}",
        },
        -- Debug test (go.mod)
        {
          type = "delve",
          name = "Debug test (go.mod)",
          request = "launch",
          mode = "test",
          program = "./${relativeFileDirname}",
        },
        -- Attach to running process
        {
          type = "delve",
          name = "Attach to process",
          request = "attach",
          mode = "local",
          processId = require("dap.utils").pick_process,
        },
      }

      -- =====================
      -- Python (debugpy)
      -- =====================
      local debugpy_path = vim.fn.stdpath("data") .. "/mason/packages/debugpy/venv/bin/python"

      dap.adapters.python = function(cb, config)
        if config.request == "attach" then
          local port = (config.connect or config).port
          local host = (config.connect or config).host or "127.0.0.1"
          cb({
            type = "server",
            port = assert(port, "`connect.port` is required for attach"),
            host = host,
            options = { source_filetype = "python" },
          })
        else
          cb({
            type = "executable",
            command = debugpy_path,
            args = { "-m", "debugpy.adapter" },
            options = { source_filetype = "python" },
          })
        end
      end

      dap.configurations.python = {
        -- Launch current file
        {
          type = "python",
          request = "launch",
          name = "Launch file",
          program = "${file}",
          pythonPath = function()
            -- Try venv first
            local venv = os.getenv("VIRTUAL_ENV")
            if venv then
              return venv .. "/bin/python"
            end
            -- Try poetry
            local poetry = vim.fn.trim(vim.fn.system("poetry env info -p 2>/dev/null"))
            if poetry ~= "" then
              return poetry .. "/bin/python"
            end
            return "python3"
          end,
        },
        -- Launch with arguments
        {
          type = "python",
          request = "launch",
          name = "Launch file with arguments",
          program = "${file}",
          args = function()
            local args = vim.fn.input("Arguments: ")
            return vim.split(args, " ")
          end,
          pythonPath = function()
            local venv = os.getenv("VIRTUAL_ENV")
            return venv and (venv .. "/bin/python") or "python3"
          end,
        },
        -- Debug pytest
        {
          type = "python",
          request = "launch",
          name = "Debug pytest",
          module = "pytest",
          args = { "${file}", "-v" },
          pythonPath = function()
            local venv = os.getenv("VIRTUAL_ENV")
            return venv and (venv .. "/bin/python") or "python3"
          end,
        },
        -- Attach to remote
        {
          type = "python",
          request = "attach",
          name = "Attach remote",
          connect = function()
            local host = vim.fn.input("Host [127.0.0.1]: ")
            host = host ~= "" and host or "127.0.0.1"
            local port = tonumber(vim.fn.input("Port [5678]: ")) or 5678
            return { host = host, port = port }
          end,
        },
      }

      -- =====================
      -- Rust (codelldb)
      -- =====================
      local codelldb_path = vim.fn.stdpath("data") .. "/mason/packages/codelldb/extension/adapter/codelldb"
      local liblldb_path = vim.fn.stdpath("data") .. "/mason/packages/codelldb/extension/lldb/lib/liblldb.dylib"

      -- Check for macOS vs Linux
      if vim.fn.has("mac") == 0 then
        liblldb_path = vim.fn.stdpath("data") .. "/mason/packages/codelldb/extension/lldb/lib/liblldb.so"
      end

      dap.adapters.codelldb = {
        type = "server",
        port = "${port}",
        executable = {
          command = codelldb_path,
          args = { "--port", "${port}" },
        },
      }

      dap.configurations.rust = {
        -- Debug binary
        {
          name = "Debug binary",
          type = "codelldb",
          request = "launch",
          program = function()
            -- Try to find binary in target/debug
            local cwd = vim.fn.getcwd()
            local cargo_toml = cwd .. "/Cargo.toml"
            if vim.fn.filereadable(cargo_toml) == 1 then
              local name = vim.fn.system("grep '^name' " .. cargo_toml .. " | head -1 | sed 's/.*\"\\(.*\\)\".*/\\1/'")
              name = vim.fn.trim(name)
              local binary = cwd .. "/target/debug/" .. name
              if vim.fn.filereadable(binary) == 1 then
                return binary
              end
            end
            return vim.fn.input("Path to executable: ", cwd .. "/target/debug/", "file")
          end,
          cwd = "${workspaceFolder}",
          stopOnEntry = false,
          args = {},
        },
        -- Debug with arguments
        {
          name = "Debug binary with args",
          type = "codelldb",
          request = "launch",
          program = function()
            return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/target/debug/", "file")
          end,
          cwd = "${workspaceFolder}",
          stopOnEntry = false,
          args = function()
            local args = vim.fn.input("Arguments: ")
            return vim.split(args, " ")
          end,
        },
        -- Debug tests
        {
          name = "Debug tests",
          type = "codelldb",
          request = "launch",
          program = function()
            -- Build tests first
            vim.fn.system("cargo test --no-run 2>/dev/null")
            -- Find test binary
            local test_bins = vim.fn.glob(vim.fn.getcwd() .. "/target/debug/deps/*", false, true)
            local tests = {}
            for _, bin in ipairs(test_bins) do
              -- Filter out .d files and get executables
              if not bin:match("%.d$") and vim.fn.executable(bin) == 1 then
                table.insert(tests, bin)
              end
            end
            if #tests == 1 then
              return tests[1]
            end
            -- Let user pick
            return vim.fn.input("Test binary: ", vim.fn.getcwd() .. "/target/debug/deps/", "file")
          end,
          cwd = "${workspaceFolder}",
          stopOnEntry = false,
        },
      }

      -- Also configure for C/C++ since codelldb supports them
      dap.configurations.c = dap.configurations.rust
      dap.configurations.cpp = dap.configurations.rust
    end,
  },
}
