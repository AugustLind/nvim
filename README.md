# Neovim Config

Personal Neovim configuration built on [lazy.nvim](https://github.com/folke/lazy.nvim).

## Changed behavior

- Autosave is removed. Use `Space w` or `:w` to save; formatting runs on save.
- `kj` and `jk` exit insert mode without saving the buffer.
- Rename uses `Space cr`; CMake Run uses `Space cR` (capital R).
- Symbols use Trouble: `Space cs`, `Space o`, or `Space xs`.
- Comments use Neovim's native `gc` / `gcc`.

## Requirements

- Neovim **0.12+**
- [git](https://git-scm.com/)
- [ripgrep](https://github.com/BurntSushi/ripgrep) — for Telescope live grep
- [make](https://www.gnu.org/software/make/) — for telescope-fzf-native
- A **Nerd Font** — for icons (e.g. [JetBrainsMono Nerd Font](https://www.nerdfonts.com/))
- A C compiler — for Treesitter parsers

Configured language tools (LSP names below are configuration identifiers; see installation notes for package names):

| Language | LSP | Formatter | Debugger |
|---|---|---|---|
| Python | pyright, ruff | ruff_fix, then ruff_format | debugpy |
| Rust | rust-analyzer (rustaceanvim) | rustfmt | codelldb |
| C/C++ | clangd | clang-format | codelldb |
| TypeScript/JS | ts_ls, eslint | prettier | — |
| Lua | lua_ls | stylua | — |
| Typst | tinymist | typstyle | — |
| MATLAB | matlab_ls | — | — |
| CMake | — | cmake_format | — |

## Install

```bash
git clone git@github.com:AugustLind/nvim.git ~/.config/nvim
```

Open Neovim — lazy.nvim bootstraps itself, then installs the configured plugins.
Mason LSP setup ensures these servers are installed: `lua_ls`, `pyright`, `ruff`,
`clangd`, `ts_ls`, `eslint`, `tinymist`, and `matlab_ls`.

Formatters and debugger adapters need separate installation. Open `:Mason` to
inspect packages and installation status. For example:

```vim
:MasonInstall stylua prettier clang-format typstyle taplo codelldb
```

Conform formatter names are not always executable or Mason package names:

| Config identifier | Executable / installation |
|---|---|
| `ruff_fix`, `ruff_format` | Both use `ruff`; the Ruff LSP installation supplies it |
| `cmake_format` | Uses `cmake-format`, supplied by the Python `cmakelang` package |
| `rustfmt` | Install with the Rust toolchain, e.g. `rustup component add rustfmt` |

Install Rust and Cargo separately; rustaceanvim configures the language client.
With a rustup toolchain, install `rust-analyzer` and `clippy` using
`rustup component add rust-analyzer clippy`.
Use `:ConformInfo` to check which formatter executables are available.

### Machine-specific setup

For Python debugging, set up a debugpy venv:

```bash
python3 -m venv ~/.local/share/nvim/debugpy-venv
~/.local/share/nvim/debugpy-venv/bin/pip install debugpy
```

The config prefers `~/.local/share/nvim/debugpy-venv/bin/python` for debugging
and falls back to `python` on PATH. That fallback interpreter must have
`debugpy` installed. Use `Space cv` to select a project Python environment.

C/C++ and Rust debugging expect Mason's `codelldb` adapter under
`stdpath("data") .. "/mason/bin/codelldb"`.

MATLAB itself must be installed separately. Change the `matlab_ls`
`settings.matlab.installPath` in [plugins.lua](lua/august/plugins.lua) from
`/usr/local/MATLAB/R2024b` to your MATLAB installation directory.

## What's included

### UI
- **Catppuccin** — colorscheme
- **lualine** — statusline
- **bufferline** — buffer tabs
- **barbecue** — breadcrumb navigation in winbar
- **alpha-nvim** — start screen dashboard
- **noice.nvim** — better cmdline, messages, and notifications
- **nvim-notify** — toast-style notifications
- **which-key** — keymap hint popups
- **indent-blankline** — indent guides and scope highlighting

### Navigation
- **Telescope** + fzf-native — fuzzy finder for files, grep, buffers, etc.
- **Harpoon 2** — pin files and jump between them instantly
- **Flash** — jump anywhere on screen with `s`
- **nvim-tree** — file explorer

### Editing
- **nvim-cmp** — completion engine (LSP, snippets, buffer, path)
- **LuaSnip** + friendly-snippets — snippet engine
- **nvim-autopairs** — auto-close brackets and quotes
- **nvim-surround** — surround text objects
- Native `gc` / `gcc` — toggle comments
- **mini.ai** — extended text objects (`af`, `if`, `ac`, `ic`, etc.)
- **nvim-ts-autotag** — auto-close/rename HTML and JSX tags
- **nvim-ufo** — better code folding with Treesitter

### LSP & Formatting
- **mason.nvim** — LSP/tool installer
- **nvim-lspconfig** — LSP configuration
- **conform.nvim** — format on save
- **lazydev.nvim** — better Lua/Neovim API completion when editing this config
- **inc-rename** — live rename preview
- **clangd_extensions** — enhanced clangd features
- **rustaceanvim** — full rust-analyzer integration
- **crates.nvim** — Cargo.toml dependency management

### Git
- **Neogit** — Magit-style interactive git UI (`<leader>gg`)
- **Gitsigns** — inline hunk signs, staging, blame
- **Diffview** — full diff/history viewer
- **git-conflict** — conflict markers and resolution
- **gitlinker** — copy/open GitHub permalink for current line

### Debugging (DAP)
- **nvim-dap** + dap-ui + dap-virtual-text
- Python via debugpy
- C/C++/Rust via codelldb

### Language-specific
- **venv-selector** — pick Python virtualenv (`<leader>cv`)
- **cmake-tools** — CMake build/run/debug from inside Neovim
- **nvim-treesitter-cpp-tools** — C++ treesitter utilities

### Other
- **Trouble** — diagnostics, quickfix, and symbol list panel
- **todo-comments** — highlight and search TODO/FIXME/etc.
- **nvim-spectre** — project-wide find and replace
- **Toggleterm** — floating/split terminal
- **persistence.nvim** — session save/restore
- **render-markdown.nvim** — render markdown in the buffer
- **nvim-bqf** — better quickfix window

## Key mappings

Leader key: `<Space>`

### General
| Key | Action |
|---|---|
| `jk` / `kj` | Exit insert mode |
| `<leader>w` | Save file |
| `<leader>qq` | Quit all |
| `<leader>e` | Toggle file explorer |
| `<C-\>` | Toggle terminal |
| `<leader>cf` | Format file |
| `<leader>l` | Open Lazy plugin manager |
| `<leader>bd` | Delete buffer while keeping window layout |
| `<leader>bD` | Force-delete buffer |
| `<S-h>` / `<S-l>` | Previous/next buffer |

### Navigation
| Key | Action |
|---|---|
| `s` | Flash jump |
| `S` | Flash Treesitter jump |
| `<leader>ff` | Find files |
| `<leader>fg` | Live grep |
| `<leader>fb` | Find buffers |
| `<leader>fr` | Recent files |
| `<leader>fp` | Find projects |
| `<leader>/` | Search in buffer |
| `<leader>ha` | Harpoon: add file |
| `<leader>hh` | Harpoon: open menu |
| `<leader>1-4` | Harpoon: jump to file 1–4 |

### LSP
| Key | Action |
|---|---|
| `gd` | Go to definition |
| `gr` | Go to references |
| `gi` | Go to implementation |
| `K` | Hover documentation |
| `<leader>ca` | Code actions |
| `<leader>cr` | Rename symbol |
| `<leader>cI` | Toggle inlay hints |
| `<leader>cs` / `<leader>o` / `<leader>xs` | Toggle Trouble symbols |
| `gl` | Line diagnostics |
| `[d` / `]d` | Previous/next diagnostic |

### Search and sessions

| Key | Action |
|---|---|
| `<leader>sr` | Open project-wide find and replace |
| `<leader>sw` | Find/replace current word, or selection in visual mode |
| `<leader>qs` | Restore session for the current directory |
| `<leader>ql` | Restore the last session |
| `<leader>qd` | Stop saving the current session |

Session restoration restores editor layout and buffers; save file contents
explicitly with `:w` or `<leader>w`.

### Git
| Key | Action |
|---|---|
| `<leader>gg` | Neogit |
| `<leader>gv` | Diffview open |
| `<leader>gh` | File history |
| `<leader>gb` | Blame line |
| `<leader>gs` | Stage hunk |
| `<leader>gr` | Reset hunk |
| `<leader>gp` | Preview hunk |
| `]h` / `[h` | Next/prev hunk |

### Debugging
| Key | Action |
|---|---|
| `<leader>dc` | Continue |
| `<leader>db` | Toggle breakpoint |
| `<leader>do` | Step over |
| `<leader>di` | Step into |
| `<leader>dO` | Step out |
| `<leader>du` | Toggle DAP UI |
| `<leader>de` | Evaluate expression |

### Rust
| Key | Action |
|---|---|
| `<leader>rr` | Runnables |
| `<leader>rd` | Debuggables |
| `<leader>re` | Expand macro |
| `<leader>rh` | Hover actions |
| `<leader>rl` | Open Cargo.toml |

### C/C++
| Key | Action |
|---|---|
| `<leader>cH` | Switch header/source |
| `<leader>cg` | CMake generate |
| `<leader>cb` | CMake build |
| `<leader>cR` | CMake run |

## Configuration layout

| File | Purpose |
|---|---|
| [init.lua](init.lua) | Loads the configuration modules |
| [options.lua](lua/august/options.lua) | Editor options, filetype detection, and general autocommands |
| [plugins.lua](lua/august/plugins.lua) | Plugin declarations, LSP servers, formatters, and debugger setup |
| [keymaps.lua](lua/august/keymaps.lua) | General and language-specific mappings; plugin-local mappings also live in plugins.lua |
| [treesitter_compat.lua](lua/august/treesitter_compat.lua) | Legacy Treesitter query callback compatibility for Neovim 0.12 |
| [lazy-lock.json](lazy-lock.json) | Locked plugin revisions |

## Troubleshooting

### Treesitter errors in Markdown

Errors such as `attempt to call method 'range' (a nil value)` can occur when
legacy Treesitter query handlers receive capture lists from Neovim 0.12.
This config keeps the legacy Treesitter setup API and loads
`treesitter_compat.lua` before configuring it. The adapter converts capture
lists to single nodes for callbacks registered with `all = false`.

Keep the compatibility module with this configuration. Moving Treesitter to
its rewritten API requires reviewing both its setup and this adapter.
After updating configuration files, restart Neovim.

### Deprecated LSP client lookup

The installed project.nvim version calls the deprecated
`vim.lsp.buf_get_clients()`. Its root detection is overridden in
`plugins.lua` to use `vim.lsp.get_clients({ bufnr = 0 })` while retaining
filetype and ignored-client filtering. Keep that override until the plugin
uses the current API. Use `:checkhealth vim.deprecated` to investigate other
deprecation messages.

### Formatting and language tools

Use `:ConformInfo` for missing formatters, `:Mason` for package installation
status, and `:checkhealth vim.lsp` for LSP setup. Python saves run Ruff fixes
before Ruff formatting. Leaving insert mode with `kj` does not save or format.

### Updating an existing checkout

Commit or stash local changes before pulling, then run `git pull --ff-only`
in the configuration repository. Restart Neovim afterward. Local
`*.backup-*` configuration backups are ignored by Git.
