-- TypeScript/JavaScript enhancements
return {
  -- Package.json dependency management (like crates.nvim for Rust)
  {
    "vuki656/package-info.nvim",
    dependencies = { "MunifTanjim/nui.nvim" },
    event = { "BufRead package.json" },
    opts = {
      colors = {
        up_to_date = "#3C4048",
        outdated = "#d19a66",
      },
      icons = {
        enable = true,
        style = {
          up_to_date = "|  ",
          outdated = "|  ",
        },
      },
      autostart = true,
      hide_up_to_date = false,
      hide_unstable_versions = false,
    },
    keys = {
      { "<leader>ns", function() require("package-info").show() end, desc = "Show package versions" },
      { "<leader>nh", function() require("package-info").hide() end, desc = "Hide package versions" },
      { "<leader>nu", function() require("package-info").update() end, desc = "Update package" },
      { "<leader>nd", function() require("package-info").delete() end, desc = "Delete package" },
      { "<leader>ni", function() require("package-info").install() end, desc = "Install package" },
      { "<leader>nc", function() require("package-info").change_version() end, desc = "Change version" },
    },
  },

  -- Primary TypeScript/JavaScript language tooling
  {
    "pmizio/typescript-tools.nvim",
    dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
    ft = { "typescript", "typescriptreact", "javascript", "javascriptreact" },
    opts = {
      filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
      settings = {
        separate_diagnostic_server = true,
        publish_diagnostic_on = "insert_leave",
        expose_as_code_action = "all",
        tsserver_path = nil,
        tsserver_plugins = {},
        tsserver_max_memory = "auto",
        tsserver_format_options = {},
        tsserver_file_preferences = {
          includeInlayParameterNameHints = "all",
          includeInlayParameterNameHintsWhenArgumentMatchesName = false,
          includeInlayFunctionParameterTypeHints = true,
          includeInlayVariableTypeHints = true,
          includeInlayPropertyDeclarationTypeHints = true,
          includeInlayFunctionLikeReturnTypeHints = true,
          includeInlayEnumMemberValueHints = true,
        },
        tsserver_locale = "en",
        complete_function_calls = true,
        include_completions_with_insert_text = true,
        code_lens = "all",
        disable_member_code_lens = false,
      },
    },
    keys = {
      { "<leader>cto", "<cmd>TSToolsOrganizeImports<cr>", desc = "Organize imports" },
      { "<leader>cts", "<cmd>TSToolsSortImports<cr>", desc = "Sort imports" },
      { "<leader>ctr", "<cmd>TSToolsRemoveUnusedImports<cr>", desc = "Remove unused imports" },
      { "<leader>ctR", "<cmd>TSToolsRemoveUnused<cr>", desc = "Remove all unused" },
      { "<leader>cta", "<cmd>TSToolsAddMissingImports<cr>", desc = "Add missing imports" },
      { "<leader>ctf", "<cmd>TSToolsFixAll<cr>", desc = "Fix all" },
      { "<leader>ctg", "<cmd>TSToolsGoToSourceDefinition<cr>", desc = "Go to source definition" },
      { "<leader>ctF", "<cmd>TSToolsFileReferences<cr>", desc = "File references" },
      { "<leader>ctd", "<cmd>TSToolsRenameFile<cr>", desc = "Rename file" },
    },
  },
}
