" Spell check
" mark mistakes with  underline and bold

set spell
function! s:SpellConf()
  set spelllang+=en,cjk
  hi clear SpellBad
  hi SpellBad cterm=underline,bold

  redir! => syntax
  silent syntax
  redir END

  set spell

  if syntax =~? '/<comment\>'
    syntax spell default
    syntax match SpellNotAscii /\<\A\+\>/ contains=@NoSpell transparent containedin=Comment contained
    syntax match SpellMaybeCode /\<\h\l*[_A-Z]\h\{-}\>/ contains=@NoSpell transparent containedin=Comment contained
  else
    syntax spell toplevel
    syntax match SpellNotAscii /\<\A\+\>/ contains=@NoSpell transparent
    syntax match SpellMaybeCode /\<\h\l*[_A-Z]\h\{-}\>/ contains=@NoSpell transparent
  endif

  syntax cluster Spell add=SpellNotAscii,SpellMaybeCode
endfunction

augroup spell_check
  autocmd!
  autocmd BufReadPost,BufNewFile,Syntax * call s:SpellConf()
augroup END
