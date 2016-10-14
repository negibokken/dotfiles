"新しい行のインデントを現在行と同じにする
set autoindent
"Vi互換をオフ
set nocompatible
"タブの代わりに空白文字を挿入する
set expandtab
"インクリメンタルサーチを行う
set incsearch
""行番号を表示する
set number
"シフト移動幅
set shiftwidth=2
"閉じ括弧が入力されたとき、対応する括弧を表示する
set showmatch
""検索時に大文字を含んでいたら大/小を区別
set smartcase
"新しい行を作ったときに高度な自動インデントを行う
set smartindent
""行頭の余白内で Tab を打ち込むと、'shiftwidth' の数だけインデントする。 set smarttab
"ファイル内の <Tab> が対応する空白の数
set tabstop=2
"カーソルを行頭、行末で止まらないようにする
set whichwrap=b,s,h,l,<,>,[,]
""検索をファイルの先頭へループしない
set nowrapscan
""常にステータスバーを表示する
"set laststatus=2
""検索結果をハイライトする
set hlsearch
""ハイライトをESC2回で消す
nmap <ESC><ESC> :nohlsearch<CR><ESC>
"" スペルチェック
"set spelllang+=cjk
set spell

" 行末のスペース削除
autocmd BufWritePre * :%s/\s\+$//ge

""""""""""""""""""""""""""""""
" 最後のカーソル位置を復元する
" """"""""""""""""""""""""""""""
if has("autocmd")
    autocmd BufReadPost *
    \ if line("'\"") > 0 && line ("'\"") <= line("$") |
    \   exe "normal! g'\"" |
    \ endif
endif
""""""""""""""""""""""""""""""

let g:neobundle_default_git_protocol='https'

if has('vim_starting')
   " 初回起動時のみruntimepathにneobundleのパスを指定する
   set runtimepath+=~/.vim/bundle/neobundle.vim/
endif

" NeoBundleを初期化
call neobundle#begin(expand('~/.vim/bundle/'))

" インストールするプラグインをここに記述
NeoBundle 'Shougo/unite.vim'
NeoBundle 'Shougo/vimfiler'
NeoBundle 'tyru/open-browser.vim'
"NeoBundle 'kannokanno/previm'
NeoBundle 'tukiyo/previm'
" for making ruby comfortale
"" completion
"NeoBundle 'marcus/rsense'
"" static code analysis
"NeoBundle 'scrooloose/syntastic'
"" reference
NeoBundle 'thinca/vim-ref'
NeoBundle 'yuku-t/vim-ref-ri'
"" Jump to definition of method
"" Not found below repository
"NeoBundle 'szw/vim-tags'
"" Ruby endwise
NeoBundle 'tpope/vim-endwise'
"NeoBundle 'plasticboy/vim-markdown'
"NeoBundle 'NigoroJr/rsense'
NeoBundle 'mattn/emmet-vim'
NeoBundle 'Shougo/unite.vim'
NeoBundle 'pangloss/vim-javascript'
"NeoBundle 'kakkyz81/evervim'
NeoBundle 'felixge/vim-nodejs-errorformat'
NeoBundle 'scrooloose/syntastic'
NeoBundle 'leafgarland/typescript-vim'
NeoBundle 'pangloss/vim-javascript'
NeoBundle 'Townk/vim-autoclose'

NeoBundleCheck

call neobundle#end()

filetype plugin indent on

autocmd BufRead,BufRead *.ts set filetype=typescript


"" filetype setting for Previm & open browser
augroup PrevimSettings
  autocmd!
  autocmd BufNewFile,BufRead <em>.{md,mdwn,mkd,mkdn,mark</em>} set filetype=markdown
augroup END


"" Previm
augroup PrevimSettings
	autocmd!
	autocmd BufNewFile,BufRead *.{md,mdwn,mkd,mkdn,mark*} set filetype=markdown
augroup END

"" Markdown
let g:vim_markdown_initial_foldlevel = 1

"タブ、空白、改行の可視化
set list
set listchars=tab:>.,trail:_,eol:↲,extends:>,precedes:<,nbsp:%

"全角スペースをハイライト表示
function! ZenkakuSpace()
    highlight ZenkakuSpace cterm=reverse ctermfg=DarkMagenta gui=reverse guifg=DarkMagenta
endfunction

if has('syntax')
    augroup ZenkakuSpace
        autocmd!
        autocmd ColorScheme       * call ZenkakuSpace()
        autocmd VimEnter,WinEnter * match ZenkakuSpace /　/
    augroup END
    call ZenkakuSpace()
endif


fun! s:SpellConf()
  redir! => syntax
  silent syntax
  redir END

  set spell

  if syntax =~? '/<comment\>'
    syntax spell default
    syntax match SpellNotAscii /\<\A\+\>/ contains=@NoSpell transparent containedin=Comment contained-
    syntax match SpellMaybeCode /\<\h\l*[_A-Z]\h\{-}\>/ contains=@NoSpell transparent containedin=Comment contained
  else
    syntax spell toplevel
    syntax match SpellNotAscii /\<\A\+\>/ contains=@NoSpell transparent
    syntax match SpellMaybeCode /\<\h\l*[_A-Z]\h\{-}\>/ contains=@NoSpell transparent
  endif

  syntax cluster Spell add=SpellNotAscii,SpellMaybeCode
endfunc

augroup spell_check
  autocmd!
  autocmd BufReadPost,BufNewFile,Syntax * call s:SpellConf()
augroup END

hi clear SpellBad
hi SpellBad cterm=underline,bold
set background=light
