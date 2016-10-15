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
""行頭の余白内で Tab を打ち込むと、'shiftwidth' の数だけインデントする。
set smarttab
"ファイル内の <Tab> が対応する空白の数
set tabstop=2
" プラグインの有効化
set nocompatible               " be iMproved
" カーソルを行頭、行末で止まらないようにする
set whichwrap=h,l,b,s,<,>,[,]
""検索をファイルの先頭へループしない
set nowrapscan
""常にステータスバーを表示する
"set laststatus=2
""検索結果をハイライトする
set hlsearch
""ハイライトをESC2回で消す
nmap <ESC><ESC> :nohlsearch<CR><ESC>
""コマンドラインモードで<Tab>でファイル名補完
set wildmenu
""ウィンドウのタイトルバーにファイルのパス情報等を表示する
set title
"" ペーストするときにインデントサせないようにする
"set paste
"" ヤンクしたらクリップボードへコピー
set clipboard=unnamed,autoselect
"set clipboard=unnamedplus
"" バックスペースで削除
set backspace=indent,eol,start
" スワップを作らない
set nobackup
" 可視化
set list
set listchars=tab:>.,trail:_,eol:↲,extends:>,precedes:<,nbsp:%

" 保存時に行末の空白を自動で削除
autocmd BufWritePre * :%s/\s\+$//ge

" x キーでヤンクレジスタ更新しない
noremap PP "0p
noremap x  "_x

" title 変更
set title
" vim からファイルを開くときにリストを表示する
set wildmenu
set wildmode=full
" 行番号と列番号を表示する
set ruler



""""""""""""""""""""""""""""""
" 最後のカーソル位置を復元する
"""""""""""""""""""""""""""""""
 if has("autocmd")
    autocmd BufReadPost *
    \ if line("'\"") > 0 && line ("'\"") <= line("$") |
    \   exe "normal! g'\"" |
    \ endif
endif
""""""""""""""""""""""""""""""



""""""""""""""""""""""""""""""
" 自動的に閉じ括弧を入力
""""""""""""""""""""""""""""""
" imap { {}<LEFT>
" imap [ []<LEFT>
" imap ( ()<LEFT>
""""""""""""""""""""""""""""""

"" Previmの設定
augroup PrevimSettings
    autocmd!
    autocmd BufNewFile,BufRead <em>.{md,mdwn,mkd,mkdn,mark</em>} set filetype=markdown
augroup END


"" プラグインの設定
filetype off

if has('vim_starting')
  set runtimepath+=~/.vim/bundle/neobundle.vim
endif

call neobundle#begin(expand('~/.vim/bundle/'))
  NeoBundleFetch 'Shougo/neobundle.vim'
  " originalrepos on github
  "NeoBundle 'Shougo/neobundle.vim'
  NeoBundle 'Shougo/vimproc'
  NeoBundle 'VimClojure'
  NeoBundle 'Shougo/vimshell'
  NeoBundle 'Shougo/unite.vim'
  "NeoBundle 'Shougo/neocomplcache'
  "NeoBundle 'Shougo/neosnippet'
  "NeoBundle 'Shougo/neosnippet.vim'
  "NeoBundle 'Shougo/neosnippet-snippets'
  "NeoBundle 'Shougo/neocomplete.vim'
  NeoBundle 'jpalardy/vim-slime'
  "NeoBundle 'scrooloose/syntastic'
  NeoBundle 'tpope/vim-endwise'
  " インデントに色を付けて見やすくする
  NeoBundle 'nathanaelkane/vim-indent-guides'
  ""NeoBundle 'https://bitbucket.org/kovisoft/slimv'
  NeoBundle 'tyru/open-browser.vim'
  "NeoBundle 'kannokanno/previm'
  NeoBundle 'tukiyo/previm'
  "NeoBundle 'plasticboy/vim-markdown'
  NeoBundle 'mattn/emmet-vim'
  "NeoBundle 'kakkyz81/evervim'
  NeoBundle 'jpo/vim-railscasts-theme'
  NeoBundle 'simeji/winresizer'
"  NeoBundle 'scrooloose/syntastic'
  NeoBundle 'leafgarland/typescript-vim'
  NeoBundle 'pangloss/vim-javascript'
  NeoBundle 'Townk/vim-autoclose'
call neobundle#end()

filetype plugin indent on     " required!
filetype indent on
syntax on

" TypeScript
autocmd BufRead,BufNewFile *.ts set filetype=typescript

"" Open junk file."{{{
"command! -nargs=0 JunkFile call s:open_junk_file()
"function! s:open_junk_file()
"  let l:junk_dir = $HOME . '/.vim_junk'. strftime('/%Y/%m')
"  if !isdirectory(l:junk_dir)
"    call mkdir(l:junk_dir, 'p')
"  endif
"
"  if l:filename != ''
"    execute 'edit ' . l:filename
"  endif
"endfunction"}}}
"
"
" let l:filename = input('Junk Code: ', l:junk_dir.strftime('/%Y-%m-%d-%H%M%S.'))

filetype plugin indent on
NeoBundleCheck "未インストールのプラグインの確認

""""""""""""""""""""""""""
" markdown
 "let g:vim_markdown_initial_foldlevel=


" Shortcut
"nnoremap <Leader>l :EvervimNotebookList<CR>
"nnoremap <Leader>s :EvervimSearchByQuery<Space>
"nnoremap <Leader>c :EvervimCreateNote<CR>
"nnoremap <Leader>t :EvervimListTags<CR>



"" Previm no focus on browser
"nnoremap <silent> :PrevimOpen \|:Silent open -a it2_f &<CR>


"" plasticboy/vim-markdown options
let g:vim_markdown_folding_disabled = 1

" md as markdown, instead of modula2
autocmd BufNewFile,BufRead *.{md,mdwn,mkd,mkdn,mark*} set filetype=markdown

" set color scheme as vim-hybrid
" colorscheme RailsCasts


" neocomplete settinghlight Pmenu ctermbg=4
"highlight PmenuSel ctermbg=1
"highlight PMenuSbar ctermbg=4

" 補完ウィンドウの設定
"set completeopt=menuone

" 補完ウィンドウの設定
"set completeopt=menuone

" rsenseでの自動補完機能を有効化
"let g:rsenseUseOmniFunc = 1
" let g:rsenseHome = '/usr/local/lib/rsense-0.3'

" auto-ctagsを使ってファイル保存時にtagsファイルを更新
"let g:auto_ctags = 1

" 起動時に有効化
"let g:neocomplcache_enable_at_startup = 1

" 大文字が入力されるまで大文字小文字の区別を無視する
"let g:neocomplcache_enable_smart_case = 1
"
"" _(アンダースコア)区切りの補完を有効化
"let g:neocomplcache_enable_underbar_completion = 1
"
"let g:neocomplcache_enable_camel_case_completion  =  1
"
"" 最初の補完候補を選択状態にする
"let g:neocomplcache_enable_auto_select = 1
"
"" ポップアップメニューで表示される候補の数
"let g:neocomplcache_max_list = 20
"
"" シンタックスをキャッシュするときの最小文字長
"let g:neocomplcache_min_syntax_length = 3
"
"" 補完の設定
"autocmd FileType ruby setlocal omnifunc=rubycomplete#Complete
"if !exists('g:neocomplete#force_omni_input_patterns')
"  let g:neocomplete#force_omni_input_patterns = {}
"endif
"let g:neocomplete#force_omni_input_patterns.ruby = '[^.*\t]\.\w*\|\h\w*::'
"
"if !exists('g:neocomplete#keyword_patterns')
"        let g:neocomplete#keyword_patterns = {}
"endif
"let g:neocomplete#keyword_patterns['default'] = '\h\w*'
"


" html のタグ補完
augroup MyXML
  autocmd!
  autocmd Filetype xml inoremap <buffer> </ </<C-x><C-o>
  autocmd Filetype html inoremap <buffer> </ </<C-x><C-o>
augroup END

" simeji/winresizer の設定
let g:winresizer_horiz_resize = 1
let g:winresizer_vert_resize = 5


" rubocop 用セッティング
"let g:syntastic_mode_map = { 'mode': 'passive', 'active_filetypes': ['ruby'] }
"let g:syntastic_ruby_checkers = ['rubocop']


