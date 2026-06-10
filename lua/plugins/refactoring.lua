-- refactoring.nvim: Extract function, variable, inline, etc.
return {
  "ThePrimeagen/refactoring.nvim",
  lazy = true,
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter",
    "lewis6991/async.nvim",
  },
  opts = {
    prompt_func_return_type = {
      go = true,
      cpp = true,
      c = true,
      java = true,
    },
    prompt_func_param_type = {
      go = true,
      cpp = true,
      c = true,
      java = true,
    },
  },
  keys = {
    -- Extract operations (visual mode)
    {
      "<leader>re",
      function() require("refactoring").refactor("Extract Function") end,
      mode = "x",
      desc = "Extract function",
    },
    {
      "<leader>rf",
      function() require("refactoring").refactor("Extract Function To File") end,
      mode = "x",
      desc = "Extract function to file",
    },
    {
      "<leader>rv",
      function() require("refactoring").refactor("Extract Variable") end,
      mode = "x",
      desc = "Extract variable",
    },

    -- Inline operations
    {
      "<leader>ri",
      function() require("refactoring").refactor("Inline Variable") end,
      mode = { "n", "x" },
      desc = "Inline variable",
    },
    {
      "<leader>rI",
      function() require("refactoring").refactor("Inline Function") end,
      mode = "n",
      desc = "Inline function",
    },

    -- Extract block (normal mode)
    {
      "<leader>rb",
      function() require("refactoring").refactor("Extract Block") end,
      mode = "n",
      desc = "Extract block",
    },
    {
      "<leader>rB",
      function() require("refactoring").refactor("Extract Block To File") end,
      mode = "n",
      desc = "Extract block to file",
    },

    -- Picker for all refactors (uses vim.ui.select; dressing.nvim enhances it)
    {
      "<leader>rr",
      function() require("refactoring").select_refactor() end,
      mode = { "n", "x" },
      desc = "Refactoring menu",
    },

    -- Debug print statements
    {
      "<leader>rp",
      function() require("refactoring").debug.printf({ below = false }) end,
      mode = "n",
      desc = "Debug print",
    },
    {
      "<leader>rP",
      function() require("refactoring").debug.print_var() end,
      mode = { "n", "x" },
      desc = "Debug print variable",
    },
    {
      -- Moved from <leader>rc to avoid collision with crates.nvim's <leader>rc* prefix (rust.lua).
      "<leader>rx",
      function() require("refactoring").debug.cleanup({}) end,
      mode = "n",
      desc = "Cleanup debug prints",
    },
  },
  config = function(_, opts)
    -- Resolve an `async` module name collision. Two installed plugins both ship a
    -- top-level `lua/async.lua` claiming `require("async")`:
    --   * lewis6991/async.nvim   -- refactoring.nvim needs this (.run/.wrap/.await_all)
    --   * kevinhwang91/promise-async -- nvim-ufo needs this (callable: async(fn))
    -- Whichever loads first wins `package.loaded["async"]`; once ufo loads,
    -- refactoring crashes on `async.run` (nil). The two APIs are disjoint
    -- (refactoring uses field access, ufo uses the __call form), so install a
    -- merged proxy that satisfies both regardless of load order.
    local async_nvim = require("async.nvim")
    local promise_async = package.loaded["async"]
    if not (type(promise_async) == "table" and promise_async.sync) then
      local ok, pa = pcall(dofile, vim.fn.stdpath("data") .. "/lazy/promise-async/lua/async.lua")
      promise_async = (ok and pa) or nil
    end
    if promise_async then
      package.loaded["async"] = setmetatable({}, {
        __index = function(_, k)
          local v = async_nvim[k]
          if v ~= nil then return v end
          return promise_async[k]
        end,
        __call = function(_, ...) return promise_async(...) end,
      })
    else
      package.loaded["async"] = async_nvim
    end
    require("refactoring").setup(opts)
    -- select_refactor() uses vim.ui.select, which dressing.nvim prettifies.
  end,
}
