-- Custom dashboard + snacks overrides
return {
  {
    "folke/snacks.nvim",
    opts = {
      -- Disable features handled by dedicated plugins
      indent = { enabled = false }, -- keep Snacks indent guides off
      scope  = { enabled = false }, -- mini.indentscope handles active scope
      words  = { enabled = false }, -- vim-illuminate handles word highlighting
      scroll = { enabled = false }, -- no smooth scroll desired
      input = { enabled = false }, -- using dressing.nvim for vim.ui.input
      dashboard = {
        preset = {
          header = "",
          -- stylua: ignore
          keys = {
            { icon = " ", key = "f", desc = "Find File", action = ":Telescope find_files" },
            { icon = " ", key = "g", desc = "Find Text", action = ":Telescope live_grep" },
            { icon = " ", key = "r", desc = "Recent Files", action = ":Telescope oldfiles" },
            { icon = " ", key = "s", desc = "Restore Session", action = function() require("persistence").load() end },
            { icon = "󰈔 ", key = "h", desc = "Harpoon Files", action = function()
              local harpoon = require("harpoon")
              harpoon.ui:toggle_quick_menu(harpoon:list())
            end },
            { icon = " ", key = "t", desc = "Find Todos", action = ":TodoTelescope" },
            { icon = " ", key = "k", desc = "Keymaps", action = ":Telescope keymaps" },
            { icon = " ", key = "G", desc = "LazyGit", action = function() Snacks.lazygit() end },
            { icon = " ", key = "m", desc = "Mason (LSP)", action = ":Mason" },
            { icon = " ", key = "c", desc = "Config", action = ":e $MYVIMRC | cd %:p:h" },
            { icon = "󰒲 ", key = "l", desc = "Lazy", action = ":Lazy" },
            { icon = " ", key = "n", desc = "New File", action = ":ene | startinsert" },
            { icon = " ", key = "q", desc = "Quit", action = ":qa" },
          },
        },
        sections = {
          { section = "keys", gap = 1, padding = 2 },
          { section = "startup" },
        },
      },
    },
  },
}
