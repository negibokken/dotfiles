_G.create_zettelkasten_note = function()
	local second_brain = vim.fn.expand("$SECOND_BRAIN") .. "/00--zettelkasten"

	if vim.fn.isdirectory(second_brain) == 0 then
		vim.fn.mkdir(second_brain, "p")
	end

	local filename = second_brain .. os.date("/%Y%m%d%H%M%S") .. ".md"

	if filename ~= "" then
		vim.cmd("edit " .. filename)
	end
end

vim.api.nvim_create_user_command("Zettelkasten", create_zettelkasten_note, { nargs = 0 })
vim.keymap.set("n", "<A-z>", ":lua create_zettelkasten_note()<CR>:NoNeckPain<CR>", { noremap = true, silent = true })
