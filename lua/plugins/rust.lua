return {
  -- Rustaceanvim - Enhanced Rust support
  {
    "mrcjkb/rustaceanvim",
    version = "^5",
    lazy = false,
    init = function()
      vim.g.rustaceanvim = {
        tools = {
          float_win_config = {
            border = "rounded",
          },
        },
        server = {
          on_attach = function(_, bufnr)
            local opts = { buffer = bufnr, silent = true }
            -- Rust-specific keymaps in their own namespace to avoid collisions with refactoring
            vim.keymap.set("n", "<leader>Rd", function() vim.cmd.RustLsp("debuggables") end, vim.tbl_extend("force", opts, { desc = "Rust debuggables" }))
            vim.keymap.set("n", "<leader>Rr", function() vim.cmd.RustLsp("runnables") end, vim.tbl_extend("force", opts, { desc = "Rust runnables" }))
            vim.keymap.set("n", "<leader>Rt", function() vim.cmd.RustLsp("testables") end, vim.tbl_extend("force", opts, { desc = "Rust testables" }))
            vim.keymap.set("n", "<leader>Rm", function() vim.cmd.RustLsp("expandMacro") end, vim.tbl_extend("force", opts, { desc = "Expand macro" }))
            vim.keymap.set("n", "<leader>Rc", function() vim.cmd.RustLsp("openCargo") end, vim.tbl_extend("force", opts, { desc = "Open Cargo.toml" }))
            vim.keymap.set("n", "<leader>Rp", function() vim.cmd.RustLsp("parentModule") end, vim.tbl_extend("force", opts, { desc = "Parent module" }))
          end,
          default_settings = {
            ["rust-analyzer"] = {
              cargo = {
                allFeatures = true,
                loadOutDirsFromCheck = true,
                runBuildScripts = true,
              },
              checkOnSave = {
                allFeatures = true,
                command = "clippy",
                extraArgs = { "--no-deps" },
              },
              procMacro = {
                enable = true,
                ignored = {
                  ["async-trait"] = { "async_trait" },
                  ["napi-derive"] = { "napi" },
                  ["async-recursion"] = { "async_recursion" },
                },
              },
            },
          },
        },
      }
    end,
  },

  -- Crates.nvim - Cargo.toml dependency management
  {
    "saecki/crates.nvim",
    event = { "BufRead Cargo.toml" },
    opts = {
      completion = {
        cmp = { enabled = false },
      },
    },
    keys = {
      { "<leader>rct", function() require("crates").toggle() end, desc = "Toggle crate info" },
      { "<leader>rcr", function() require("crates").reload() end, desc = "Reload crates" },
      { "<leader>rcv", function() require("crates").show_versions_popup() end, desc = "Show versions" },
      { "<leader>rcf", function() require("crates").show_features_popup() end, desc = "Show features" },
      { "<leader>rcd", function() require("crates").show_dependencies_popup() end, desc = "Show dependencies" },
      { "<leader>rcu", function() require("crates").update_crate() end, desc = "Update crate" },
      { "<leader>rcU", function() require("crates").upgrade_crate() end, desc = "Upgrade crate" },
      { "<leader>rca", function() require("crates").update_all_crates() end, desc = "Update all crates" },
      { "<leader>rcA", function() require("crates").upgrade_all_crates() end, desc = "Upgrade all crates" },
      { "<leader>rcH", function() require("crates").open_homepage() end, desc = "Open homepage" },
      { "<leader>rcR", function() require("crates").open_repository() end, desc = "Open repository" },
      { "<leader>rcD", function() require("crates").open_documentation() end, desc = "Open docs.rs" },
      { "<leader>rcC", function() require("crates").open_crates_io() end, desc = "Open crates.io" },
    },
  },
}
