-- Mac-like auto-save: save on context switches / insert leave, not on every text change.
return {
  {
    "okuuva/auto-save.nvim",
    cmd = "ASToggle",
    event = { "InsertLeave", "BufLeave", "FocusLost" },
    opts = {
      enabled = true,
      trigger_events = {
        immediate_save = { "BufLeave", "FocusLost" },
        defer_save = { "InsertLeave" },
        cancel_deferred_save = { "InsertEnter" },
      },
      condition = function(buf)
        -- Oil applies filesystem edits on save; require an explicit manual save
        -- there so renames/deletes are never triggered by auto-save.
        if vim.bo[buf].filetype == "oil" then
          return false
        end

        return vim.bo[buf].modifiable and vim.bo[buf].buftype == ""
      end,
      write_all_buffers = false,
      debounce_delay = 1000,
      debug = false,
    },
    config = function(_, opts)
      require("auto-save").setup(opts)
      -- Keep auto-save quiet; explicit saves still show command feedback as usual.
    end,
  },

}
