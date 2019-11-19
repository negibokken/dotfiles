autocmd BufWritePre * :%s/\s\+$//ge
autocmd BufWritePre * :%s/:silent Ggrep/:silent Ggrep /ge
