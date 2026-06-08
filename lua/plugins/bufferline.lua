return {
  "akinsho/bufferline.nvim",
  event = "VeryLazy",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  opts = {
    options = {
      -- VSCode/WebStorm-style row of open files. Cycle with <Tab>/<S-Tab> (bnext/bprev);
      -- vim tabpages live on <leader><Tab>*.
      mode = "buffers",
      diagnostics = "nvim_lsp",
      diagnostics_indicator = function(_, _, diag)
        local icons = { error = " ", warning = " ", info = " " }
        local s = {}
        for level, n in pairs(diag) do
          if icons[level] then
            s[#s + 1] = icons[level] .. n
          end
        end
        return table.concat(s, " ")
      end,
      show_buffer_close_icons = true,
      show_close_icon = false,
      separator_style = "thin",
      offsets = {
        {
          filetype = "NvimTree",
          text = "Explorer",
          highlight = "Directory",
          text_align = "center",
        },
      },
    },
  },
}
