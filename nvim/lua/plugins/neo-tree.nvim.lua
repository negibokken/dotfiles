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
			follow_current_file = true, -- 現在開いているファイルをNeo-Treeでハイライトする
			-- group_empty_dirs = true, -- 空のディレクトリをグループ化する
			hide_dot_files = false, -- ドットファイルを非表示にする
			hijack_netrw_behavior = "open_current", -- netrwの挙動を乗っ取る
			use_libuv = true, -- libuvを使うことでパフォーマンスを向上させる
			open_files_as_nodes = true, -- ファイルをノードとして開く
			show_hidden = false, -- 隠しファイルを表示する
			-- 再帰的なディレクトリ展開の設定
			auto_expand_width = true, -- ウィンドウ幅に合わせて自動的に展開する
			depth = 0, -- 0で無制限、1で1階層のみ展開
		},
	},
}
