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
set nocompatible
" カーソルを行頭、行末で止まらないようにする
set whichwrap=h,l,b,s,<,>,[,]
""検索をファイルの先頭へループしない
set nowrapscan
""常にステータスバーを表示する
set laststatus=2
""検索結果をハイライトする
set hlsearch
"" エンコード設定
set encoding=UTF-8
set fileencoding=UTF-8
set termencoding=UTF-8
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
set listchars=tab:..,trail:_,eol:↲,extends:>,precedes:<,nbsp:%

set spelllang+=en,cjk
" Spell check
" mark mistakes with  underline and bold
hi clear SpellBad
hi SpellBad cterm=underline,bold
set spell

" 80 文字を超えたらハイライトする
highlight turn gui=standout cterm=standout
autocmd BufRead *.rb,*.ts,*.js,*.py call matchadd("turn", '.\%>81v')

" spell check
function! s:SpellConf()
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

" 最後のカーソル位置を復元する
if has("autocmd")
    autocmd BufReadPost *
    \ if line("'\"") > 0 && line ("'\"") <= line("$") |
    \   exe "normal! g'\"" |
    \ endif
endif

" プラグインの設定
filetype off

if has('vim_starting')
  set runtimepath+=~/.vim/bundle/neobundle.vim
endif

filetype plugin on

call neobundle#begin(expand('~/.vim/bundle/'))
  NeoBundleFetch 'Shougo/neobundle.vim'
  NeoBundle 'Shougo/neocomplcache'
  NeoBundle 'Shougo/neosnippet'
  NeoBundle 'Shougo/neosnippet-snippets'
  NeoBundle 'jpalardy/vim-slime'
  NeoBundle 'tpope/vim-endwise'
  NeoBundle 'nathanaelkane/vim-indent-guides'
  NeoBundle 'tukiyo/previm'
  NeoBundle 'mattn/emmet-vim'
  NeoBundle 'simeji/winresizer'
  NeoBundle 'leafgarland/typescript-vim'
  NeoBundle 'jelera/vim-javascript-syntax'
  NeoBundle 'thinca/vim-ref'
  NeoBundle 'tokuhirom/jsref'
  NeoBundle 'mojako/ref-sources.vim'
  NeoBundle 'othree/yajs.vim'
  NeoBundle 'othree/html5.vim'
  NeoBundle 'mxw/vim-jsx'
  NeoBundle 'neomake/neomake'
  NeoBundle 'fatih/vim-go'
  NeoBundle 'vim-jp/vim-go-extra'
  NeoBundle 'nsf/gocode', {'rtp': 'vim/'}
  NeoBundle 'itchyny/lightline.vim'
  NeoBundle 'majutsushi/tagbar'
  NeoBundle 'kana/vim-submode'
  NeoBundle 'scrooloose/nerdtree'
  NeoBundle 'jistr/vim-nerdtree-tabs'
  NeoBundle 'elzr/vim-json'
  NeoBundle 'Shougo/unite.vim'
  NeoBundleCheck "未インストールのプラグインの確認
call neobundle#end()

" previm setting
let g:previm_open_cmd = 'open -a Google\ Chrome'
let g:previm_enable_realtime = 1

" JSON syntax
let g:vim_json_syntax_conceal = 0

" vim-jsx用の設定
let g:jsx_ext_required = 1        " ファイルタイプがjsxのとき読み込む．
let g:jsx_pragma_required = 0     " @から始まるプラグマでは読み込まない．

augroup Vimrc
  autocmd!
  autocmd BufNewFile,BufRead *.jsx set filetype=javascript.jsx
augroup END

" set NERD TREE
let g:nerdtree_tabs_autoclose=1
let g:nerdtree_tabs_smart_startup_focus=2
augroup NERDTreeExec
  autocmd!
  filetype on
  autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
  autocmd VimEnter * wincmd l
augroup END
map <C-n> :NERDTreeTabsToggle<CR>

" configure status bar
let g:lightline = {
      \ 'colorscheme': 'seoul256',
      \ }

filetype plugin indent on     " required!
filetype indent on
syntax on

" Eslint 設定
" 保存時に実行する
autocmd! BufWritePost * Neomake
let g:neomake_javascript_enabled_makers = ['eslint']
let g:neomake_ruby_enabled_makers = ['rubocop']
let g:neomake_error_sign = {'text': '>>', 'texthl': 'Error'}
let g:neomake_warning_sign = {'text': '>>',  'texthl': 'Todo'}

" Cancel JSON syntax
set conceallevel=0
let g:vim_json_syntax_conceal = 0

" tag bar toggle setting
nmap tt :TagbarToggle<CR>

" TypeScript
autocmd BufRead,BufNewFile *.ts set filetype=typescript

" golang configure
let g:go_hightlight_functions = 1
let g:go_hightlight_methods = 1
let g:go_hightlight_structs = 1
let g:go_hightlight_interfaces = 1
let g:go_hightlight_operators = 1
let g:go_hightlight_build_constraints = 1
let g:go_fmt_command = "goimports"

let g:go_bin_path = expand("~/.go/bin")
set rtp+=$GOROOT/misc/vim

filetype plugin indent on

"" plasticboy/vim-markdown options
let g:vim_markdown_folding_disabled = 1

" md as markdown, instead of modula2
autocmd BufNewFile,BufRead *.{md,mdwn,mkd,mkdn,mark*} set filetype=markdown

" set color scheme as vim-hybrid
syntax on
colorscheme hybrid
set background=dark
"let g:hybrid_custom_term_colors = 1
highligh Normal ctermbg=none
highlight LineNr ctermfg=243

" html のタグ補完
augroup MyXML
  autocmd!
  autocmd Filetype xml inoremap <buffer> </ </<C-x><C-o>
  autocmd Filetype html inoremap <buffer> </ </<C-x><C-o>
augroup END

" simeji/winresizer の設定
let g:winresizer_horiz_resize = 1
let g:winresizer_vert_resize = 5

" Neocomplecache
" Disable AutoComplPop.
let g:acp_enableAtStartup = 0
" Use neocomplcache.
let g:neocomplcache_enable_at_startup = 1
" Use smartcase.
let g:neocomplcache_enable_smart_case = 1
" Set minimum syntax keyword length.
let g:neocomplcache_min_syntax_length = 3
let g:neocomplcache_lock_buffer_name_pattern = '\*ku\*'

" Define dictionary.
let g:neocomplcache_dictionary_filetype_lists = {
    \ 'default' : ''
    \ }

" Plugin key-mappings.
inoremap <expr><C-g>     neocomplcache#undo_completion()
inoremap <expr><C-l>     neocomplcache#complete_common_string()

" Recommended key-mappings.
" <CR>: close popup and save indent.
inoremap <silent> <CR> <C-r>=<SID>my_cr_function()<CR>
function! s:my_cr_function()
  return neocomplcache#smart_close_popup() . "\<CR>"
endfunction
" <TAB>: completion.
inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"
inoremap <expr><S-TAB>  pumvisible() ? "\<C-p>" : "\<S-TAB>"
" <C-h>, <BS>: close popup and delete backword char.
inoremap <expr><C-h> neocomplcache#smart_close_popup()."\<C-h>"
inoremap <expr><BS> neocomplcache#smart_close_popup()."\<C-h>"
inoremap <expr><C-y>  neocomplcache#close_popup()
inoremap <expr><C-e>  neocomplcache#cancel_popup()  " Configuration for neosnippet
" Plugin key-mappings.
imap <C-k>     <Plug>(neosnippet_expand_or_jump)
smap <C-k>     <Plug>(neosnippet_expand_or_jump)
xmap <C-k>     <Plug>(neosnippet_expand_target)

" Original snippets directory
let g:neosnippet#snippets_directory='~/dotfiles/.vim/snippets/'
" SuperTab like snippets behavior.  "imap <expr><TAB>
" \ pumvisible() ? "\<C-n>" :
" \ neosnippet#expandable_or_jumpable() ?
" \    "\<Plug>(neosnippet_expand_or_jump)" : "\<TAB>"
smap <expr><TAB> neosnippet#expandable_or_jumpable() ?
\ "\<Plug>(neosnippet_expand_or_jump)" : "\<TAB>"

" For conceal markers.
if has('conceal')
  set conceallevel=2 concealcursor=niv
endif
"
" Tern Configure
let g:tern_show_argument_hints='on_hold'
" and
let g:tern_map_keys=1

" vim-indent-guides
" colorscheme default
let g:indent_guides_enable_on_vim_startup = 1
let g:indent_guides_auto_colors = 0
autocmd VimEnter,Colorscheme * :hi IndentGuidesOdd  guibg=red   ctermbg=236
autocmd VimEnter,Colorscheme * :hi IndentGuidesEven guibg=green ctermbg=237

" Indent with 2 spaces
autocmd filetype coffee,javascript setlocal shiftwidth=2 softtabstop=2 tabstop=2 expandtab

" JunkFile
" Open junk file."{{{
command! -nargs=0 JunkFile call s:open_junk_file()
function! s:open_junk_file()
  let l:junk_dir = $HOME . '/.vim_junk'. strftime('')
  if !isdirectory(l:junk_dir)
    call mkdir(l:junk_dir, 'p')
  endif

  let l:filename = input('Junk Code: ', l:junk_dir.strftime('/%Y-%m-%d-%H%M%S.md'))
  if l:filename != ''
    execute 'edit ' . l:filename
  endif
endfunction"}}}

" keymap setting
" ハイライトを ESC 2回で消す
nmap <ESC><ESC> :nohlsearch<CR><ESC>

" vim tab
nnoremap s <Nop>
nnoremap ss :<C-u>sp<CR>
nnoremap sv :<C-u>vs<CR>
nnoremap sj <C-w>j
nnoremap sk <C-w>k
nnoremap sl <C-w>l
nnoremap sh <C-w>h
nnoremap sq :<C-u>q<CR>
nnoremap sQ :<C-u>bd<CR>
nnoremap sn gt
nnoremap sp gT
nnoremap st :<C-u>tabnew<CR>

" vim window resize easily
call submode#enter_with('bufmove', 'n', '', 's>', '<C-w>>')
call submode#enter_with('bufmove', 'n', '', 's<', '<C-w><')
call submode#enter_with('bufmove', 'n', '', 's+', '<C-w>+')
call submode#enter_with('bufmove', 'n', '', 's-', '<C-w>-')
call submode#map('bufmove', 'n', '', '>', '<C-w>>')
call submode#map('bufmove', 'n', '', '<', '<C-w><')
call submode#map('bufmove', 'n', '', '+', '<C-w>+')
call submode#map('bufmove', 'n', '', '-', '<C-w>-')

" ESC to Ctrl+J
inoremap <C-j> <esc>
nnoremap <C-j> <esc>
vnoremap <C-j> <esc>

" delete line Ctrl+d
inoremap <C-d> <esc>dd
nnoremap <C-d> dd

" Move faster
nnoremap <C-f> jjj
vnoremap <C-f> jjj
nnoremap <C-b> kkk
vnoremap <C-b> kkk

" vim grep
nnoremap [q :cprevious<CR>
nnoremap ]q :cnext<CR>
nnoremap [Q :<C-u>cfirst<CR>
nnoremap ]Q :<C-u>clast<CR>

" hook quick fixcmd
autocmd QuickFixCmdPost *grep* cwindow
