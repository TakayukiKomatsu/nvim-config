-- Better folding: peek-preview + "N lines" virtual text on folded regions.
-- Provider order is treesitter -> indent (no LSP foldingRange dependency, so it
-- works the moment a buffer opens). Fold open/close defaults live in
-- lua/config/options.lua.
return {
  "kevinhwang91/nvim-ufo",
  dependencies = { "kevinhwang91/promise-async" },
  event = "BufReadPost",
  keys = {
    { "zR", function() require("ufo").openAllFolds() end, desc = "Open all folds" },
    { "zM", function() require("ufo").closeAllFolds() end, desc = "Close all folds" },
    {
      "zK",
      function()
        local winid = require("ufo").peekFoldedLinesUnderCursor()
        if not winid then
          vim.lsp.buf.hover()
        end
      end,
      desc = "Peek fold (or hover)",
    },
  },
  opts = {
    open_fold_hl_timeout = 0,
    provider_selector = function()
      return { "treesitter", "indent" }
    end,
    -- Show "⋯ 42 lines" on the fold line, truncated to fit the window width.
    fold_virt_text_handler = function(virt_text, lnum, end_lnum, width, truncate)
      local suffix = ("  󰁂 %d "):format(end_lnum - lnum)
      local sufWidth = vim.fn.strdisplaywidth(suffix)
      local target = width - sufWidth
      local cur = 0
      local result = {}
      for _, chunk in ipairs(virt_text) do
        local text = chunk[1]
        local w = vim.fn.strdisplaywidth(text)
        if target > cur + w then
          table.insert(result, chunk)
        else
          text = truncate(text, target - cur)
          table.insert(result, { text, chunk[2] })
          w = vim.fn.strdisplaywidth(text)
          if cur + w < target then
            suffix = suffix .. (" "):rep(target - cur - w)
          end
          break
        end
        cur = cur + w
      end
      table.insert(result, { suffix, "MoreMsg" })
      return result
    end,
  },
}
