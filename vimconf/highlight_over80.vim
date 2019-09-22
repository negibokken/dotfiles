" highlight when more than There are 80 character on one line
highlight turn gui=standout cterm=standout
autocmd BufRead *.cc,*.h,*.cpp,*.rb,*.ts,*.js,*.py call matchadd("turn", '.\%>81v')

