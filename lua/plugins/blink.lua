local trigger_text = ";"
local escaped_trigger = vim.pesc(trigger_text)

-- Finds an explicitly triggered snippet such as:
--   ;func
--   ;my_snippet
--   ;react-component
--
-- Returns:
--   trigger_pos: one-based byte position of the semicolon
--   cursor_col:  zero-based byte position of the cursor
local function get_snippet_trigger()
  local cursor_col = vim.api.nvim_win_get_cursor(0)[2]
  local before_cursor = vim.api.nvim_get_current_line():sub(1, cursor_col)

  local trigger_pos = before_cursor:find(escaped_trigger .. "[%w_%-]*$")

  return trigger_pos, cursor_col
end

-- Keeps additional sources added by LazyVim or other plugins, while ensuring
-- our required sources exist and removing the old emoji source.
local function merge_default_sources(existing, required)
  local merged = {}
  local seen = {}

  local function add(source)
    if source == "emoji" or seen[source] then
      return
    end

    seen[source] = true
    table.insert(merged, source)
  end

  if type(existing) == "table" then
    for _, source in ipairs(existing) do
      add(source)
    end
  end

  for _, source in ipairs(required) do
    add(source)
  end

  return merged
end

return {
  "saghen/blink.cmp",

  -- Stay on Blink's stable v1 series.
  version = "1.*",
  enabled = true,

  dependencies = {
    "L3MON4D3/LuaSnip",
    "rafamadriz/friendly-snippets",

    {
      "xzbdmw/colorful-menu.nvim",

      config = function()
        require("colorful-menu").setup({
          ls = {
            lua_ls = {
              arguments_hl = "@comment",
            },

            gopls = {
              -- Align Go types and return values to the right.
              align_type_to_right = true,
              add_colon_before_type = false,
              preserve_type_when_truncate = true,
            },

            ts_ls = {
              extra_info_hl = "@comment",
            },

            vtsls = {
              extra_info_hl = "@comment",
            },

            ["rust-analyzer"] = {
              extra_info_hl = "@comment",
              align_type_to_right = true,
              preserve_type_when_truncate = true,
            },

            clangd = {
              extra_info_hl = "@comment",
              align_type_to_right = true,
              preserve_type_when_truncate = true,
              import_dot_hl = "@comment",
            },

            zls = {
              align_type_to_right = true,
            },

            roslyn = {
              extra_info_hl = "@comment",
            },

            dartls = {
              extra_info_hl = "@comment",
            },

            basedpyright = {
              extra_info_hl = "@comment",
            },

            pyright = {
              extra_info_hl = "@comment",
            },

            pylsp = {
              extra_info_hl = "@comment",
              arguments_hl = "@comment",
            },

            -- Apply basic highlighting to unsupported language servers.
            fallback = true,
            fallback_extra_info_hl = "@comment",
          },

          fallback_highlight = "@variable",
          max_width = 60,
        })
      end,
    },
  },

  opts = function(_, opts)
    ---------------------------------------------------------------------------
    -- Highlights
    ---------------------------------------------------------------------------

    local highlight_group = vim.api.nvim_create_augroup("BlinkCmpCustomHighlights", { clear = true })

    local function apply_highlights()
      -- Preserve the colorscheme's foreground while making fuzzy matches bold.
      local ok, current = pcall(vim.api.nvim_get_hl, 0, {
        name = "BlinkCmpLabelMatch",
        link = false,
      })

      if not ok then
        current = {}
      end

      current.bold = true

      vim.api.nvim_set_hl(0, "BlinkCmpLabelMatch", current)
    end

    vim.api.nvim_create_autocmd("ColorScheme", {
      group = highlight_group,
      callback = apply_highlights,
    })

    vim.schedule(apply_highlights)

    ---------------------------------------------------------------------------
    -- Sources
    ---------------------------------------------------------------------------

    local existing_default_sources = opts.sources and opts.sources.default or nil

    opts.sources = vim.tbl_deep_extend("force", opts.sources or {}, {
      -- Allow providers to return results when there are zero characters
      -- after an LSP trigger character:
      --
      --   math.
      --   object.
      --   pointer->
      min_keyword_length = 0,

      providers = {
        lsp = {
          name = "LSP",
          module = "blink.cmp.sources.lsp",
          enabled = true,

          -- Required for completion immediately after `math.`.
          min_keyword_length = 0,

          -- Prefer semantic LSP completions without overpowering Blink's
          -- fuzzy score, frecency and proximity ranking.
          score_offset = 4,

          -- Buffer words only appear if the LSP and other providers using
          -- this fallback return no candidates.
          fallbacks = {
            "buffer",
          },

          opts = {
            -- Built-in Tailwind/CSS completion color preview.
            tailwind_color_icon = "■",
          },
        },

        path = {
          name = "Path",
          module = "blink.cmp.sources.path",
          enabled = true,

          min_keyword_length = 0,
          score_offset = 2,

          fallbacks = {
            "buffer",
          },

          opts = {
            trailing_slash = false,
            label_trailing_slash = true,
            show_hidden_files_by_default = true,

            -- Resolve relative paths from the current file's directory.
            get_cwd = function(context)
              return vim.fn.expand(("#%d:p:h"):format(context.bufnr))
            end,
          },
        },

        snippets = {
          name = "Snippets",
          module = "blink.cmp.sources.snippets",
          enabled = true,

          max_items = 15,
          min_keyword_length = 1,
          score_offset = 3,

          opts = {
            use_show_condition = true,
            show_autosnippets = true,
            prefer_doc_trig = false,
            use_label_description = true,
          },

          -- Only show snippets after the explicit `;` trigger.
          should_show_items = function()
            local trigger_pos = get_snippet_trigger()
            return trigger_pos ~= nil
          end,

          -- Remove the leading semicolon and typed trigger when accepting
          -- the selected snippet.
          transform_items = function(_, items)
            local trigger_pos, cursor_col = get_snippet_trigger()

            if not trigger_pos then
              return items
            end

            local line = vim.api.nvim_win_get_cursor(0)[1] - 1

            for _, item in ipairs(items) do
              local new_text = (item.textEdit and item.textEdit.newText) or item.insertText or item.label

              item.textEdit = {
                newText = new_text,

                range = {
                  start = {
                    line = line,
                    character = trigger_pos - 1,
                  },

                  ["end"] = {
                    line = line,
                    character = cursor_col,
                  },
                },
              }
            end

            return items
          end,
        },

        buffer = {
          name = "Buffer",
          module = "blink.cmp.sources.buffer",
          enabled = true,

          max_items = 5,
          min_keyword_length = 4,

          -- Keep ordinary buffer words below semantic candidates.
          score_offset = -3,
        },
      },
    })

    -- Force clean fallback lists in case a previous LazyVim configuration
    -- added or retained additional entries during table merging.
    opts.sources.providers.lsp.fallbacks = {
      "buffer",
    }

    opts.sources.providers.path.fallbacks = {
      "buffer",
    }

    opts.sources.default = merge_default_sources(existing_default_sources, {
      "lsp",
      "path",
      "snippets",
      "buffer",
    })

    -- Remove the retired emoji provider if another merged configuration left
    -- it behind.
    opts.sources.providers.emoji = nil

    -- Prevent an older `kind = "LSP"` override from replacing real kinds such
    -- as Function, Variable, Module and Constant.
    opts.sources.providers.lsp.kind = nil
    opts.sources.providers.lsp.name = "LSP"

    ---------------------------------------------------------------------------
    -- Completion
    ---------------------------------------------------------------------------

    opts.completion = vim.tbl_deep_extend("force", opts.completion or {}, {
      keyword = {
        range = "prefix",
      },

      accept = {
        auto_brackets = {
          enabled = true,
        },
      },

      -----------------------------------------------------------------------
      -- Trigger behavior
      -----------------------------------------------------------------------

      trigger = {
        -- Prepare completion candidates when entering Insert mode.
        prefetch_on_insert = true,

        -- Show while typing ordinary identifiers.
        show_on_keyword = true,

        -- Show after LSP trigger characters such as `.`.
        show_on_trigger_character = true,

        -- Reopen after accepting an item that ends with a trigger character.
        show_on_accept_on_trigger_character = true,

        -- Reopen when entering Insert mode immediately after a trigger
        -- character.
        show_on_insert_on_trigger_character = true,

        -- Do not show merely because Insert mode was entered.
        show_on_insert = false,

        -- Avoid opening on whitespace.
        show_on_blocked_trigger_characters = {
          " ",
          "\n",
          "\t",
        },

        show_on_x_blocked_trigger_characters = {
          "'",
          '"',
          "(",
        },

        -- Prevent completion from fighting with active snippet placeholders.
        show_in_snippet = false,
      },

      -----------------------------------------------------------------------
      -- Completion menu
      -----------------------------------------------------------------------

      menu = {
        border = "rounded",

        min_width = 20,
        max_height = 12,
        scrolloff = 1,

        scrollbar = true,
        winblend = 0,

        direction_priority = {
          "s",
          "n",
        },

        winhighlight = table.concat({
          "Normal:BlinkCmpMenu",
          "FloatBorder:BlinkCmpMenuBorder",
          "CursorLine:BlinkCmpMenuSelection",
          "Search:None",
        }, ","),

        auto_show = function(ctx)
          return ctx.mode ~= "cmdline" and vim.bo.buftype ~= "prompt"
        end,

        draw = {
          align_to = "label",

          padding = {
            0,
            1,
          },

          gap = 1,
          snippet_indicator = "~",

          -- Colorful Menu already combines the label, label detail, type,
          -- parameters and label description.
          columns = {
            {
              "kind_icon",
            },

            {
              "label",
              gap = 1,
            },

            {
              "kind",
            },
          },

          components = {
            kind_icon = {
              ellipsis = false,

              text = function(ctx)
                return ctx.kind_icon .. ctx.icon_gap
              end,

              highlight = function(ctx)
                return {
                  {
                    group = ctx.kind_hl,
                    priority = 20000,
                  },
                }
              end,
            },

            label = {
              ellipsis = true,

              width = {
                fill = true,
                max = 60,
              },

              text = function(ctx)
                return require("colorful-menu").blink_components_text(ctx)
              end,

              highlight = function(ctx)
                return require("colorful-menu").blink_components_highlight(ctx)
              end,
            },

            kind = {
              ellipsis = false,

              width = {
                min = 7,
                max = 12,
              },

              text = function(ctx)
                return ctx.kind
              end,

              highlight = function(ctx)
                return ctx.kind_hl
              end,
            },
          },
        },
      },

      -----------------------------------------------------------------------
      -- Documentation window
      -----------------------------------------------------------------------

      documentation = {
        auto_show = true,

        -- A slightly calmer delay prevents the documentation window from
        -- flashing while quickly moving through completion candidates.
        auto_show_delay_ms = 150,

        -- Blink requires this to be at least 50.
        update_delay_ms = 50,

        treesitter_highlighting = true,

        window = {
          border = "rounded",

          min_width = 42,
          max_width = 80,
          max_height = 20,

          scrollbar = true,
          winblend = 0,

          winhighlight = table.concat({
            "Normal:BlinkCmpDoc",
            "FloatBorder:BlinkCmpDocBorder",
            "EndOfBuffer:BlinkCmpDoc",
            "Search:None",
          }, ","),

          -- Prefer showing documentation beside the completion menu.
          direction_priority = {
            menu_north = {
              "e",
              "w",
              "n",
              "s",
            },

            menu_south = {
              "e",
              "w",
              "s",
              "n",
            },
          },
        },
      },

      -----------------------------------------------------------------------
      -- Selection
      -----------------------------------------------------------------------

      list = {
        max_items = 100,

        selection = {
          -- Normally select the first item so documentation appears
          -- immediately. Do not preselect while a forward snippet jump is
          -- available, preventing Super-Tab from accepting an unrelated
          -- completion instead of moving to the next placeholder.
          preselect = function()
            return not require("blink.cmp").snippet_active({
              direction = 1,
            })
          end,

          -- Never modify the buffer until an item is explicitly accepted.
          auto_insert = false,
        },

        cycle = {
          from_bottom = true,
          from_top = true,
        },
      },

      -----------------------------------------------------------------------
      -- Ghost text
      -----------------------------------------------------------------------

      ghost_text = {
        enabled = true,

        show_with_selection = true,
        show_without_selection = false,

        show_with_menu = true,
        show_without_menu = false,
      },
    })

    ---------------------------------------------------------------------------
    -- Ranking
    ---------------------------------------------------------------------------

    opts.fuzzy = vim.tbl_deep_extend("force", opts.fuzzy or {}, {
      sorts = {
        "exact",
        "score",
        "sort_text",
      },
    })

    ---------------------------------------------------------------------------
    -- Signature help
    ---------------------------------------------------------------------------

    opts.signature = vim.tbl_deep_extend("force", opts.signature or {}, {
      enabled = true,

      trigger = {
        enabled = true,

        show_on_keyword = false,
        show_on_trigger_character = true,

        show_on_insert = false,
        show_on_insert_on_trigger_character = true,

        blocked_trigger_characters = {},
        blocked_retrigger_characters = {},
      },

      window = {
        border = "rounded",

        min_width = 20,
        max_width = 80,
        max_height = 10,

        scrollbar = false,
        treesitter_highlighting = true,

        -- Keep signature help compact. Full symbol documentation remains
        -- available in the completion documentation window.
        show_documentation = false,

        direction_priority = {
          "n",
          "s",
        },

        winblend = 0,

        winhighlight = table.concat({
          "Normal:BlinkCmpSignatureHelp",
          "FloatBorder:BlinkCmpSignatureHelpBorder",
        }, ","),
      },
    })

    ---------------------------------------------------------------------------
    -- LuaSnip
    ---------------------------------------------------------------------------

    opts.snippets = {
      preset = "luasnip",
    }

    ---------------------------------------------------------------------------
    -- Keymaps
    ---------------------------------------------------------------------------

    opts.keymap = {
      -- Tab accepts visible completion items, moves through snippet fields,
      -- and otherwise falls back to normal indentation.
      preset = "super-tab",

      -------------------------------------------------------------------------
      -- Select completion entries
      -------------------------------------------------------------------------

      ["<Up>"] = {
        "select_prev",
        "fallback",
      },

      ["<Down>"] = {
        "select_next",
        "fallback",
      },

      ["<C-p>"] = {
        "select_prev",
        "fallback_to_mappings",
      },

      ["<C-n>"] = {
        "select_next",
        "fallback_to_mappings",
      },

      -------------------------------------------------------------------------
      -- Completion documentation scrolling
      -------------------------------------------------------------------------

      ["<C-b>"] = {
        "scroll_documentation_up",
        "fallback",
      },

      ["<C-f>"] = {
        "scroll_documentation_down",
        "fallback",
      },

      -------------------------------------------------------------------------
      -- Accept/show/hide
      -------------------------------------------------------------------------

      ["<CR>"] = {
        "accept",
        "fallback",
      },

      ["<C-space>"] = {
        "show",
        "show_documentation",
        "hide_documentation",
      },

      -- Standard predictable close key.
      ["<C-e>"] = {
        "hide",
        "fallback",
      },

      -- Keep <C-k> available for insert-mode Up navigation from
      -- lua/config/keymaps/insert.lua.
      ["<A-k>"] = {
        "show_signature",
        "hide_signature",
        "fallback",
      },

      ["<Esc>"] = {
        "hide",
        "fallback",
      },
    }

    ---------------------------------------------------------------------------
    -- Appearance
    ---------------------------------------------------------------------------

    opts.appearance = vim.tbl_deep_extend("force", opts.appearance or {}, {
      use_nvim_cmp_as_default = false,
      nerd_font_variant = "mono",

      kind_icons = {
        Text = "󰉿",
        Method = "󰊕",
        Function = "󰊕",
        Constructor = "󰒓",

        Field = "󰜢",
        Variable = "󰆦",
        Property = "󰖷",

        Class = "󰠱",
        Interface = "󰠱",
        Struct = "󰠱",
        Module = "󰅩",

        Unit = "󰪚",
        Value = "󰦨",
        Enum = "󰦨",
        EnumMember = "󰦨",

        Keyword = "󰻾",
        Constant = "󰏿",

        Snippet = "󰩫",
        Color = "󰏘",
        File = "󰈔",
        Reference = "󰬲",
        Folder = "󰉋",

        Event = "󱐋",
        Operator = "󰪚",
        TypeParameter = "󰬛",
      },
    })

    -- Remove an old custom emoji icon if it survived a merged config.
    opts.appearance.kind_icons.Emoji = nil

    ---------------------------------------------------------------------------
    -- Command-line completion
    ---------------------------------------------------------------------------

    opts.cmdline = vim.tbl_deep_extend("force", opts.cmdline or {}, {
      enabled = true,

      keymap = {
        preset = "cmdline",
      },

      completion = {
        trigger = {
          show_on_blocked_trigger_characters = {},
          show_on_x_blocked_trigger_characters = {},
        },

        menu = {
          auto_show = true,
        },

        list = {
          selection = {
            preselect = false,
            auto_insert = false,
          },
        },

        ghost_text = {
          enabled = true,
        },
      },
    })

    return opts
  end,
}
