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

return {
  "saghen/blink.cmp",

  -- Stay on the stable Blink v1 series.
  version = "1.*",
  enabled = true,

  dependencies = {
    "L3MON4D3/LuaSnip",
    "rafamadriz/friendly-snippets",
    "moyiz/blink-emoji.nvim",

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

            -- Apply basic kind highlighting to unsupported LSPs.
            fallback = true,
            fallback_extra_info_hl = "@comment",
          },

          fallback_highlight = "@variable",
          max_width = 60,
        })
      end,
    },
  },

  init = function()
    local group = vim.api.nvim_create_augroup("BlinkCmpNvChadStyle", { clear = true })

    local function apply_highlights()
      -- Keep matched completion characters bold without forcing a color.
      vim.api.nvim_set_hl(0, "BlinkCmpLabelMatch", {
        bold = true,
      })
    end

    vim.api.nvim_create_autocmd("ColorScheme", {
      group = group,
      callback = apply_highlights,
    })

    vim.schedule(apply_highlights)
  end,

  opts = function(_, opts)
    ---------------------------------------------------------------------------
    -- Sources
    ---------------------------------------------------------------------------

    opts.sources = vim.tbl_deep_extend("force", opts.sources or {}, {
      -- Allow providers to return results when the keyword after a trigger
      -- character has zero characters.
      --
      -- This is important for:
      --   math.
      --   object.
      --   pointer->
      min_keyword_length = 0,

      providers = {
        lsp = {
          name = "LSP",
          module = "blink.cmp.sources.lsp",
          enabled = true,

          -- Required to show results immediately after `math.`.
          min_keyword_length = 0,

          score_offset = 90,

          -- Show buffer results alongside LSP results.
          fallbacks = {},

          opts = {
            -- Built-in Tailwind/CSS color preview.
            tailwind_color_icon = "■",
          },
        },

        path = {
          name = "Path",
          module = "blink.cmp.sources.path",
          enabled = true,

          min_keyword_length = 0,
          score_offset = 25,
          fallbacks = {},

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
          score_offset = 85,

          opts = {
            use_show_condition = true,
            show_autosnippets = true,
            prefer_doc_trig = false,
            use_label_description = true,
          },

          -- Only show snippets after typing the explicit `;` trigger.
          should_show_items = function()
            local trigger_pos = get_snippet_trigger()
            return trigger_pos ~= nil
          end,

          -- Remove the leading semicolon when accepting a snippet.
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

          -- Keep plain buffer words below semantic LSP results.
          score_offset = -5,
        },

        emoji = {
          name = "Emoji",
          module = "blink-emoji",
          enabled = true,

          min_keyword_length = 2,
          score_offset = 20,

          opts = {
            insert = true,

            -- Trigger emoji completion with:
            --   :smile
            --   :heart
            trigger = function()
              return { ":" }
            end,
          },
        },
      },
    })

    opts.sources.default = {
      "lsp",
      "path",
      "snippets",
      "buffer",
      "emoji",
    }

    -- Ensure an older `kind = "LSP"` override does not replace real kinds
    -- such as Function, Variable, Module and Constant.
    opts.sources.providers.lsp.kind = nil

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
        -- Prefetch candidates when entering Insert mode.
        prefetch_on_insert = true,

        -- Show while typing regular identifiers.
        show_on_keyword = true,

        -- Show immediately after an LSP trigger character:
        --
        --   math.
        --   object.
        --   pointer->
        show_on_trigger_character = true,

        -- Reopen after accepting an item whose result ends in a trigger
        -- character.
        show_on_accept_on_trigger_character = true,

        -- Reopen when entering Insert mode with the cursor immediately after
        -- a trigger character.
        show_on_insert_on_trigger_character = true,

        -- Do not automatically show merely because Insert mode was entered.
        show_on_insert = false,

        -- Keep completion hidden on whitespace.
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

        -- Avoid opening completion while jumping through snippet fields.
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

          -- colorful-menu combines the label, parameters, type information
          -- and label description.
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
        auto_show_delay_ms = 80,

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

          -- Prefer displaying documentation beside the completion menu.
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
      -- Selection and ghost text
      -----------------------------------------------------------------------

      list = {
        selection = {
          -- Select the first item so documentation appears immediately.
          preselect = true,

          -- Do not alter the buffer until completion is accepted.
          auto_insert = false,
        },
      },

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

        -- Include parameter documentation when the LSP provides it.
        show_documentation = true,

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
      preset = "super-tab",

      -- Select completion entries.
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

      -- Scroll completion documentation.
      ["<C-b>"] = {
        "scroll_documentation_up",
        "fallback",
      },

      ["<C-f>"] = {
        "scroll_documentation_down",
        "fallback",
      },

      -- Accept the selected completion.
      ["<CR>"] = {
        "accept",
        "fallback",
      },

      -- Manually show completion. When completion is already visible,
      -- show or hide its documentation.
      ["<C-space>"] = {
        "show",
        "show_documentation",
        "hide_documentation",
      },

      -- Toggle documentation.
      ["<C-e>"] = {
        "show_documentation",
        "hide_documentation",
        "fallback",
      },

      -- Toggle signature help.
      ["<C-k>"] = {
        "show_signature",
        "hide_signature",
        "fallback",
      },

      -- Close completion.
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

        Emoji = "󰞅",
      },
    })

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
