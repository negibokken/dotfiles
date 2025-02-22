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
	local link_name = os.date("%Y%m%d%H%M%S") .. ".md"
	local id = os.date("%Y%m%d%H%M%S")

	local current_win = vim.api.nvim_get_current_win()
	local current_buf = vim.api.nvim_get_current_buf()
	local cursor_pos = vim.api.nvim_win_get_cursor(current_win)

	-- カーソル位置にファイル名を挿入
	vim.api.nvim_buf_set_text(
		current_buf,
		cursor_pos[1] - 1,
		cursor_pos[2] + col_offset,
		cursor_pos[1] - 1,
		cursor_pos[2] + col_offset,
		{ "[[" .. id .. "|" .. link_name .. "]]" }
	)

	if filename ~= "" then
		vim.cmd("vsplit")
		vim.cmd("edit " .. filename)
	end
end

vim.api.nvim_create_user_command("Zettelkasten", create_zettelkasten_note, { nargs = 0 })
vim.keymap.set("n", "<A-z>", ":lua create_zettelkasten_note()<CR>", { noremap = true, silent = true })
vim.keymap.set("i", "<A-z>", "<Esc>:lua create_zettelkasten_note(true)<CR>", { noremap = true, silent = true })
