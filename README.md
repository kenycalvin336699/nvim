# nvim

A fast, portable Neovim configuration built on [lazy.nvim](https://github.com/folke/lazy.nvim).
It runs on **Arch**, **Debian/Ubuntu**, **Fedora** and **Termux (Android)**, and it is built to
start without errors even when optional tools are missing.

> Requires **Neovim 0.11 or newer**.

## Features

- LSP (clangd, rust-analyzer, lua-language-server, html, css, jdtls) with `blink.cmp` completion
- Treesitter highlighting and indentation
- Telescope fuzzy finding, Neo-tree and Oil file browsing
- Git: gitsigns, diffview, neogit, lazygit
- Debugging (nvim-dap + UI) for C, C++, Rust, assembly
- Linting, auto-pairs, surround, comments, which-key hints
- A different colorscheme on every start (catppuccin, tokyonight, kanagawa, nightfox)
- Optional: Jupyter (molten) and Unity support, off by default

## Install

### Quick install

```bash
git clone https://github.com/YOUR_USER/YOUR_REPO.git ~/.config/nvim
~/.config/nvim/install.sh
```

`install.sh` detects your system, installs the needed packages, and syncs the plugins.

### Manual install

1. Install Neovim 0.11+, `git`, a C compiler, `ripgrep`, `fd`, `unzip`, `curl`.
2. Clone the repo into `~/.config/nvim`.
3. Run `nvim --headless "+Lazy! sync" +qa`, then start `nvim`.

### Termux

```bash
pkg install git
git clone https://github.com/YOUR_USER/YOUR_REPO.git ~/.config/nvim
~/.config/nvim/install.sh
```

Install a Nerd Font through Termux:Styling so icons display correctly.
Language servers come from `pkg` on Termux, not Mason, because Mason's downloaded binaries
cannot run on Android.

## Optional tools

| Tool | Used for |
|------|----------|
| `ripgrep`, `fd` | Telescope search |
| `tree-sitter` CLI + C compiler | compiling treesitter parsers |
| `lazygit` | the `<leader>gg` Git UI |
| `node` / `npm` | html and css language servers |
| `java` | the Java language server (jdtls) |

A missing tool never breaks startup. The matching feature is simply skipped.

## Personal settings

Copy `lua/config/local.example.lua` to `lua/config/local.lua` (it is gitignored) to turn on
Jupyter or Unity support, or to set your Python path.

## Documentation

See [GUIDE.md](GUIDE.md) for the folder layout, every keybinding, and how to customize.

## Troubleshooting

- **Plugin download fails or times out:** re-run `nvim --headless "+Lazy! sync" +qa`.
  On an unstable network also run `git config --global http.version HTTP/1.1`.
- **Anything else:** open `nvim` and run `:checkhealth`.
- **"needs Neovim >= 0.11":** update Neovim from https://github.com/neovim/neovim/releases.

## License

Add your license here (MIT is a common choice).
