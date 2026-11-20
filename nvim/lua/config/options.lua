-- LazyVim loads this before configuring plugins.
vim.g.lazyvim_cmp = "nvim-cmp"
vim.g.lazyvim_picker = "telescope"

local opt = vim.opt
opt.langmenu = "en_US.UTF-8"
opt.expandtab = true
opt.shiftwidth = 2
opt.tabstop = 2
opt.incsearch = true
opt.ignorecase = true
opt.smartcase = true
opt.smartindent = true
opt.smarttab = true
opt.whichwrap = "h,l,b,s,<,>,[,]"
opt.encoding = "utf-8"
opt.fileencoding = "utf-8"
opt.spell = false -- LazyVim enables this locally for prose filetypes.
opt.spelllang = { "en_us", "cjk" }
opt.clipboard:append("unnamedplus")
opt.backspace = "indent,eol,start"
opt.list = true
opt.listchars = "tab:..,trail:_,eol:↲,extends:>,precedes:<,nbsp:%"
opt.relativenumber = false
opt.autoindent = true
opt.autoread = true
