"" set color scheme as vim-hybrid
syntax on
""let g:hybrid_custom_term_colors = 1
""let g:hybrid_reduced_contrast = 1 " Remove this line if using the default palette.
colorscheme hybrid
set background=dark
""autocmd vimenter * ++nested colorscheme gruvbox
highligh Normal ctermbg=none
highlight LineNr ctermfg=243 ""hi Visual cterm=NONE ctermbg=037 ctermfg=007 guibg=darkred guifg=white
hi CursorLine   cterm=NONE ctermbg=023 ctermfg=015 guibg=darkred guifg=white
hi CursorColumn cterm=NONE ctermbg=023 ctermfg=015 guibg=darkred guifg=white
