return {
	"nvim-telescope/telescope.nvim",
	branch = "master",
	dependencies = {
		"nvim-lua/plenary.nvim",
		{
			"nvim-telescope/telescope-live-grep-args.nvim",
			-- This will not install any breaking changes.
			-- For major updates, this must be adjusted manually.
			version = "^1.0.0",
		},
	},
	config = function()
		local actions = require("telescope.actions")
		local telescope = require("telescope")
		telescope.setup({
			defaults = {
				mappings = {
					i = { -- インサートモードでのキー設定
						["<C-n>"] = actions.move_selection_next, -- 次の候補に移動
						["<C-p>"] = actions.move_selection_previous, -- 前の候補に移動
						["<C-c>"] = actions.close, -- Telescopeを閉じる
					},
					n = { -- ノーマルモードでのキー設定
						["q"] = actions.close, -- qでTelescopeを閉じる
					},
				},
			},
		})
		telescope.load_extension("live_grep_args")
		-- Telescopeで特定のキーバインドを登録する例
		local builtin = require("telescope.builtin")
		vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Find Files" }) -- ファイル検索
		-- vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "Live Grep" }) -- grep検索
		vim.keymap.set("n", "<leader>fg", ":lua require('telescope').extensions.live_grep_args.live_grep_args()<CR>")
		vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "Find Buffers" }) -- バッファ検索
		vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "Find Help" }) -- ヘルプ検索
	end,
}
