return {
	"nvim-neo-tree/neo-tree.nvim",
	branch = "v3.x",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-tree/nvim-web-devicons",
		"MunifTanjim/nui.nvim",
	},
	keys = {
		{ "<leader>e", "<cmd>Neotree toggle left<CR>", desc = "Toggle Neo-tree (left)" },
		{ "<leader>E", "<cmd>Neotree toggle float<CR>", desc = "Toggle Neo-tree (floating)" },
	},
	config = function()
		require("neo-tree").setup({
			window = {
				position = "left",
				width = 35,
				mappings = {
					["Z"] = "expand_all_nodes",
					["<tab>"] = function(state)
						local node = state.tree:get_node()
						if node.type == "file" then
							vim.cmd("tabedit " .. node.path)
						end
					end,
				},
			},
			filesystem = {
				follow_current_file = {
					enabled = true,
					leave_dirs_open = false, -- パフォーマンス向上のため
				},
				hide_dot_files = false,
				hijack_netrw_behavior = "open_current",
				use_libuv_file_watcher = true, -- ファイルウォッチャーを維持
				-- パフォーマンス最適化設定
				scan_mode = "shallow", -- 浅いスキャンでパフォーマンス向上
				bind_to_cwd = false, -- cwdの変更に自動追随しない
				-- 自動展開を無効化してパフォーマンス向上
				never_show_by_pattern = {
					".DS_Store",
					"thumbs.db",
					"node_modules",
				},
			},
		})
	end,
}
