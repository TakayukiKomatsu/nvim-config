return {
  {
    "nvim-java/nvim-java",
    ft = { "java" },
    dependencies = {
      "MunifTanjim/nui.nvim",
      "mfussenegger/nvim-dap",
      { "JavaHello/spring-boot.nvim", commit = "218c0c26c14d99feca778e4d13f5ec3e8b1b60f0" },
    },
    config = function()
      require("java").setup()
      vim.lsp.enable("jdtls")
    end,
    keys = {
      { "<leader>jr", "<cmd>JavaRunnerRunMain<cr>", desc = "Run main" },
      { "<leader>jR", "<cmd>JavaRunnerStopMain<cr>", desc = "Stop main" },
      { "<leader>jl", "<cmd>JavaRunnerToggleLogs<cr>", desc = "Toggle runner logs" },
      { "<leader>jb", "<cmd>JavaBuildBuildWorkspace<cr>", desc = "Build workspace" },
      { "<leader>jc", "<cmd>JavaBuildCleanWorkspace<cr>", desc = "Clean workspace" },
      { "<leader>jt", "<cmd>JavaTestRunCurrentMethod<cr>", desc = "Run current test" },
      { "<leader>jT", "<cmd>JavaTestRunCurrentClass<cr>", desc = "Run current test class" },
      { "<leader>ja", "<cmd>JavaTestRunAllTests<cr>", desc = "Run all tests" },
      { "<leader>jd", "<cmd>JavaTestDebugCurrentMethod<cr>", desc = "Debug current test" },
      { "<leader>jD", "<cmd>JavaTestDebugCurrentClass<cr>", desc = "Debug current test class" },
      { "<leader>jA", "<cmd>JavaTestDebugAllTests<cr>", desc = "Debug all tests" },
      { "<leader>jv", "<cmd>JavaTestViewLastReport<cr>", desc = "View last test report" },
      { "<leader>jp", "<cmd>JavaProfile<cr>", desc = "Profiles" },
      { "<leader>jC", "<cmd>JavaDapConfig<cr>", desc = "Refresh DAP config" },
      { "<leader>jo", "<cmd>JavaRefactorExtractVariable<cr>", desc = "Extract variable" },
      { "<leader>jO", "<cmd>JavaRefactorExtractMethod<cr>", desc = "Extract method" },
      { "<leader>jf", "<cmd>JavaSettingsChangeRuntime<cr>", desc = "Change Java runtime" },
    },
  },
}
