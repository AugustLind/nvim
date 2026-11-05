-- Key mappings
local keymap = vim.keymap.set

-- Better escape
keymap("i", "jk", "<Esc>", { desc = "Exit insert mode" })
keymap("i", "kj", "<C-\\><C-n>", { desc = "Exit insert mode", silent = true })

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
keymap("n", "<leader>cs", "<cmd>Trouble symbols toggle<cr>", { desc = "Symbols outline" })
keymap("n", "<leader>o", "<cmd>Trouble symbols toggle<cr>", { desc = "Toggle symbols" })

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
keymap("n", "<leader>cR", "<cmd>CMakeRun<cr>", { desc = "CMake run" })
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
