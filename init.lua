-- Leader key (MUST be set before keymaps)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- General options
vim.opt.expandtab = true
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.number = true
vim.opt.relativenumber = true

-- Visual and UI
vim.opt.termguicolors = true
vim.opt.signcolumn = "yes"
vim.opt.cursorline = true
vim.opt.scrolloff = 8
vim.opt.sidescrolloff = 8
vim.opt.wrap = false
vim.opt.showmode = false

-- Search
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.hlsearch = true
vim.opt.incsearch = true

-- Editing
vim.opt.clipboard = "unnamedplus"
vim.opt.undofile = true
vim.opt.undolevels = 10000
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.mouse = "a"

-- Performance
vim.opt.updatetime = 250
vim.opt.timeoutlen = 300

-- Typst filetype detection
vim.filetype.add({
	extension = {
		typ = "typst",
		m = "matlab",
	},
})

-- Disable inlay hints globally
vim.api.nvim_create_autocmd("LspAttach", {
	callback = function(args)
		vim.lsp.inlay_hint.enable(false, { bufnr = args.buf })
	end,
})

-- Completion
vim.opt.completeopt = "menu,menuone,noselect"
vim.opt.pumheight = 10

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable",
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

-- Plugin list
local plugins = {
	-- Theme
	{ "catppuccin/nvim", name = "catppuccin", priority = 1000, config = function()
		vim.cmd.colorscheme("catppuccin")
	end },

	-- ============================================
	-- LAZYVIM-STYLE UI ENHANCEMENTS
	-- ============================================

	-- Better UI for inputs and selects (VS Code-like dropdowns)
	{
		"stevearc/dressing.nvim",
		event = "VeryLazy",
		opts = {
			input = { enabled = true, border = "rounded" },
			select = { enabled = true, backend = { "telescope", "builtin" } },
		},
	},

	-- Notifications (toast-style like VS Code)
	{
		"rcarriga/nvim-notify",
		opts = {
			timeout = 3000,
			max_height = function()
				return math.floor(vim.o.lines * 0.75)
			end,
			max_width = function()
				return math.floor(vim.o.columns * 0.75)
			end,
			render = "compact",
			stages = "fade",
		},
		init = function()
			vim.notify = require("notify")
		end,
	},

	-- Fancy command line, messages, and popupmenu
	{
		"folke/noice.nvim",
		event = "VeryLazy",
		dependencies = { "MunifTanjim/nui.nvim", "rcarriga/nvim-notify" },
		opts = {
			lsp = {
				override = {
					["vim.lsp.util.convert_input_to_markdown_lines"] = true,
					["vim.lsp.util.stylize_markdown"] = true,
					["cmp.entry.get_documentation"] = true,
				},
			},
			presets = {
				bottom_search = true,
				command_palette = true,
				long_message_to_split = true,
				inc_rename = true,
			},
		},
	},

	-- Dashboard (start screen like VS Code)
	{
		"goolord/alpha-nvim",
		event = "VimEnter",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			local alpha = require("alpha")
			local dashboard = require("alpha.themes.dashboard")
			dashboard.section.header.val = {
				"                                                     ",
				"  ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗ ",
				"  ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║ ",
				"  ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║ ",
				"  ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║ ",
				"  ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║ ",
				"  ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝ ",
				"                                                     ",
			}
			dashboard.section.buttons.val = {
				dashboard.button("f", "  Find file", ":Telescope find_files<CR>"),
				dashboard.button("n", "  New file", ":ene <BAR> startinsert<CR>"),
				dashboard.button("r", "  Recent files", ":Telescope oldfiles<CR>"),
				dashboard.button("g", "  Find text", ":Telescope live_grep<CR>"),
				dashboard.button("p", "  Projects", ":Telescope projects<CR>"),
				dashboard.button("c", "  Config", ":e ~/.config/nvim/init.lua<CR>"),
				dashboard.button("s", "  Restore Session", ":lua require('persistence').load()<CR>"),
				dashboard.button("q", "  Quit", ":qa<CR>"),
			}
			alpha.setup(dashboard.opts)
		end,
	},

	-- Session management (restore previous session)
	{
		"folke/persistence.nvim",
		event = "BufReadPre",
		opts = { options = { "buffers", "curdir", "tabpages", "winsize" } },
		keys = {
			{
				"<leader>qs",
				function()
					require("persistence").load()
				end,
				desc = "Restore Session",
			},
			{
				"<leader>ql",
				function()
					require("persistence").load({ last = true })
				end,
				desc = "Restore Last Session",
			},
			{
				"<leader>qd",
				function()
					require("persistence").stop()
				end,
				desc = "Don't Save Current Session",
			},
		},
	},

	-- Flash navigation (quick jumping like VS Code's Ctrl+Shift+O)
	{
		"folke/flash.nvim",
		event = "VeryLazy",
		opts = {},
		keys = {
			{
				"s",
				mode = { "n", "x", "o" },
				function()
					require("flash").jump()
				end,
				desc = "Flash",
			},
			{
				"S",
				mode = { "n", "x", "o" },
				function()
					require("flash").treesitter()
				end,
				desc = "Flash Treesitter",
			},
			{
				"r",
				mode = "o",
				function()
					require("flash").remote()
				end,
				desc = "Remote Flash",
			},
			{
				"R",
				mode = { "o", "x" },
				function()
					require("flash").treesitter_search()
				end,
				desc = "Treesitter Search",
			},
		},
	},

	-- Quick file bookmarks and instant switching
	{
		"ThePrimeagen/harpoon",
		branch = "harpoon2",
		dependencies = { "nvim-lua/plenary.nvim" },
		config = function()
			require("harpoon"):setup()
		end,
		keys = {
			{
				"<leader>ha",
				function()
					require("harpoon"):list():add()
				end,
				desc = "Harpoon add file",
			},
			{
				"<leader>hh",
				function()
					local harpoon = require("harpoon")
					harpoon.ui:toggle_quick_menu(harpoon:list())
				end,
				desc = "Harpoon menu",
			},
			{
				"<leader>1",
				function()
					require("harpoon"):list():select(1)
				end,
				desc = "Harpoon file 1",
			},
			{
				"<leader>2",
				function()
					require("harpoon"):list():select(2)
				end,
				desc = "Harpoon file 2",
			},
			{
				"<leader>3",
				function()
					require("harpoon"):list():select(3)
				end,
				desc = "Harpoon file 3",
			},
			{
				"<leader>4",
				function()
					require("harpoon"):list():select(4)
				end,
				desc = "Harpoon file 4",
			},
		},
	},

	-- Better buffer deletion (keeps window layout)
	{
		"echasnovski/mini.bufremove",
		keys = {
			{
				"<leader>bd",
				function()
					require("mini.bufremove").delete(0, false)
				end,
				desc = "Delete Buffer",
			},
			{
				"<leader>bD",
				function()
					require("mini.bufremove").delete(0, true)
				end,
				desc = "Delete Buffer (Force)",
			},
		},
	},

	-- Animated indent scope
	{
		"echasnovski/mini.indentscope",
		event = { "BufReadPost", "BufNewFile" },
		opts = {
			symbol = "│",
			options = { try_as_border = true },
		},
		init = function()
			vim.api.nvim_create_autocmd("FileType", {
				pattern = { "help", "alpha", "dashboard", "neo-tree", "Trouble", "lazy", "mason" },
				callback = function()
					vim.b.miniindentscope_disable = true
				end,
			})
		end,
	},

	-- Better text objects
	{
		"echasnovski/mini.ai",
		event = "VeryLazy",
		opts = function()
			local ai = require("mini.ai")
			return {
				n_lines = 500,
				custom_textobjects = {
					o = ai.gen_spec.treesitter({
						a = { "@block.outer", "@conditional.outer", "@loop.outer" },
						i = { "@block.inner", "@conditional.inner", "@loop.inner" },
					}, {}),
					f = ai.gen_spec.treesitter({ a = "@function.outer", i = "@function.inner" }, {}),
					c = ai.gen_spec.treesitter({ a = "@class.outer", i = "@class.inner" }, {}),
				},
			}
		end,
	},

	-- Highlight word under cursor (like VS Code)
	{
		"RRethy/vim-illuminate",
		event = { "BufReadPost", "BufNewFile" },
		opts = {
			delay = 200,
			large_file_cutoff = 2000,
			large_file_overrides = { providers = { "lsp" } },
		},
		config = function(_, opts)
			require("illuminate").configure(opts)
		end,
	},

	-- Breadcrumbs in winbar (like VS Code's breadcrumb navigation)
	{
		"SmiteshP/nvim-navic",
		lazy = true,
		opts = { lazy_update_context = true },
	},
	{
		"utilyre/barbecue.nvim",
		event = { "BufReadPost", "BufNewFile" },
		dependencies = { "SmiteshP/nvim-navic", "nvim-tree/nvim-web-devicons" },
		opts = {
			attach_navic = true,
			show_modified = true,
			theme = "catppuccin",
		},
	},

	-- Better code folding (like VS Code)
	{
		"kevinhwang91/nvim-ufo",
		dependencies = "kevinhwang91/promise-async",
		event = "BufReadPost",
		opts = {
			provider_selector = function()
				return { "treesitter", "indent" }
			end,
		},
		init = function()
			vim.o.foldcolumn = "1"
			vim.o.foldlevel = 99
			vim.o.foldlevelstart = 99
			vim.o.foldenable = true
		end,
		keys = {
			{
				"zR",
				function()
					require("ufo").openAllFolds()
				end,
				desc = "Open all folds",
			},
			{
				"zM",
				function()
					require("ufo").closeAllFolds()
				end,
				desc = "Close all folds",
			},
			{
				"zK",
				function()
					require("ufo").peekFoldedLinesUnderCursor()
				end,
				desc = "Peek fold",
			},
		},
	},

	-- Find and replace across files (Ctrl+Shift+H in VS Code)
	{
		"nvim-pack/nvim-spectre",
		dependencies = "nvim-lua/plenary.nvim",
		keys = {
			{
				"<leader>sr",
				function()
					require("spectre").open()
				end,
				desc = "Replace in files (Spectre)",
			},
			{
				"<leader>sw",
				function()
					require("spectre").open_visual({ select_word = true })
				end,
				desc = "Search current word",
			},
			{
				"<leader>sw",
				mode = "v",
				function()
					require("spectre").open_visual()
				end,
				desc = "Search selection",
			},
		},
	},

	-- Color preview in code
	{
		"NvChad/nvim-colorizer.lua",
		event = { "BufReadPost", "BufNewFile" },
		opts = {
			user_default_options = {
				RGB = true,
				RRGGBB = true,
				names = false,
				RRGGBBAA = true,
				css = true,
				css_fn = true,
				mode = "background",
				tailwind = true,
				virtualtext = "■",
			},
		},
	},

	-- Render markdown nicely in buffer
	{
		"MeanderingProgrammer/render-markdown.nvim",
		dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" },
		ft = { "markdown" },
		opts = {},
	},

	-- Scrollbar (like VS Code)
	{
		"petertriho/nvim-scrollbar",
		event = "BufReadPost",
		opts = {
			handle = { blend = 0 },
			marks = {
				Search = { color = "#ff9e64" },
				Error = { color = "#db4b4b" },
				Warn = { color = "#e0af68" },
				Info = { color = "#0db9d7" },
				Hint = { color = "#1abc9c" },
				Misc = { color = "#9d7cd8" },
				GitAdd = { color = "#9ece6a" },
				GitChange = { color = "#e0af68" },
				GitDelete = { color = "#db4b4b" },
			},
			handlers = {
				cursor = true,
				diagnostic = true,
				gitsigns = true,
				search = true,
			},
		},
	},

	-- Better search with match count
	{
		"kevinhwang91/nvim-hlslens",
		keys = {
			{
				"n",
				[[<Cmd>execute('normal! ' . v:count1 . 'n')<CR><Cmd>lua require('hlslens').start()<CR>]],
				desc = "Next search result",
			},
			{
				"N",
				[[<Cmd>execute('normal! ' . v:count1 . 'N')<CR><Cmd>lua require('hlslens').start()<CR>]],
				desc = "Prev search result",
			},
			{ "*", [[*<Cmd>lua require('hlslens').start()<CR>]], desc = "Search word forward" },
			{ "#", [[#<Cmd>lua require('hlslens').start()<CR>]], desc = "Search word backward" },
		},
	},

	-- Git conflict resolution
	{
		"akinsho/git-conflict.nvim",
		event = "BufReadPost",
		opts = {
			default_mappings = true,
			disable_diagnostics = true,
		},
	},

	-- Better git diff view
	{
		"sindrets/diffview.nvim",
		cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewToggleFiles", "DiffviewFileHistory" },
		keys = {
			{ "<leader>gv", "<cmd>DiffviewOpen<cr>", desc = "Open diff view" },
			{ "<leader>gh", "<cmd>DiffviewFileHistory %<cr>", desc = "File history" },
			{ "<leader>gH", "<cmd>DiffviewFileHistory<cr>", desc = "Branch history" },
		},
		opts = {},
	},

	-- Magit-style interactive git UI
	{
		"NeogitOrg/neogit",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"sindrets/diffview.nvim",
			"nvim-telescope/telescope.nvim",
		},
		keys = {
			{ "<leader>gg", "<cmd>Neogit<cr>", desc = "Neogit" },
			{ "<leader>gc", "<cmd>Neogit commit<cr>", desc = "Git commit" },
		},
		opts = {
			integrations = { diffview = true, telescope = true },
		},
	},

	-- Open current file/line on GitHub
	{
		"ruifm/gitlinker.nvim",
		dependencies = "nvim-lua/plenary.nvim",
		keys = {
			{
				"<leader>gl",
				function()
					require("gitlinker").get_buf_range_url("n")
				end,
				desc = "Copy git permalink",
			},
			{
				"<leader>gl",
				mode = "v",
				function()
					require("gitlinker").get_buf_range_url("v")
				end,
				desc = "Copy git permalink (selection)",
			},
			{
				"<leader>gL",
				function()
					require("gitlinker").get_buf_range_url("n", {}, require("gitlinker.actions").open_in_browser)
				end,
				desc = "Open in browser",
			},
		},
		opts = { mappings = nil },
	},

	-- Incremental rename preview
	{
		"smjonas/inc-rename.nvim",
		cmd = "IncRename",
		opts = {},
		keys = {
			{
				"<leader>cr",
				function()
					return ":IncRename " .. vim.fn.expand("<cword>")
				end,
				expr = true,
				desc = "Rename (inc-rename)",
			},
		},
	},

	-- Smooth scrolling
	{
		"karb94/neoscroll.nvim",
		event = "VeryLazy",
		opts = {
			mappings = { "<C-u>", "<C-d>", "<C-b>", "<C-f>", "zt", "zz", "zb" },
			hide_cursor = true,
			stop_eof = true,
			respect_scrolloff = false,
			cursor_scrolls_alone = true,
		},
	},

	-- Better window management
	{
		"anuvyklack/windows.nvim",
		event = "WinNew",
		dependencies = "anuvyklack/middleclass",
		opts = {},
		keys = {
			{ "<leader>wm", "<cmd>WindowsMaximize<cr>", desc = "Maximize window" },
			{ "<leader>we", "<cmd>WindowsEqualize<cr>", desc = "Equalize windows" },
		},
	},

	-- Auto-save (like VS Code)
	{
		"okuuva/auto-save.nvim",
		event = { "InsertLeave", "TextChanged" },
		opts = {
			enabled = true,
			trigger_events = {
				immediate_save = { "BufLeave", "FocusLost" },
				defer_save = { "InsertLeave", "TextChanged" },
			},
			debounce_delay = 1000,
			condition = function(buf)
				local fn = vim.fn
				if fn.getbufvar(buf, "&modifiable") ~= 1 or fn.getbufvar(buf, "&filetype") == "gitcommit" then
					return false
				end
				return true
			end,
		},
	},

	-- Treesitter for syntax
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		dependencies = { "nvim-treesitter/nvim-treesitter-textobjects" },
		config = function()
			require("nvim-treesitter.configs").setup({
				ensure_installed = {
					"lua",
					"vim",
					"vimdoc",
					"query",
					"python",
					"cpp",
					"c",
					"rust",
					"javascript",
					"typescript",
					"json",
					"yaml",
					"markdown",
					"bash",
					"html",
					"css",
					"toml",
					"cmake",
					"make",
					"dockerfile",
					"typst",
					"matlab",
				},
				highlight = {
					enable = true,
					-- Disable on large files for better performance
					disable = function(lang, buf)
						local max_filesize = 100 * 1024 -- 100 KB
						local ok, stats = pcall(vim.uv.fs_stat, vim.api.nvim_buf_get_name(buf))
						if ok and stats and stats.size > max_filesize then
							return true
						end
					end,
				},
				indent = { enable = true },
				incremental_selection = {
					enable = true,
					keymaps = {
						init_selection = "<C-space>",
						node_incremental = "<C-space>",
						scope_incremental = false,
						node_decremental = "<bs>",
					},
				},
				textobjects = {
					select = {
						enable = true,
						lookahead = true,
						keymaps = {
							["af"] = "@function.outer",
							["if"] = "@function.inner",
							["ac"] = "@class.outer",
							["ic"] = "@class.inner",
							["aa"] = "@parameter.outer",
							["ia"] = "@parameter.inner",
						},
					},
					move = {
						enable = true,
						set_jumps = true,
						goto_next_start = {
							["]f"] = "@function.outer",
							["]c"] = "@class.outer",
						},
						goto_previous_start = {
							["[f"] = "@function.outer",
							["[c"] = "@class.outer",
						},
					},
					swap = {
						enable = true,
						swap_next = { ["<leader>a"] = "@parameter.inner" },
						swap_previous = { ["<leader>A"] = "@parameter.inner" },
					},
				},
			})
		end,
	},

	-- Auto-close and auto-rename HTML/JSX tags
	{
		"windwp/nvim-ts-autotag",
		event = { "BufReadPost", "BufNewFile" },
		opts = {},
	},

	-- Telescope (fuzzy finder)
	{
		"nvim-telescope/telescope.nvim",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-telescope/telescope-fzf-native.nvim", -- Better performance
		},
		config = function()
			require("telescope").setup({
				defaults = {
					file_ignore_patterns = { "node_modules", ".git/" },
				},
			})
			-- Load fzf extension if available
			pcall(require("telescope").load_extension, "fzf")
		end,
	},

	-- Better fuzzy finding performance
	{
		"nvim-telescope/telescope-fzf-native.nvim",
		build = "make",
	},

	-- Statusline
	{
		"nvim-lualine/lualine.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons", "catppuccin/nvim" },
		config = function()
			require("lualine").setup({
				options = { theme = "auto" },
				sections = {
					lualine_x = { "encoding", "filetype" },
				},
			})
		end,
	},

	-- File explorer
	{
		"nvim-tree/nvim-tree.lua",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			require("nvim-tree").setup({
				view = { width = 30 },
				filters = { dotfiles = false },
			})
		end,
	},

	-- Git integration
	{
		"lewis6991/gitsigns.nvim",
		config = function()
			require("gitsigns").setup()
		end,
	},

	-- Better Lua/Neovim API completion when editing config
	{
		"folke/lazydev.nvim",
		ft = "lua",
		opts = {
			library = {
				{ path = "${3rd}/luv/library", words = { "vim%.uv" } },
			},
		},
	},

	-- LSP + Autocompletion
	{
		"williamboman/mason.nvim",
		config = function()
			require("mason").setup()
		end,
	},

	{
		"neovim/nvim-lspconfig",
		dependencies = { "williamboman/mason-lspconfig.nvim", "hrsh7th/cmp-nvim-lsp" },
		config = function()
			-- Get capabilities from nvim-cmp
			local capabilities = require("cmp_nvim_lsp").default_capabilities()

			-- LSP keymaps (set up via LspAttach autocmd)
			vim.api.nvim_create_autocmd("LspAttach", {
				callback = function(args)
					local opts = { buffer = args.buf }
					vim.keymap.set(
						"n",
						"gd",
						vim.lsp.buf.definition,
						vim.tbl_extend("force", opts, { desc = "Go to definition" })
					)
					vim.keymap.set(
						"n",
						"gD",
						vim.lsp.buf.declaration,
						vim.tbl_extend("force", opts, { desc = "Go to declaration" })
					)
					vim.keymap.set(
						"n",
						"gi",
						vim.lsp.buf.implementation,
						vim.tbl_extend("force", opts, { desc = "Go to implementation" })
					)
					vim.keymap.set(
						"n",
						"gr",
						vim.lsp.buf.references,
						vim.tbl_extend("force", opts, { desc = "Go to references" })
					)
					vim.keymap.set(
						"n",
						"K",
						vim.lsp.buf.hover,
						vim.tbl_extend("force", opts, { desc = "Hover documentation" })
					)
					vim.keymap.set(
						"n",
						"<leader>ca",
						vim.lsp.buf.code_action,
						vim.tbl_extend("force", opts, { desc = "Code actions" })
					)
					vim.keymap.set(
						"n",
						"<leader>rn",
						vim.lsp.buf.rename,
						vim.tbl_extend("force", opts, { desc = "Rename symbol" })
					)
					vim.keymap.set(
						"n",
						"<leader>D",
						vim.lsp.buf.type_definition,
						vim.tbl_extend("force", opts, { desc = "Type definition" })
					)
					vim.keymap.set(
						{ "n", "i" },
						"<C-s>",
						vim.lsp.buf.signature_help,
						vim.tbl_extend("force", opts, { desc = "Signature help" })
					)
				end,
			})

			-- Configure diagnostics
			vim.diagnostic.config({
				virtual_text = false,
				signs = true,
				underline = true,
				update_in_insert = false,
				severity_sort = true,
				float = { border = "rounded", source = true },
			})

			require("mason-lspconfig").setup({
				ensure_installed = {
					"lua_ls",
					"pyright",
					"ruff",
					"clangd",
					"ts_ls",
					"eslint",
					"tinymist",
					"matlab_ls",
				},
			})

			-- Configure LSP servers using vim.lsp.config (Neovim 0.11+)
			vim.lsp.config("*", { capabilities = capabilities })

			vim.lsp.config("pyright", {})
			vim.lsp.config("ts_ls", {})
			vim.lsp.config("eslint", {})
			vim.lsp.config("ruff", {})

			vim.lsp.config("clangd", {
				capabilities = vim.tbl_deep_extend("force", capabilities, { offsetEncoding = { "utf-16" } }),
				cmd = {
					"clangd",
					"--background-index",
					"--clang-tidy",
					"--header-insertion=iwyu",
					"--completion-style=detailed",
					"--function-arg-placeholders",
					"--fallback-style=llvm",
					"--pch-storage=memory",
					"--all-scopes-completion",
					"--suggest-missing-includes",
					"--cross-file-rename",
				},
				init_options = {
					clangdFileStatus = true,
					usePlaceholders = true,
					completeUnimported = true,
					semanticHighlighting = true,
				},
			})

			vim.lsp.config("lua_ls", {
				settings = {
					Lua = {
						diagnostics = { globals = { "vim" } },
						workspace = { checkThirdParty = false },
						telemetry = { enable = false },
					},
				},
			})

			vim.lsp.config("tinymist", {
				settings = {
					formatterMode = "typstyle",
				},
			})

			vim.lsp.config("matlab_ls", {
				settings = {
					matlab = {
						installPath = "/usr/local/MATLAB/R2024b",
						matlabConnectionTiming = "onStart",
						telemetry = false,
					},
				},
			})

			-- Enable all configured servers
			vim.lsp.enable({ "pyright", "ts_ls", "eslint", "ruff", "clangd", "lua_ls", "tinymist", "matlab_ls" })
		end,
	},

	{
		"hrsh7th/nvim-cmp",
		dependencies = {
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-path",
			"hrsh7th/cmp-cmdline", -- Command line completion
			"L3MON4D3/LuaSnip",
			"saadparwaiz1/cmp_luasnip", -- Snippet completion
			"rafamadriz/friendly-snippets", -- Pre-built snippets
		},
		config = function()
			local cmp = require("cmp")
			local luasnip = require("luasnip")

			-- Load friendly-snippets
			require("luasnip.loaders.from_vscode").lazy_load()

			cmp.setup({
				snippet = {
					expand = function(args)
						luasnip.lsp_expand(args.body)
					end,
				},
				mapping = cmp.mapping.preset.insert({
					["<C-Space>"] = cmp.mapping.complete(),
					["<CR>"] = cmp.mapping.confirm({ select = true }),
					["<Tab>"] = cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.select_next_item()
						elseif luasnip.expand_or_jumpable() then
							luasnip.expand_or_jump()
						else
							fallback()
						end
					end, { "i", "s" }),
				}),
				sources = cmp.config.sources({
					{ name = "lazydev", group_index = 0 },
					{ name = "nvim_lsp" },
					{ name = "luasnip" },
					{ name = "crates" },
					{ name = "buffer" },
					{ name = "path" },
				}),
			})

			-- Command line completion
			cmp.setup.cmdline(":", {
				mapping = cmp.mapping.preset.cmdline(),
				sources = cmp.config.sources({
					{ name = "path" },
					{ name = "cmdline" },
				}),
			})
		end,
	},

	-- Code formatting
	{
		"stevearc/conform.nvim",
		config = function()
			require("conform").setup({
				formatters_by_ft = {
					lua = { "stylua" },
					python = { "ruff_format", "ruff_fix" },
					javascript = { "prettier" },
					typescript = { "prettier" },
					json = { "prettier" },
					yaml = { "prettier" },
					markdown = { "prettier" },
					c = { "clang-format" },
					cpp = { "clang-format" },
					rust = { "rustfmt" },
					cmake = { "cmake_format" },
					toml = { "taplo" },
					typst = { "typstyle" },
				},
				format_on_save = {
					timeout_ms = 1000,
					lsp_format = "fallback",
				},
			})
		end,
	},

	-- Auto pairs for brackets, quotes, etc.
	{
		"windwp/nvim-autopairs",
		config = function()
			require("nvim-autopairs").setup({})
			-- Integration with nvim-cmp
			local cmp_autopairs = require("nvim-autopairs.completion.cmp")
			local cmp = require("cmp")
			cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
		end,
	},

	-- Surround text objects
	{
		"kylechui/nvim-surround",
		config = function()
			require("nvim-surround").setup({})
		end,
	},

	-- Comment toggling
	{
		"numToStr/Comment.nvim",
		config = function()
			require("Comment").setup()
		end,
	},

	-- Better terminal integration
	{
		"akinsho/toggleterm.nvim",
		config = function()
			require("toggleterm").setup({
				size = 20,
				open_mapping = [[<c-\>]],
				hide_numbers = true,
				direction = "horizontal",
			})
		end,
	},

	-- Indent guides
	{
		"lukas-reineke/indent-blankline.nvim",
		main = "ibl",
		config = function()
			require("ibl").setup({
				indent = { char = "│" },
				scope = { enabled = false },
			})
		end,
	},

	-- Which-key for keybinding hints
	{
		"folke/which-key.nvim",
		event = "VeryLazy",
		config = function()
			local wk = require("which-key")
			wk.setup({
				plugins = { spelling = { enabled = true } },
				win = { border = "rounded" },
			})
			wk.add({
				{ "<leader>b", group = "buffer" },
				{ "<leader>c", group = "code/c++" },
				{ "<leader>d", group = "debug" },
				{ "<leader>f", group = "find" },
				{ "<leader>g", group = "git" },
				{ "<leader>gl", group = "git link" },
				{ "<leader>h", group = "harpoon" },
				{ "<leader>p", group = "python" },
				{ "<leader>r", group = "rust" },
				{ "<leader>s", group = "search/replace" },
				{ "<leader>w", group = "windows" },
				{ "<leader>x", group = "diagnostics" },
				{ "<leader>q", group = "quit/session" },
			})
		end,
	},

	-- Buffer management
	{
		"akinsho/bufferline.nvim",
		dependencies = "nvim-tree/nvim-web-devicons",
		config = function()
			require("bufferline").setup({
				options = {
					diagnostics = "nvim_lsp",
					show_buffer_close_icons = false,
					show_close_icon = false,
				},
			})
		end,
	},

	-- Better quickfix window
	{
		"kevinhwang91/nvim-bqf",
	},

	-- TODO comments highlighting
	{
		"folke/todo-comments.nvim",
		dependencies = { "nvim-lua/plenary.nvim" },
		config = function()
			require("todo-comments").setup({})
		end,
	},

	-- Better diagnostics list
	{
		"folke/trouble.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			require("trouble").setup({})
		end,
	},

	-- Project management
	{
		"ahmedkhalf/project.nvim",
		dependencies = { "nvim-telescope/telescope.nvim" },
		config = function()
			require("project_nvim").setup({})
			require("telescope").load_extension("projects")
		end,
	},

	-- Symbols outline (code structure)
	{
		"hedyhli/outline.nvim",
		cmd = { "Outline", "OutlineOpen" },
		keys = { { "<leader>o", "<cmd>Outline<CR>", desc = "Toggle outline" } },
		config = function()
			require("outline").setup({
				outline_window = {
					position = "right",
					width = 25,
					show_numbers = false,
					show_relative_numbers = false,
				},
				preview_window = {
					auto_preview = false,
				},
				keymaps = {
					close = { "<Esc>", "q" },
					goto_location = "<Cr>",
					peek_location = "o",
					hover_symbol = "<C-space>",
					toggle_preview = "K",
					rename_symbol = "r",
					code_actions = "a",
				},
			})
		end,
	},

	-- ============================================
	-- DEBUGGING (DAP)
	-- ============================================
	{
		"mfussenegger/nvim-dap",
		dependencies = {
			"rcarriga/nvim-dap-ui",
			"nvim-neotest/nvim-nio",
			"theHamsta/nvim-dap-virtual-text",
			"mfussenegger/nvim-dap-python",
		},
		config = function()
			local dap = require("dap")
			local dapui = require("dapui")

			-- DAP UI setup
			dapui.setup({
				icons = { expanded = "▾", collapsed = "▸", current_frame = "▸" },
				layouts = {
					{
						elements = {
							{ id = "scopes", size = 0.25 },
							{ id = "breakpoints", size = 0.25 },
							{ id = "stacks", size = 0.25 },
							{ id = "watches", size = 0.25 },
						},
						position = "left",
						size = 40,
					},
					{
						elements = {
							{ id = "repl", size = 0.5 },
							{ id = "console", size = 0.5 },
						},
						position = "bottom",
						size = 10,
					},
				},
			})

			-- Virtual text for debugging
			require("nvim-dap-virtual-text").setup({})

			-- Auto open/close DAP UI
			dap.listeners.after.event_initialized["dapui_config"] = function()
				dapui.open()
			end
			dap.listeners.before.event_terminated["dapui_config"] = function()
				dapui.close()
			end
			dap.listeners.before.event_exited["dapui_config"] = function()
				dapui.close()
			end

			-- Python debugging (use venv with debugpy installed)
			local debugpy_path = vim.fn.expand("~/.local/share/nvim/debugpy-venv/bin/python")
			if vim.fn.executable(debugpy_path) == 1 then
				require("dap-python").setup(debugpy_path)
			else
				require("dap-python").setup("python")
			end

			-- C/C++ debugging with codelldb
			dap.adapters.codelldb = {
				type = "server",
				port = "${port}",
				executable = {
					command = vim.fn.stdpath("data") .. "/mason/bin/codelldb",
					args = { "--port", "${port}" },
				},
			}

			dap.configurations.cpp = {
				{
					name = "Launch file",
					type = "codelldb",
					request = "launch",
					program = function()
						return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
					end,
					cwd = "${workspaceFolder}",
					stopOnEntry = false,
				},
			}
			dap.configurations.c = dap.configurations.cpp

			-- Rust uses the same codelldb adapter
			dap.configurations.rust = {
				{
					name = "Launch file",
					type = "codelldb",
					request = "launch",
					program = function()
						return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/target/debug/", "file")
					end,
					cwd = "${workspaceFolder}",
					stopOnEntry = false,
				},
			}

			-- Breakpoint signs
			vim.fn.sign_define("DapBreakpoint", { text = "●", texthl = "DapBreakpoint", linehl = "", numhl = "" })
			vim.fn.sign_define(
				"DapBreakpointCondition",
				{ text = "●", texthl = "DapBreakpointCondition", linehl = "", numhl = "" }
			)
			vim.fn.sign_define("DapLogPoint", { text = "◆", texthl = "DapLogPoint", linehl = "", numhl = "" })
			vim.fn.sign_define(
				"DapStopped",
				{ text = "▶", texthl = "DapStopped", linehl = "DapStopped", numhl = "DapStopped" }
			)
		end,
	},

	-- ============================================
	-- RUST
	-- ============================================
	{
		"mrcjkb/rustaceanvim",
		version = "^5",
		lazy = false,
		config = function()
			vim.g.rustaceanvim = {
				server = {
					on_attach = function(client, bufnr)
						-- LSP keymaps
						local opts = { buffer = bufnr }
						vim.keymap.set(
							"n",
							"gd",
							vim.lsp.buf.definition,
							vim.tbl_extend("force", opts, { desc = "Go to definition" })
						)
						vim.keymap.set(
							"n",
							"gD",
							vim.lsp.buf.declaration,
							vim.tbl_extend("force", opts, { desc = "Go to declaration" })
						)
						vim.keymap.set(
							"n",
							"gi",
							vim.lsp.buf.implementation,
							vim.tbl_extend("force", opts, { desc = "Go to implementation" })
						)
						vim.keymap.set(
							"n",
							"gr",
							vim.lsp.buf.references,
							vim.tbl_extend("force", opts, { desc = "Go to references" })
						)
						vim.keymap.set(
							"n",
							"K",
							vim.lsp.buf.hover,
							vim.tbl_extend("force", opts, { desc = "Hover documentation" })
						)
						vim.keymap.set(
							"n",
							"<leader>ca",
							vim.lsp.buf.code_action,
							vim.tbl_extend("force", opts, { desc = "Code actions" })
						)
						vim.keymap.set(
							"n",
							"<leader>rn",
							vim.lsp.buf.rename,
							vim.tbl_extend("force", opts, { desc = "Rename symbol" })
						)
					end,
					default_settings = {
						["rust-analyzer"] = {
							-- Performance optimizations
							checkOnSave = {
								command = "clippy",
								extraArgs = { "--no-deps" }, -- Don't check dependencies
							},
							cargo = {
								allFeatures = false, -- Don't enable all features (faster)
								loadOutDirsFromCheck = true,
								buildScripts = {
									enable = true,
								},
							},
							procMacro = {
								enable = true,
								attributes = {
									enable = true,
								},
							},
							-- Reduce CPU usage
							completion = {
								callable = {
									snippets = "fill_arguments",
								},
								postfix = {
									enable = true,
								},
							},
							diagnostics = {
								enable = true,
								experimental = {
									enable = false, -- Disable experimental diagnostics
								},
							},
							-- Enhanced features
							hover = {
								actions = {
									enable = true,
									references = {
										enable = true,
									},
								},
							},
							lens = {
								enable = true,
								references = {
									adt = { enable = true },
									enumVariant = { enable = true },
									method = { enable = true },
									trait = { enable = true },
								},
							},
							inlayHints = {
								bindingModeHints = {
									enable = false,
								},
								chainingHints = {
									enable = true,
								},
								closingBraceHints = {
									minLines = 25,
								},
								closureReturnTypeHints = {
									enable = "never",
								},
								lifetimeElisionHints = {
									enable = "never",
									useParameterNames = false,
								},
								maxLength = 25,
								parameterHints = {
									enable = true,
								},
								reborrowHints = {
									enable = "never",
								},
								renderColons = true,
								typeHints = {
									enable = true,
									hideClosureInitialization = false,
									hideNamedConstructor = false,
								},
							},
						},
					},
				},
				-- Better DAP integration
				dap = {
					adapter = {
						type = "executable",
						command = vim.fn.stdpath("data") .. "/mason/bin/codelldb",
						name = "rt_lldb",
					},
				},
			}
		end,
	},

	-- Cargo.toml dependency management
	{
		"saecki/crates.nvim",
		event = { "BufRead Cargo.toml" },
		config = function()
			require("crates").setup({
				completion = {
					cmp = { enabled = true },
				},
			})
		end,
	},

	-- ============================================
	-- C/C++ ENHANCEMENTS
	-- ============================================
	{
		"p00f/clangd_extensions.nvim",
		ft = { "c", "cpp", "objc", "objcpp" },
		config = function()
			require("clangd_extensions").setup({
				inlay_hints = {
					inline = vim.fn.has("nvim-0.10") == 1,
					only_current_line = false,
					show_parameter_hints = true,
					parameter_hints_prefix = "<- ",
					other_hints_prefix = "=> ",
					highlight = "Comment",
				},
				ast = {
					role_icons = {
						type = "",
						declaration = "",
						expression = "",
						specifier = "",
						statement = "",
						["template argument"] = "",
					},
				},
				memory_usage = {
					border = "rounded",
				},
				symbol_info = {
					border = "rounded",
				},
			})
		end,
	},

	-- Header/Source switching for C/C++
	{
		"Badhi/nvim-treesitter-cpp-tools",
		ft = { "c", "cpp" },
		dependencies = { "nvim-treesitter/nvim-treesitter" },
		config = function()
			require("nt-cpp-tools").setup({
				preview = {
					quit = "q",
					accept = "<tab>",
				},
			})
		end,
	},

	-- CMake integration
	{
		"Civitasv/cmake-tools.nvim",
		ft = { "cmake" },
		dependencies = { "nvim-lua/plenary.nvim" },
		config = function()
			require("cmake-tools").setup({
				cmake_command = "cmake",
				cmake_build_directory = "build",
				cmake_build_directory_prefix = "",
				cmake_generate_options = { "-DCMAKE_EXPORT_COMPILE_COMMANDS=1" },
				cmake_build_options = {},
				cmake_console_size = 10,
				cmake_console_position = "belowright",
				cmake_show_console = "always",
				cmake_dap_configuration = {
					name = "cpp",
					type = "codelldb",
					request = "launch",
				},
				cmake_variants_message = {
					short = { show = true },
					long = { show = true, max_length = 40 },
				},
			})
		end,
	},

	-- ============================================
	-- PYTHON ENHANCEMENTS
	-- ============================================
	{
		"linux-cultist/venv-selector.nvim",
		dependencies = {
			"neovim/nvim-lspconfig",
			"nvim-telescope/telescope.nvim",
			"mfussenegger/nvim-dap-python",
		},
		branch = "regexp",
		config = function()
			require("venv-selector").setup({
				name = { "venv", ".venv", "env", ".env" },
			})
		end,
		keys = {
			{ "<leader>cv", "<cmd>VenvSelect<cr>", desc = "Select Python venv" },
		},
	},
}

local opts = {}
require("lazy").setup(plugins, opts)

-- Key mappings
local keymap = vim.keymap.set

-- Better escape
keymap("i", "jk", "<Esc>", { desc = "Exit insert mode" })
keymap("i", "kj", "<Esc>", { desc = "Exit insert mode" })

-- Clear search highlight
keymap("n", "<Esc>", "<cmd>nohlsearch<cr>", { desc = "Clear search highlight" })

-- Better up/down (handle wrapped lines)
keymap({ "n", "x" }, "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
keymap({ "n", "x" }, "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })

-- Move lines up/down
keymap("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move line down" })
keymap("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move line up" })

-- Better indenting (stay in visual mode)
keymap("v", "<", "<gv", { desc = "Indent left" })
keymap("v", ">", ">gv", { desc = "Indent right" })

-- Copy to clipboard with Ctrl+C
keymap("v", "<C-c>", '"+y', { desc = "Copy to clipboard" })

-- Telescope
keymap("n", "<leader>ff", "<cmd>Telescope find_files<cr>", { desc = "Find files" })
keymap("n", "<leader>fg", "<cmd>Telescope live_grep<cr>", { desc = "Live grep" })
keymap("n", "<leader>fb", "<cmd>Telescope buffers<cr>", { desc = "Find buffers" })
keymap("n", "<leader>fh", "<cmd>Telescope help_tags<cr>", { desc = "Help tags" })
keymap("n", "<leader>fp", "<cmd>Telescope projects<cr>", { desc = "Projects" })
keymap("n", "<leader>fr", "<cmd>Telescope oldfiles<cr>", { desc = "Recent files" })
keymap("n", "<leader>fc", "<cmd>Telescope git_commits<cr>", { desc = "Git commits" })
keymap("n", "<leader>fs", "<cmd>Telescope git_status<cr>", { desc = "Git status" })
keymap("n", "<leader>fd", "<cmd>Telescope diagnostics<cr>", { desc = "Diagnostics" })
keymap("n", "<leader>/", "<cmd>Telescope current_buffer_fuzzy_find<cr>", { desc = "Search in buffer" })

-- File explorer
keymap("n", "<leader>e", "<cmd>NvimTreeToggle<cr>", { desc = "Toggle file explorer" })

-- Buffer navigation
keymap("n", "<S-l>", "<cmd>bnext<cr>", { desc = "Next buffer" })
keymap("n", "<S-h>", "<cmd>bprevious<cr>", { desc = "Previous buffer" })
-- <leader>bd handled by mini.bufremove
keymap("n", "<leader>bo", "<cmd>%bd|e#|bd#<cr>", { desc = "Close other buffers" })

-- Better window navigation
keymap("n", "<C-h>", "<C-w>h", { desc = "Move to left window" })
keymap("n", "<C-j>", "<C-w>j", { desc = "Move to bottom window" })
keymap("n", "<C-k>", "<C-w>k", { desc = "Move to top window" })
keymap("n", "<C-l>", "<C-w>l", { desc = "Move to right window" })

-- Window resize
keymap("n", "<C-Up>", "<cmd>resize +2<cr>", { desc = "Increase window height" })
keymap("n", "<C-Down>", "<cmd>resize -2<cr>", { desc = "Decrease window height" })
keymap("n", "<C-Left>", "<cmd>vertical resize -2<cr>", { desc = "Decrease window width" })
keymap("n", "<C-Right>", "<cmd>vertical resize +2<cr>", { desc = "Increase window width" })

-- Diagnostics
keymap("n", "[d", vim.diagnostic.goto_prev, { desc = "Previous diagnostic" })
keymap("n", "]d", vim.diagnostic.goto_next, { desc = "Next diagnostic" })
keymap("n", "gl", vim.diagnostic.open_float, { desc = "Line diagnostics" })
keymap("n", "<leader>xl", vim.diagnostic.setloclist, { desc = "Diagnostics to loclist" })

-- Trouble (better diagnostics list)
keymap("n", "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>", { desc = "Diagnostics (Trouble)" })
keymap("n", "<leader>xX", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", { desc = "Buffer diagnostics" })
keymap("n", "<leader>xs", "<cmd>Trouble symbols toggle<cr>", { desc = "Symbols (Trouble)" })
keymap("n", "<leader>xq", "<cmd>Trouble qflist toggle<cr>", { desc = "Quickfix (Trouble)" })

-- Todo comments
keymap("n", "<leader>xt", "<cmd>TodoTrouble<cr>", { desc = "TODOs (Trouble)" })
keymap("n", "<leader>ft", "<cmd>TodoTelescope<cr>", { desc = "Find TODOs" })
keymap("n", "]t", function()
	require("todo-comments").jump_next()
end, { desc = "Next TODO" })
keymap("n", "[t", function()
	require("todo-comments").jump_prev()
end, { desc = "Previous TODO" })

-- Git (gitsigns)
keymap("n", "]h", "<cmd>Gitsigns next_hunk<cr>", { desc = "Next hunk" })
keymap("n", "[h", "<cmd>Gitsigns prev_hunk<cr>", { desc = "Previous hunk" })
keymap("n", "<leader>gs", "<cmd>Gitsigns stage_hunk<cr>", { desc = "Stage hunk" })
keymap("n", "<leader>gr", "<cmd>Gitsigns reset_hunk<cr>", { desc = "Reset hunk" })
keymap("n", "<leader>gS", "<cmd>Gitsigns stage_buffer<cr>", { desc = "Stage buffer" })
keymap("n", "<leader>gu", "<cmd>Gitsigns undo_stage_hunk<cr>", { desc = "Undo stage hunk" })
keymap("n", "<leader>gR", "<cmd>Gitsigns reset_buffer<cr>", { desc = "Reset buffer" })
keymap("n", "<leader>gp", "<cmd>Gitsigns preview_hunk<cr>", { desc = "Preview hunk" })
keymap("n", "<leader>gb", "<cmd>Gitsigns blame_line<cr>", { desc = "Blame line" })
keymap("n", "<leader>gd", "<cmd>Gitsigns diffthis<cr>", { desc = "Diff this" })

-- Format
keymap("n", "<leader>cf", function()
	require("conform").format({ lsp_format = "fallback" })
end, { desc = "Format file" })

-- Quick save
keymap("n", "<leader>w", "<cmd>w<cr>", { desc = "Save file" })

-- Quit
keymap("n", "<leader>qq", "<cmd>qa<cr>", { desc = "Quit all" })

-- ============================================
-- DEBUGGING KEYMAPS
-- ============================================
keymap("n", "<leader>dc", function()
	require("dap").continue()
end, { desc = "Continue" })
keymap("n", "<leader>db", function()
	require("dap").toggle_breakpoint()
end, { desc = "Toggle breakpoint" })
keymap("n", "<leader>dB", function()
	require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: "))
end, { desc = "Conditional breakpoint" })
keymap("n", "<leader>do", function()
	require("dap").step_over()
end, { desc = "Step over" })
keymap("n", "<leader>di", function()
	require("dap").step_into()
end, { desc = "Step into" })
keymap("n", "<leader>dO", function()
	require("dap").step_out()
end, { desc = "Step out" })
keymap("n", "<leader>dr", function()
	require("dap").repl.open()
end, { desc = "Open REPL" })
keymap("n", "<leader>dl", function()
	require("dap").run_last()
end, { desc = "Run last" })
keymap("n", "<leader>dt", function()
	require("dap").terminate()
end, { desc = "Terminate" })
keymap("n", "<leader>du", function()
	require("dapui").toggle()
end, { desc = "Toggle DAP UI" })
keymap("n", "<leader>de", function()
	require("dapui").eval()
end, { desc = "Evaluate expression" })
keymap("v", "<leader>de", function()
	require("dapui").eval()
end, { desc = "Evaluate selection" })

-- ============================================
-- SYMBOLS OUTLINE
-- ============================================
keymap("n", "<leader>cs", "<cmd>Outline<cr>", { desc = "Symbols outline" })

-- ============================================
-- INLAY HINTS TOGGLE (for Neovim 0.10+)
-- ============================================
if vim.lsp.inlay_hint then
	keymap("n", "<leader>cI", function()
		vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
	end, { desc = "Toggle inlay hints" })
end

-- ============================================
-- C/C++ KEYMAPS
-- ============================================
keymap("n", "<leader>cH", "<cmd>ClangdSwitchSourceHeader<cr>", { desc = "Switch header/source" })
keymap("n", "<leader>ci", "<cmd>ClangdSymbolInfo<cr>", { desc = "Symbol info" })
keymap("n", "<leader>cm", "<cmd>ClangdMemoryUsage<cr>", { desc = "Memory usage" })

-- CMake
keymap("n", "<leader>cg", "<cmd>CMakeGenerate<cr>", { desc = "CMake generate" })
keymap("n", "<leader>cb", "<cmd>CMakeBuild<cr>", { desc = "CMake build" })
keymap("n", "<leader>cr", "<cmd>CMakeRun<cr>", { desc = "CMake run" })
keymap("n", "<leader>ct", "<cmd>CMakeSelectBuildType<cr>", { desc = "CMake select build type" })
keymap("n", "<leader>cd", "<cmd>CMakeDebug<cr>", { desc = "CMake debug" })

-- ============================================
-- RUST KEYMAPS (rustaceanvim)
-- ============================================
keymap("n", "<leader>rc", function()
	vim.cmd.RustLsp("codeAction")
end, { desc = "Code action" })
keymap("n", "<leader>rr", function()
	vim.cmd.RustLsp("runnables")
end, { desc = "Runnables" })
keymap("n", "<leader>rd", function()
	vim.cmd.RustLsp("debuggables")
end, { desc = "Debuggables" })
keymap("n", "<leader>re", function()
	vim.cmd.RustLsp("expandMacro")
end, { desc = "Expand macro" })
keymap("n", "<leader>rp", function()
	vim.cmd.RustLsp("parentModule")
end, { desc = "Parent module" })
keymap("n", "<leader>rm", function()
	vim.cmd.RustLsp("rebuildProcMacros")
end, { desc = "Rebuild proc macros" })
keymap("n", "<leader>rh", function()
	vim.cmd.RustLsp({ "hover", "actions" })
end, { desc = "Hover actions" })
keymap("n", "<leader>rl", function()
	vim.cmd.RustLsp("openCargo")
end, { desc = "Open Cargo.toml" })
keymap("n", "<leader>rv", function()
	vim.cmd.RustLsp({ "view", "hir" })
end, { desc = "View HIR" })
keymap("n", "<leader>rV", function()
	vim.cmd.RustLsp({ "view", "mir" })
end, { desc = "View MIR" })

-- ============================================
-- PYTHON KEYMAPS
-- ============================================
keymap("n", "<leader>pt", function()
	require("dap-python").test_method()
end, { desc = "Test method" })
keymap("n", "<leader>pT", function()
	require("dap-python").test_class()
end, { desc = "Test class" })
keymap("v", "<leader>ps", function()
	require("dap-python").debug_selection()
end, { desc = "Debug selection" })

-- ============================================
-- C++ TEMPLATE FOR NEW FILES
-- ============================================
vim.api.nvim_create_autocmd("BufNewFile", {
	pattern = "*.cpp",
	command = "0r ~/.config/nvim/templates/skeleton.cpp",
})

-- ============================================
-- RUST TEMPLATE FOR NEW FILES
-- ============================================
vim.api.nvim_create_autocmd("BufNewFile", {
	pattern = "*.rs",
	command = "0r ~/.config/nvim/templates/skeleton.rs",
})

-- ============================================
-- LAZYVIM-STYLE KEYMAPS
-- ============================================
-- Noice (notifications/messages)
keymap("n", "<leader>sn", "", { desc = "+noice" })
keymap("n", "<leader>snl", function()
	require("noice").cmd("last")
end, { desc = "Noice Last Message" })
keymap("n", "<leader>snh", function()
	require("noice").cmd("history")
end, { desc = "Noice History" })
keymap("n", "<leader>sna", function()
	require("noice").cmd("all")
end, { desc = "Noice All" })
keymap("n", "<leader>snd", function()
	require("noice").cmd("dismiss")
end, { desc = "Dismiss All" })

-- Illuminate (word highlighting)
keymap("n", "]]", function()
	require("illuminate").goto_next_reference(false)
end, { desc = "Next Reference" })
keymap("n", "[[", function()
	require("illuminate").goto_prev_reference(false)
end, { desc = "Prev Reference" })

-- Lazy plugin manager
keymap("n", "<leader>l", "<cmd>Lazy<cr>", { desc = "Lazy (Plugin Manager)" })
