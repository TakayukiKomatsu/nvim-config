# Mac-focused LazyVim Configuration

This repository contains a **Mac-terminal-first Neovim configuration** built on top of [LazyVim](https://github.com/LazyVim/LazyVim).

It is optimized for:
- terminal usage on macOS
- Option/Alt-based keymaps instead of Command-key mappings
- `blink.cmp` for completion
- `nvim-tree` for file browsing
- a layered config model where Mac-specific UX overrides generic defaults

## Documentation hierarchy

- **`README.md`** — maintainer entrypoint: what the repo is, where to look, and how to work safely
- **`CLAUDE.md`** — deeper architecture and workflow reference
- **`AGENTS.md`** — project rules, conventions, and guardrails

Start here, then go deeper only when needed.

## Load order

LazyVim handles the lifecycle for us:

1. `init.lua` sets leaders and bootstraps lazy.nvim
2. `lua/config/lazy.lua` runs `lazy.setup` (imports LazyVim + our `plugins/` tree)
3. `lua/config/options.lua` loads **before** plugins (pre-plugin options layer)
4. On `VeryLazy`, LazyVim loads `lua/config/autocmds.lua`, then `lua/config/keymaps.lua`
5. `lua/config/keymaps.lua` requires each feature module under `lua/config/keymaps/`

The **final global UX layer** is therefore the `keymaps/` submodules; plugin `keys = {}` specs still own their own lazy triggers.

## Where to edit things

| Goal | Primary file(s) |
|---|---|
| Change global keymaps (by feature) | `lua/config/keymaps/{file,navigation,search,editing,window,clipboard,insert,toggle}.lua` |
| Change options (base + Mac integration) | `lua/config/options.lua` |
| Change autocommands (incl. Mac-specific) | `lua/config/autocmds.lua` |
| Add or adjust a plugin | `lua/plugins/*.lua` |
| Change LSP server setup | `lua/plugins/lsp/mason.lua`, `lua/plugins/lsp/lspconfig.lua` |
| Change language-specific tooling | `lua/plugins/typescript.lua`, `lua/plugins/java.lua`, `lua/plugins/rust.lua` |
| Change completion | `lua/plugins/blink.lua` |
| Change formatting | `lua/plugins/conform.lua` (format keys live here) |
| Change file explorer behavior | `lua/plugins/nvim-tree.lua` (keys live in the plugin spec) |

For deeper file-by-file ownership notes, see `CLAUDE.md` and `AGENTS.md`.

## Current repo shape

- `lua/config/` contains the core config layer
- `lua/plugins/` contains plugin specs, mostly one file per plugin
- `lua/plugins/lsp/` contains the shared LSP/tooling layer
- `lazyvim.json` records enabled LazyVim extras
- `lazy-lock.json` records pinned plugin versions

## Local maintainer workflow

This repo uses a **local-only** maintenance workflow.

Common checks:

```bash
nvim --headless "+qa"
```

Inside Neovim:

- `:Lazy` / `:Lazy sync` — inspect or sync plugins after spec changes
- `:Mason` — inspect installed tooling
- `:LspInfo` / `:LspRestart` — inspect or restart LSP state
- `:checkhealth` — general diagnostics

If `stylua` is installed on your machine, you can also run:

```bash
stylua lua/
```

For deeper reload/debugging notes, see the Development Workflow section in `CLAUDE.md`.

## Keymap maintenance notes

- Global keymaps live under `lua/config/keymaps/` split by feature (file / navigation / search / editing / window / clipboard / insert / toggle)
- Plugin `keys = {}` definitions still matter for lazy-loaded behavior (format, nvim-tree, telescope, refactoring, rust, dap, …)
- `lua/plugins/lsp/lspconfig.lua` adds buffer-local LSP mappings
- `lua/plugins/mini.lua` registers the `mini.clue` group labels for `<Leader>*` submenus

If you are changing keymaps, grep both `lua/config/keymaps/` and `lua/plugins/*` before adding new bindings.

## Plugin organization and loading notes

- `lua/plugins/` is still mostly one file per plugin
- intentional exceptions are limited to shared areas like `lua/plugins/init.lua`, `lua/plugins/disabled.lua`, and `lua/plugins/lsp/`
- several clearly on-demand plugins now opt into `lazy = true`, while the repo-wide default in `lua/config/lazy.lua` remains unchanged

## Current state reminders

- active file explorer: **`nvim-tree`**
- active colorscheme path: `lua/plugins/colorschema.lua` with `witch-dark` / `witch`
- completion engine: **`blink.cmp`**
- validation scope: **local only**

## Terminal setup

For Option-key mappings to work correctly:

- **iTerm2**: set Left Option Key to **Esc+**
- **Terminal.app**: enable **Use Option as Meta key**
