local second_brain = os.getenv("SECOND_BRAIN")
_G.open_quarterly_note = function()
	local today = os.date("%Y-%m-%d")
    local year = os.date("%Y")
    local month = tonumber(os.date("%m"))
    local quarter = math.ceil(month / 3)
	local file_path = second_brain .. "/periodic-notes/quarterly-notes/" .. year .. "/" .. year .. "-Q" .. quarter .. ".md"

	local file = io.open(file_path, "r")
	if file then
		file:close()
		vim.cmd("edit " .. file_path)
	else
		vim.cmd("edit " .. file_path)
	end
end
-- キーマッピング (Alt + q)
vim.keymap.set("n", "<A-q>", ":lua open_quarterly_note()<CR>", { noremap = true, silent = true })
