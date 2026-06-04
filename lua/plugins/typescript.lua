-- TypeScript/JavaScript enhancements
return {
  -- Package.json dependency management (like crates.nvim for Rust)
  {
    "vuki656/package-info.nvim",
    dependencies = { "MunifTanjim/nui.nvim" },
    event = { "BufRead package.json" },
    opts = {
      highlights = {
        up_to_date = { fg = "#3C4048" },
        outdated = { fg = "#d19a66" },
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

  -- TypeScript/JavaScript language server is vtsls, configured natively in
  -- lua/plugins/lsp/lspconfig.lua. The <leader>ct* import/fix commands are
  -- registered there (buffer-local) when vtsls attaches.
}
