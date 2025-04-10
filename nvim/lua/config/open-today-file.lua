local second_brain = os.getenv("SECOND_BRAIN")
_G.open_today_note = function()
	local today = os.date("%Y/%m/%Y-%m-%d")
	local file_path = second_brain .. "/periodic-notes/daily-notes/" .. today .. ".md"

	local file = io.open(file_path, "r")
	if file then
		file:close()
		vim.cmd("edit " .. file_path)
	else
		vim.cmd("edit " .. file_path)
	end
end
-- キーマッピング (Alt + c)
vim.keymap.set("n", "<A-c>", ":lua open_today_note()<CR>", { noremap = true, silent = true })
