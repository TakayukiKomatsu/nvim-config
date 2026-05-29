return {
  "akinsho/bufferline.nvim",
  event = "VeryLazy",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  opts = {
    options = {
      -- Intentional: show vim tabs, not buffers. Buffer cycling lives on <Tab>/<S-Tab>.
      mode = "tabs",
    },
  },
}
