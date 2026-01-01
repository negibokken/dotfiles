return {
	"nvim-neo-tree/neo-tree.nvim",
	branch = "v3.x",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
		"MunifTanjim/nui.nvim",
		-- "3rd/image.nvim", -- Optional image support in preview window: See `# Preview Mode` for more information
	},

	config = {
		window = {
			mappings = {
				["Z"] = "expand_all_nodes",
			},
		},
		filesystem = {
			follow_current_file = true,
			visible = true,
			hide_dot_files = false,
			hijack_netrw_behavior = "open_current",
			use_libuv_file_watcher = true,
			open_files_as_nodes = true, -- ファイルをノードとして開く
			show_hidden = false, -- 隠しファイルを表示する
			-- 再帰的なディレクトリ展開の設定
			auto_expand_width = true, -- ウィンドウ幅に合わせて自動的に展開する
			depth = 1, -- 0で無制限、1で1階層のみ展開
			async_directory_scan = "always", -- Use async scanning for better responsiveness
			scan_mode = "shallow", -- Avoid deep scanning unless needed
			check_gitignore_in_search = false, -- Skip gitignore checks during search
			search_limit = 50, -- Limit search results
		},
		resize_timer_interval = 50,
	},
}
