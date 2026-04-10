-- Aggressive auto-save configuration for Mac-like experience
return {
  {
    "okuuva/auto-save.nvim",
    cmd = "ASToggle", -- optional for lazy loading on command
    event = { "InsertLeave", "TextChanged" }, -- optional for lazy loading on trigger events
    opts = {
      enabled = true, -- start auto-save when the plugin is loaded (i.e. when your package manager loads it)
      trigger_events = { -- See :h events
        immediate_save = { "BufLeave", "FocusLost" }, -- vim events that trigger an immediate save
        defer_save = { "InsertLeave", "TextChanged" }, -- vim events that trigger a deferred save (saves after `debounce_delay`)
        cancel_deferred_save = { "InsertEnter" }, -- vim events that cancel a pending deferred save
      },
      -- function that takes the buffer handle and determines whether to save the current buffer or not
      -- return true: if buffer is ok to be saved
      -- return false: if it's not ok to be saved
      -- if set to `nil` then no specific condition is applied
      condition = function(buf)
        local fn = vim.fn
        local utils = require("auto-save.utils.data")

        -- don't save for `sql` file types
        if utils.not_in(fn.getbufvar(buf, "&filetype"), { "harpoon", "alpha", "conf", "gitrebase", "gitcommit", "NeogitCommitMessage" }) then
          return true
        end
        return false
      end,
      write_all_buffers = false, -- write all buffers when the current one meets `condition`
      debounce_delay = 1000, -- delay after which a pending save is executed (in milliseconds)
      -- log debug messages to 'auto-save.log' file in neovim cache directory, set to `true` to enable
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
