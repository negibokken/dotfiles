return {
	"stevearc/oil.nvim",
	---@module 'oil'
	---@type oil.SetupOpts
	opts = {
		default_file_explorer = true,
		columns = {
			"icon",
			"size",
		},
		view_options = {
			show_hidden = true,
		},
		win_options = {
			wrap = false,
		},
		keymaps = {
			["g?"] = "actions.show_help",
			["<CR>"] = "actions.select",
			["<C-s>"] = "actions.select_vsplit",
			["<C-h>"] = "actions.select_split",
			["<C-t>"] = "actions.select_tab",
			["<C-p>"] = "actions.preview",
			["<C-c>"] = "actions.close",
			["<C-l>"] = "actions.refresh",
			["-"] = "actions.parent",
			["_"] = "actions.open_cwd",
			["`"] = "actions.cd",
			["~"] = "actions.tcd",
			["gs"] = "actions.change_sort",
			["gx"] = "actions.open_external",
			["g."] = "actions.toggle_hidden",
			["g\\"] = "actions.toggle_trash",
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
				local current_buf = vim.api.nvim_get_current_buf()
				local current_win = vim.api.nvim_get_current_win()
				
				-- Check if we already have an oil window open
				for _, win in ipairs(vim.api.nvim_list_wins()) do
					local buf = vim.api.nvim_win_get_buf(win)
					if vim.bo[buf].filetype == "oil" then
						vim.api.nvim_set_current_win(win)
						return
					end
				end
				
				-- Create vertical split on the left and open oil
				vim.cmd("topleft vsplit")
				local new_win = vim.api.nvim_get_current_win()
				vim.api.nvim_win_set_width(new_win, 35)
				oil.open()
			end, 
			desc = "Open Oil file explorer in side panel" 
		},
		{ "<leader>E", "<cmd>Oil --float<CR>", desc = "Open Oil file explorer in floating window" },
	},
}
