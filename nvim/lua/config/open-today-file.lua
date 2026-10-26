local second_brain = os.getenv("SECOND_BRAIN")

local function git(args)
	return vim.system(vim.list_extend({ "git" }, args), { cwd = second_brain, timeout = 10000 }):wait().code == 0
end

-- GitHub Action が毎日 0 時(JST)に作るノートは、pull するまでローカルに存在しない。
-- 存在しないまま edit すると空の新規バッファになり、後から届いたファイルと衝突するため、先に origin から取得する。
local function fetch_from_origin(relative_path)
	return git({ "fetch", "origin", "main" }) and git({ "checkout", "origin/main", "--", relative_path })
end

_G.open_today_note = function()
	local relative_path = "periodic-notes/daily-notes/" .. os.date("%Y/%m/%Y-%m-%d") .. ".md"
	local file_path = second_brain .. "/" .. relative_path

	if vim.fn.filereadable(file_path) == 0 and not fetch_from_origin(relative_path) then
		vim.notify(
			"今日のノートを origin から取得できませんでした。新規ファイルとして開きます",
			vim.log.levels.WARN
		)
	end
	vim.cmd("edit " .. vim.fn.fnameescape(file_path))
end

-- キーマッピング (Alt + c)
vim.keymap.set("n", "<A-c>", open_today_note, { noremap = true, silent = true })
