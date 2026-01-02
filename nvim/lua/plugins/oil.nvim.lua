return {
	"stevearc/oil.nvim",
	---@module 'oil'
	---@type oil.SetupOpts
	opts = {
		default_file_explorer = true,
		columns = {
			"icon",
		},
		buf_options = {
			buflisted = false,
			bufhidden = "hide",
		},
		win_options = {
			wrap = false,
			signcolumn = "no",
			cursorcolumn = false,
			foldcolumn = "0",
			spell = false,
			list = false,
			conceallevel = 3,
			concealcursor = "nvic",
		},
		delete_to_trash = false,
		skip_confirm_for_simple_edits = false,
		prompt_save_on_select_new_entry = true,
		cleanup_delay_ms = 2000,
		lsp_file_methods = {
			enabled = true,
			timeout_ms = 1000,
			autosave_changes = false,
		},
		constrain_cursor = "editable",
		watch_for_changes = false,
		view_options = {
			show_hidden = false,
			is_hidden_file = function(name, bufnr)
				local m = name:match("^%.$")
				return m ~= nil
			end,
			is_always_hidden = function(name, bufnr)
				return false
			end,
			natural_order = "fast",
			case_insensitive = false,
			sort = {
				{ "type", "asc" },
				{ "name", "asc" },
			},
		},
		float = {
			padding = 2,
			max_width = 0,
			max_height = 0,
			border = "rounded",
			win_options = {
				winblend = 0,
			},
		},
	},
	-- Optional dependencies
	dependencies = { { "nvim-mini/mini.icons", opts = {} } },
	-- dependencies = { "nvim-tree/nvim-web-devicons" }, -- use if you prefer nvim-web-devicons
	-- Lazy loading is not recommended because it is very tricky to make it work correctly in all situations.
	lazy = false,
	keys = {
		{
			"<leader>e",
			function()
				local oil = require("oil")
				local oil_bufnr = nil
				local oil_winid = nil
				
				-- Find if oil window is already open
				for _, winid in ipairs(vim.api.nvim_list_wins()) do
					local bufnr = vim.api.nvim_win_get_buf(winid)
					if vim.bo[bufnr].filetype == "oil" then
						oil_bufnr = bufnr
						oil_winid = winid
						break
					end
				end
				
				if oil_winid then
					-- Close oil window if it's open
					vim.api.nvim_win_close(oil_winid, false)
				else
					-- Open oil in left split
					vim.cmd("topleft vsplit")
					vim.cmd("vertical resize 35")
					oil.open()
				end
			end,
			desc = "Toggle Oil file explorer in left pane",
		},
	},
}

