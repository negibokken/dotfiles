require("config.lazy")
require("config.create-zettelkasten")
require("config.open-today-file")
require("config.tab-operation")
require("config.no-neck-pane")
require("config.mv-file-with-telescope")
require("config.rename-to-h1")
require("config.insert-quarter").setup()
require("config.open-quartely-note")
require("config.recent-file-with-telescope")

vim.api.nvim_set_keymap("i", "<C-j>", "<Esc>", { noremap = true, silent = true })

-- [basic] set English
vim.opt.langmenu = "en_US.UTF-8"

-- [basic] auto indent
vim.opt.expandtab = true

-- [basic] incremental search
vim.opt.incsearch = true

-- [basic] define tab shift width
vim.opt.shiftwidth = 2

-- [basic] ignore case
vim.opt.ignorecase = true

-- [basic] smart case (when using capital character then ignore non capital character)
vim.opt.smartcase = true

-- [basic] use smart indent
vim.opt.smartindent = true

-- [basic] indent property when press tab on in the head of line
vim.opt.smarttab = true

-- [basic] space num for tab
vim.opt.tabstop = 2

-- [basic] wrap line
vim.opt.whichwrap = "h,l,b,s,<,>,[,]"

-- [basic] encoding
vim.opt.encoding = "utf-8"
vim.opt.fileencoding = "utf-8"

-- [basic] spelling this should be placed after encoding to avoid reload
vim.opt.spell = true
vim.opt.spelllang = { "en_us", "cjk" }

-- [basic] copy to clipboard when yank
vim.opt.clipboard:append({ "unnamedplus" })

-- [basic] enable backspace
vim.opt.backspace = "indent,eol,start"

-- [basic] make special character visible
vim.opt.list = true
vim.opt.listchars = "tab:..,trail:_,eol:↲,extends:>,precedes:<,nbsp:%"

-- [basic] To avoid redrawtime exceed error
vim.opt.re = 0

-- [basic] To disable relative number
vim.opt.relativenumber = false

-- [basic] enable auto indent
vim.opt.autoindent = true

-- [basic] Auto reload when the files are changed
vim.opt.autoread = true
vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold", "CursorHoldI", "FocusGained" }, {
	command = "if mode() != 'c' | checktime | endif",
	pattern = { "*" },
})

-- [basic] yank filename or path
vim.keymap.set("n", "<leader>cpf", ":let @+ = expand('%:.')<CR>", { desc = "Copy relative path" })
vim.keymap.set("n", "<leader>cpF", ":let @+ = expand('%:t')<CR>", { desc = "Copy file name" })

-- emmet-vim
vim.g.user_emmet_leader_key = "<C-y>"

-- open init.lua with F1
vim.keymap.set("n", "<F1>", ":edit $MYVIMRC<CR>")

vim.keymap.set("i", "<C-e>", 'copilot#Accept("\\<CR>")', {
	expr = true,
	replace_keycodes = false,
})
vim.g.copilot_no_tab_map = true

-- [profiel] Enable to profile when NVIM_PROFILE environment variable is set
local should_profile = os.getenv("NVIM_PROFILE")
if should_profile then
	require("profile").instrument_autocmds()
	if should_profile:lower():match("^start") then
		require("profile").start("*")
	else
		require("profile").instrument("*")
	end
end

local function toggle_profile()
	local prof = require("profile")
	if prof.is_recording() then
		prof.stop()
		vim.ui.input({ prompt = "Save profile to:", completion = "file", default = "profile.json" }, function(filename)
			if filename then
				prof.export(filename)
				vim.notify(string.format("Wrote %s", filename))
			end
		end)
	else
		prof.start("*")
	end
end
vim.keymap.set("", "<f3>", toggle_profile)

-- [gitlinker] GitHub Permalink
vim.api.nvim_set_keymap(
	"n",
	"<leader>gp",
	'<cmd>lua require"gitlinker".get_buf_range_url("n", {action_callback = require"gitlinker.actions".copy_to_clipboard})<cr>',
	{ silent = true }
)
vim.api.nvim_set_keymap(
	"v",
	"<leader>gp",
	'<cmd>lua require"gitlinker".get_buf_range_url("v", {action_callback = require"gitlinker.actions".copy_to_clipboard})<cr>',
	{}
)
