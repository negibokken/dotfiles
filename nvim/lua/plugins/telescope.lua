return {
	"nvim-telescope/telescope.nvim",
	branch = "master",
	dependencies = { "nvim-lua/plenary.nvim" },
	config = function()
		local actions = require("telescope.actions")
		require("telescope").setup({
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
		-- Telescopeで特定のキーバインドを登録する例
		local builtin = require("telescope.builtin")
		vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Find Files" }) -- ファイル検索
		vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "Live Grep" }) -- grep検索
		vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "Find Buffers" }) -- バッファ検索
		vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "Find Help" }) -- ヘルプ検索
	end,
}
