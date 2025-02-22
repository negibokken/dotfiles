_G.rename_file_to_h1 = function()
	local buf = vim.api.nvim_get_current_buf()
	local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)

	-- Markdownのh1要素 (`# 見出し`) を検索
	local h1_text = nil
	for _, line in ipairs(lines) do
		local match = line:match("^#%s+(.+)")
		if match then
			h1_text = match
			break
		end
	end

	if not h1_text then
		print("No H1 heading found")
		return
	end

	-- ファイル名として使用可能な形式に変換（スペースを`_`に、特殊文字を除去）
	local sanitized_filename = h1_text:gsub('[%s/\\:*?"<>|]', "_") .. ".md"

	local current_file = vim.api.nvim_buf_get_name(buf)
	if current_file == "" then
		print("Buffer has no associated file")
		return
	end

	local new_path = vim.fn.fnamemodify(current_file, ":h") .. "/" .. sanitized_filename

	-- ファイルをリネーム
	local success, err = os.rename(current_file, new_path)
	if success then
		-- 新しいファイルを開き、バッファを更新
		vim.cmd("e " .. new_path)
		print("File renamed to " .. sanitized_filename)
	else
		print("Error renaming file: " .. err)
	end
end

-- コマンドとして登録
vim.api.nvim_create_user_command("RenameToH1", rename_file_to_h1, {})

-- キーマップ（例: `<leader>rn` で実行）
vim.api.nvim_set_keymap("n", "<leader>rn", ":RenameToH1<CR>", { noremap = true, silent = true })
