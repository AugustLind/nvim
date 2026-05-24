# Neovim Config

Personal Neovim configuration built on [lazy.nvim](https://github.com/folke/lazy.nvim).

## Requirements

- Neovim **0.11+**
- [git](https://git-scm.com/)
- [ripgrep](https://github.com/BurntSushi/ripgrep) — for Telescope live grep
- [make](https://www.gnu.org/software/make/) — for telescope-fzf-native
- A **Nerd Font** — for icons (e.g. [JetBrainsMono Nerd Font](https://www.nerdfonts.com/))
- A C compiler — for Treesitter parsers

Language-specific tools (installed via Mason inside Neovim):

| Language | LSP | Formatter | Debugger |
|---|---|---|---|
| Python | pyright, ruff | ruff_format | debugpy |
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

Open Neovim — lazy.nvim bootstraps itself, then installs all plugins automatically. Run `:MasonInstall <tool>` to install any LSP servers or formatters not auto-installed.

For Python debugging, set up a debugpy venv:

```bash
python -m venv ~/.local/share/nvim/debugpy-venv
~/.local/share/nvim/debugpy-venv/bin/pip install debugpy
```

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
- **nvim-scrollbar** — scrollbar with diagnostic/git markers
- **indent-blankline + mini.indentscope** — indent guides with animated scope

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
- **Comment.nvim** — toggle comments
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
- **outline.nvim** — symbols outline panel
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

### Navigation
| Key | Action |
|---|---|
| `s` | Flash jump |
| `S` | Flash Treesitter jump |
| `<leader>ff` | Find files |
| `<leader>fg` | Live grep |
| `<leader>fb` | Find buffers |
| `<leader>fr` | Recent files |
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
| `<leader>cs` | Symbols outline |
| `gl` | Line diagnostics |
| `[d` / `]d` | Previous/next diagnostic |

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
| `<leader>cr` | CMake run |
