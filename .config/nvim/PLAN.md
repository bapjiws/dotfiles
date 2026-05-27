# Neovim Config Migration Plan

## Package Manager

Migrate from `packer.nvim` (archived) to `lazy.nvim`.
`impatient.nvim` is removed — lazy.nvim handles startup caching natively.

## Commit Strategy

1. **Main migration commit** — everything listed below
2. **Separate commit** — telescope → snacks.picker (for easy rollback)

---

## Remove Entirely

| Plugin | Reason |
|--------|--------|
| `wbthomason/packer.nvim` | Replaced by lazy.nvim |
| `lewis6991/impatient.nvim` | Obsolete with lazy.nvim |
| `tamago324/nlsp-settings.nvim` | Unused — no config, no calls |
| `MunifTanjim/nui.nvim` | No remaining dependents |
| `HakonHarnes/img-clip.nvim` | Not used |
| `goolord/alpha-nvim` | → snacks.dashboard |
| `voldikss/vim-floaterm` | → snacks.terminal |
| `stevearc/dressing.nvim` | → snacks.input |
| `karb94/neoscroll.nvim` | → snacks.scroll |
| `lukas-reineke/indent-blankline.nvim` | → snacks.indent (rainbow config was broken — rainbow-delimiters plugin missing) |
| `nvimtools/none-ls.nvim` + `none-ls-extras.nvim` | → conform.nvim + nvim-lint |
| `tpope/vim-surround` | → kylechui/nvim-surround (Lua, better dot-repeat) |
| `chrisbra/Colorizer` | → catgoose/nvim-colorizer.lua |

### Separate commit
| Plugin | Reason |
|--------|--------|
| `nvim-telescope/telescope.nvim` | → snacks.picker |
| `nvim-lua/plenary.nvim` | Only needed by telescope |

---

## Add

| Plugin | Purpose |
|--------|---------|
| `folke/lazy.nvim` | Package manager |
| `stevearc/conform.nvim` | Formatting: prettierd (project-local), stylua |
| `mfussenegger/nvim-lint` | Linting: eslint |
| `kylechui/nvim-surround` | Surround motions (replaces vim-surround) |
| `catgoose/nvim-colorizer.lua` | Hex/CSS colour highlighting |
| `folke/which-key.nvim` | Keybinding discovery popup on `<leader>` pause |

---

## Keep, Wire Up Properly

### `snacks.nvim`
Already installed (pulled in by opencode.nvim). Expand opts to enable:
- `dashboard` — replaces alpha-nvim; preserve ASCII header + button layout
- `terminal` — replaces vim-floaterm; migrate keymaps:
  - `<leader>vct` → lazygit float (use snacks.lazygit directly)
  - `<leader>fex` → ranger float
  - `<leader>trm` → fish terminal float
- `scroll` — replaces neoscroll (default config is sufficient)
- `indent` — replaces indent-blankline; clean single-colour guides + scope underline
- `input` — replaces dressing (already partially configured)
- `picker` — replaces telescope (separate commit); full keymap mapping below

### `render-markdown.nvim`
Installed but not loaded. Needs:
- Config file: `lua/user/render-markdown.lua`
- Entry in `init.lua`

### `nvim-tree`
Keep as-is — feature gap with snacks.explorer is too large (diagnostics icons, update_focused_file, git glyphs).

### Code completion (deferred)
`nvim-cmp` stays for now. Copilot source removed (was broken — plugin not installed).
Future: evaluate `minuet-ai.nvim` for local LLM inline completions.

---

## Files to Delete

After migration these config files become dead:
- `lua/user/alpha.lua`
- `lua/user/floaterm.lua`
- `lua/user/impatient.lua`
- `lua/user/indentline.lua`
- `lua/user/neoscroll.lua`
- `lua/user/lsp/null-ls.lua`
- `lua/user/telescope.lua` (separate commit)

---

## Bugs to Fix

### LSP setup
- **`vim.lsp.config()` without `vim.lsp.enable()`** — servers configured but not started.
  Fix: replace the manual loop with mason-lspconfig `setup_handlers` calling `lspconfig[server].setup(opts)`.
- **`tsserver` → `ts_ls` name mismatch** in `handlers.lua` line 77.
  The `document_formatting = false` guard for TypeScript never fires.
- **`update_in_insert = true`** in diagnostic config — diagnostics fire while typing.
  Fix: set to `false`.

### Keymaps
- **`<leader>cmd` conflict** — bound to both `telescope.commands` and `opencode.select()`.
  Resolution: `<leader>cmd` → opencode only. Telescope commands keymap dropped.
- **`<leader>fmt`** — currently calls `vim.lsp.buf.format()` directly.
  After adding conform, route through `require("conform").format()` instead.

---

## snacks.picker Keymap Mapping (for separate commit)

| Keymap | Old (telescope) | New (snacks.picker) |
|--------|----------------|---------------------|
| `<leader>sif` | `find_files()` | `Snacks.picker.files()` |
| `<leader>fwf` | `find_files({ default_text = cword })` | `Snacks.picker.files({ pattern = cword })` |
| `<leader>sip` | `live_grep()` | `Snacks.picker.grep()` |
| `<leader>fwp` | `live_grep({ default_text = cword })` | `Snacks.picker.grep_word()` |
| `<leader>fqp` | `live_grep({ default_text = quoted_str })` | `Snacks.picker.grep({ search = quoted_str })` |
| `<leader>sib` | `buffers()` | `Snacks.picker.buffers()` |
| `<leader>cmh` | `command_history()` | `Snacks.picker.command_history()` |
| `<leader>sih` | `help_tags()` | `Snacks.picker.help()` |
| `<leader>fwh` | `help_tags({ default_text = cword })` | `Snacks.picker.help({ pattern = cword })` |
| `<leader>rfc` | `lsp_references()` | `Snacks.picker.lsp_references()` |
| `<leader>vst` | `git_status()` | `Snacks.picker.git_status()` |
