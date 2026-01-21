_G.create_zettelkasten_note = function(isInsertMode)
	local second_brain = vim.fn.expand("$SECOND_BRAIN") .. "/00--zettelkasten"

	if vim.fn.isdirectory(second_brain) == 0 then
		vim.fn.mkdir(second_brain, "p")
	end

	local col_offset = 0
	if isInsertMode then
		col_offset = 1
	end

	local filename = second_brain .. os.date("/%Y%m%d%H%M%S") .. ".md"
	local obsidian_path = "/00--zettelkasten" .. os.date("/%Y%m%d%H%M%S") .. ".md"
	local id = os.date("%Y%m%d%H%M%S")

	-- 選択されているテキストを取得
	local selected_text = ""
	local is_visual_mode = false
	local start_line, start_col, end_line, end_col

	-- ビジュアル選択のマークが存在するかチェック
	local start_pos = vim.fn.getpos("'<")
	local end_pos = vim.fn.getpos("'>")
	local current_pos = vim.fn.getpos(".")

	-- マークが有効で、かつ現在のカーソル位置と異なる場合（=選択があった）
	if start_pos[2] > 0 and end_pos[2] > 0 and (start_pos[2] ~= end_pos[2] or start_pos[3] ~= end_pos[3]) then
		is_visual_mode = true
		start_line = start_pos[2] - 1
		start_col = start_pos[3] - 1
		end_line = end_pos[2] - 1

		-- end_pos[3] は選択された最後の文字の開始バイト位置（1-indexed）
		-- マルチバイト文字を正しく扱うため、その文字の次のバイト位置を計算する
		local end_line_content = vim.api.nvim_buf_get_lines(0, end_line, end_line + 1, false)[1]
		local byte_pos = end_pos[3] - 1 -- 0-indexed
		local char_idx = vim.fn.charidx(end_line_content, byte_pos)
		local next_byte_pos = vim.fn.byteidx(end_line_content, char_idx + 1)
		if next_byte_pos == -1 then
			next_byte_pos = #end_line_content
		end
		end_col = next_byte_pos

		local lines = vim.api.nvim_buf_get_text(0, start_line, start_col, end_line, end_col, {})
		selected_text = table.concat(lines, " ")
	end

	local link_name = selected_text ~= "" and selected_text or (os.date("%Y%m%d%H%M%S") .. ".md")

	local current_win = vim.api.nvim_get_current_win()
	local current_buf = vim.api.nvim_get_current_buf()
	local cursor_pos = vim.api.nvim_win_get_cursor(current_win)

	-- テキストを挿入または置き換え
	if is_visual_mode then
		-- ビジュアルモードの場合は選択範囲を置き換え
		vim.api.nvim_buf_set_text(
			current_buf,
			start_line,
			start_col,
			end_line,
			end_col,
			{ "[[" .. id .. "|" .. link_name .. "]]" }
		)
	else
		-- ノーマルモード/インサートモードの場合はカーソル位置に挿入
		vim.api.nvim_buf_set_text(
			current_buf,
			cursor_pos[1] - 1,
			cursor_pos[2] + col_offset,
			cursor_pos[1] - 1,
			cursor_pos[2] + col_offset,
			{ "[[" .. id .. "|" .. link_name .. "]]" }
		)
	end

	if filename ~= "" then
		vim.cmd("vsplit")
		vim.cmd("edit " .. filename)

		-- ビジュアルモードで選択されたテキストがある場合、ファイルの最初に見出しを追加
		if is_visual_mode and selected_text ~= "" then
			local new_buf = vim.api.nvim_get_current_buf()
			vim.api.nvim_buf_set_lines(new_buf, 0, 0, false, { "# " .. selected_text, "" })
		end
	end
end

vim.api.nvim_create_user_command("Zettelkasten", create_zettelkasten_note, { nargs = 0 })
vim.keymap.set("n", "<A-z>", ":lua create_zettelkasten_note()<CR>", { noremap = true, silent = true })
vim.keymap.set("i", "<A-z>", "<Esc>:lua create_zettelkasten_note(true)<CR>", { noremap = true, silent = true })
vim.keymap.set("v", "<A-z>", ":<C-u>lua create_zettelkasten_note()<CR>", { noremap = true, silent = true })
