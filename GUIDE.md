# Guide

How this config is organised, what every key does, and how to change it.
The leader key is **Space**. Press `<leader>?` to see keymaps for the current buffer, or
`<leader>sk` to search all keymaps.

## Folder layout

```
nvim/
├── init.lua                 entry point (checks the Neovim version, loads config/)
├── install.sh               system-package installer
├── lazy-lock.json           pinned plugin versions
├── docs/                    extras such as the cheatsheet
└── lua/
    ├── config/
    │   ├── options.lua          editor options, leader key, loads local.lua
    │   ├── env.lua              detects Termux/tools, handles optional features
    │   ├── lazy.lua             plugin manager bootstrap and settings
    │   ├── autocmds.lua         autocommands
    │   ├── keymaps.lua          general keymaps
    │   ├── colorscheme-cycle.lua  picks a random colorscheme at startup
    │   └── local.example.lua    template for personal settings
    └── plugins/
        ├── core/    blink (completion), lsp, treesitter, mini, lint
        ├── git/     gitsigns, diffview, neogit, lazygit
        ├── ui/      colorscheme, indent, which-key, toggleterm
        ├── files/   neo-tree, oil, telescope
        └── dev/     dap (debugging), jupyter, unity
```

Load order: `options` → `lazy` (loads every plugin file) → `autocmds` → `keymaps` → `colorscheme-cycle`.

## Keybindings

### General

| Key | Action |
|-----|--------|
| `<Esc>` | clear search highlight |
| `<C-h>` `<C-j>` `<C-k>` `<C-l>` | move between windows |
| `<leader>q` | send workspace diagnostics to the quickfix list |
| `<leader>?` | show keymaps for this buffer |
| `<C-t>` | toggle floating terminal |

### Files

| Key | Action |
|-----|--------|
| `<leader>e` | Neo-tree (floating) |
| `<leader>E` | Neo-tree (left sidebar) |
| `-` | Oil: edit the parent directory like a buffer |
| `<leader>ff` | find files |
| `<leader>fg` | live grep |
| `<leader>fb` | open buffers |
| `<leader>fh` | help tags |
| `<leader>sk` | search keymaps |

Inside Neo-tree: `S` stage all, `ga` stage file, `gu` unstage file, `gr` revert file, `gc` commit.

### LSP and completion

| Key | Action |
|-----|--------|
| `gd` / `gD` | go to definition / declaration |
| `gi` | go to implementation |
| `grr` | references (built into Neovim) |
| `K` | hover documentation (built in) |
| `<leader>rn` | rename symbol |
| `<leader>ca` | code action |
| `<leader>cf` | format buffer |

Completion (blink.cmp, default preset): `<C-Space>` open menu, `<C-n>` / `<C-p>` next / previous,
`<C-y>` accept, `<C-e>` close.

### Git

| Key | Action |
|-----|--------|
| `]c` / `[c` | next / previous hunk |
| `<leader>hs` / `<leader>hr` | stage / reset hunk (works on a visual selection too) |
| `<leader>hS` / `<leader>hR` | stage / reset whole buffer |
| `<leader>hu` | undo stage hunk |
| `<leader>hp` | preview hunk |
| `<leader>hb` | blame line |
| `<leader>hd` / `<leader>hD` | diff this / diff against last commit |
| `<leader>tb` | toggle inline blame |
| `<leader>td` | toggle deleted lines |
| `ih` | hunk text object (for example `dih` deletes a hunk) |
| `<leader>gs` | Neogit status |
| `<leader>gd` | Diffview open |
| `<leader>gh` / `<leader>gH` | file history (repo / current file) |
| `<leader>gc` | close Diffview |
| `<leader>gg` | LazyGit (only if `lazygit` is installed) |

### Debugging

| Key | Action |
|-----|--------|
| `<F5>` or `<leader>dc` | start / continue |
| `<F10>` | step over |
| `<F11>` | step into |
| `<F12>` | step out |
| `<leader>db` | toggle breakpoint |
| `<leader>dC` | run to cursor |
| `<leader>dt` | terminate |
| `<leader>du` | toggle debug UI |
| `<leader>dr` | toggle REPL |

C, C++ and Rust use codelldb, assembly uses gdb. On Termux install a debugger from `pkg`.

### Editing helpers (mini.nvim)

- Auto-pairs close `()`, `[]`, `""` for you.
- Surround: `sa` add, `sd` delete, `sr` replace (for example `saiw"` wraps a word in quotes).
- `gc` toggles comments (`gcc` for one line).

### Colorschemes

A random scheme is chosen at every start and never the same twice in a row.
`<leader>kd` switches to kanagawa-dragon. Use `:colorscheme <name>` for any other.

### Jupyter (only when enabled)

`<leader>mi` init kernel, `me` evaluate operator, `ms` evaluate selection, `mr` re-run cell,
`mo` / `mh` show / hide output, `md` delete cell.

## Plugin manager cheatsheet

| Command | What it does |
|---------|--------------|
| `:Lazy` | open the plugin UI |
| `:Lazy sync` | install, update and clean plugins |
| `:Lazy restore` | go back to the versions in `lazy-lock.json` |
| `:Mason` | manage language servers (not on Termux) |
| `:checkhealth` | diagnose problems |

## Optional features

Create your personal file once:

```bash
cp lua/config/local.example.lua lua/config/local.lua
```

Then uncomment what you need:

```lua
vim.g.enable_jupyter = true   -- needs python, pynvim, jupyter_client, a kitty-compatible terminal
vim.g.enable_unity = true     -- needs dotnet; the Unity adapter also needs a Rust toolchain
vim.g.python3_host_prog = "/path/to/python"
```

You can also use environment variables instead: `NVIM_JUPYTER=1`, `NVIM_UNITY=1`, `NVIM_PYTHON=/path`.
`local.lua` is gitignored, so your personal paths never reach the public repo.

## How platform support works

`lua/config/env.lua` checks the platform and which tools exist, and every plugin file asks it
before enabling anything.

- **Normal Linux:** Mason installs language servers automatically.
- **Termux:** Mason is turned off. Install servers with `pkg` (for example `clang`,
  `lua-language-server`, `rust-analyzer`) and the config enables the ones it finds.
- **Missing tool:** that one feature is skipped without an error.

## Customizing

- **Add a plugin:** create a file in the matching `lua/plugins/<group>/` folder that returns a
  plugin spec. Restart Neovim and run `:Lazy sync`.
- **Add a language server:** add its lspconfig name to the `servers` list in
  `lua/plugins/core/lsp.lua`. If it needs an installer such as `npm`, add it to the `needs` table.
- **Add a treesitter language:** add it to the `ts.install` list in `lua/plugins/core/treesitter.lua`.
- **Change the colorscheme pool:** edit the `schemes` list in `lua/config/colorscheme-cycle.lua`,
  or replace the file's body with a single `vim.cmd.colorscheme("name")`.
- **New keymaps:** general ones go in `lua/config/keymaps.lua`. Keys that belong to a plugin
  stay in that plugin's file.

## Updating

```bash
cd ~/.config/nvim && git pull
nvim --headless "+Lazy! sync" +qa
```

## Troubleshooting

| Problem | Fix |
|---------|-----|
| Download timeouts or `unexpected eof` | re-run `:Lazy sync`; run `git config --global http.version HTTP/1.1` |
| "needs Neovim >= 0.11" | install a newer Neovim |
| No syntax highlighting for a language | install the `tree-sitter` CLI and a C compiler, then restart |
| Telescope grep does nothing | install `ripgrep` |
| Missing icons | use a Nerd Font in your terminal |
| `<leader>gg` does nothing | install `lazygit` |
| Language server not starting | `:LspInfo`, then install the server (`:Mason`, or `pkg`/`pacman` on Termux/Arch) |
