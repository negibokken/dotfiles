local telescope_builtin = require("telescope.builtin")

_G.move_current_file = function()
	local current_file = vim.api.nvim_buf_get_name(0) -- 現在のファイルのパス
	if current_file == "" then
		print("No file opened")
		return
	end

	telescope_builtin.find_files({
		prompt_title = "Select Destination Directory",
		cwd = vim.fn.getcwd(), -- カレントディレクトリ基準
		find_command = { "find", ".", "-type", "d", "!", "-path", "./.git*", "!", "-path", "." },
		attach_mappings = function(_, map)
			map("i", "<CR>", function(prompt_bufnr)
				local action_state = require("telescope.actions.state")
				local actions = require("telescope.actions")
				local selection = action_state.get_selected_entry()
				actions.close(prompt_bufnr)

				if selection then
					local dest_dir = selection[1] -- 選択したディレクトリ
					local filename = vim.fn.fnamemodify(current_file, ":t") -- ファイル名
					local new_path = dest_dir .. "/" .. filename

					-- ファイル移動
					local success, err = os.rename(current_file, new_path)
					if success then
						-- バッファを新しいパスで開く
						vim.cmd("e " .. new_path)
						print("Moved to " .. new_path)
					else
						print("Error moving file: " .. err)
					end
				end
			end)
			return true
		end,
	})
end

-- キーマップ設定
vim.api.nvim_set_keymap("n", "<leader>mv", ":lua move_current_file()<CR>", { noremap = true, silent = true })
