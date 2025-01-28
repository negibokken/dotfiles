_G.create_zettelkasten_note = function()
	local second_brain = vim.fn.expand("$SECOND_BRAIN") .. "/00--zettelkasten"

	if vim.fn.isdirectory(second_brain) == 0 then
		vim.fn.mkdir(second_brain, "p")
	end

	local filename = second_brain .. os.date("/%Y%m%d%H%M%S") .. ".md"
	local obsidian_path = "/00--zettelkasten" .. os.date("/%Y%m%d%H%M%S") .. ".md"
	local link_name = os.date("zettelkasten-%Y%m%d%H%M%S") .. ".md"

	local current_win = vim.api.nvim_get_current_win()
	local current_buf = vim.api.nvim_get_current_buf()
	local cursor_pos = vim.api.nvim_win_get_cursor(current_win)

	-- カーソル位置にファイル名を挿入
	vim.api.nvim_buf_set_text(
		current_buf,
		cursor_pos[1] - 1,
		cursor_pos[2],
		cursor_pos[1] - 1,
		cursor_pos[2],
		{ "[[" .. obsidian_path .. "|" .. link_name .. "]]" }
	)

	if filename ~= "" then
		vim.cmd("edit " .. filename)
	end
end

vim.api.nvim_create_user_command("Zettelkasten", create_zettelkasten_note, { nargs = 0 })
vim.keymap.set("n", "<A-z>", ":lua create_zettelkasten_note()<CR>", { noremap = true, silent = true })
vim.keymap.set("i", "<A-z>", "<ESC>:lua create_zettelkasten_note()<CR>", { noremap = true, silent = true })
