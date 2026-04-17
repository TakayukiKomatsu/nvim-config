-- Aggressive auto-save configuration for Mac-like experience
return {
  {
    "okuuva/auto-save.nvim",
    cmd = "ASToggle",
    event = { "InsertLeave", "TextChanged" },
    opts = {
      enabled = true,
      trigger_events = {
        immediate_save = { "BufLeave", "FocusLost" },
        defer_save = { "InsertLeave", "TextChanged" },
        cancel_deferred_save = { "InsertEnter" },
      },
      write_all_buffers = false,
      debounce_delay = 1000,
      debug = false,
    },
    config = function(_, opts)
      require("auto-save").setup(opts)

      -- Create autocmd for save notification (replacement for execution_message)
      local group = vim.api.nvim_create_augroup('autosave_notify', {})

      vim.api.nvim_create_autocmd('User', {
        pattern = 'AutoSaveWritePost',
        group = group,
        callback = function(args)
          if args.data.saved_buffer ~= nil then
            local filename = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(args.data.saved_buffer), ':t')
            local msg = 'AutoSave: saved at ' .. vim.fn.strftime('%H:%M:%S')
            vim.notify(msg, vim.log.levels.INFO, { title = filename })
          end
        end,
      })
    end,
  },

}
