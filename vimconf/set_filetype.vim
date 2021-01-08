"" set filetype
if has("autocmd")
  filetype on
  autocmd BufNewFile,BufRead *.{md,mdwn,mkd,mkdn,mark*} set filetype=markdown
  autocmd BufNewFile,BufRead *.nas set filetype=nas
  autocmd BufRead,BufNewFile *.ts set filetype=typescript
  autocmd BufNewFile,BufRead *.h,*.c,*.cc,*.cpp set filetype=cpp
endif

