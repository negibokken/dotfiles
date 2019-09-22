"" [basic] set English
set langmenu=en_US.UTF-8
let $LANG="en"
"" [basic] auto indent
set autoindent
"" [basic] use space instead of tab
set expandtab
"" [basic] incremental search
set incsearch
"" [basic] show line number
set number
"" [basic] define tab shift width
set shiftwidth=2
"" [basic] highlight bracket when another respondent bracket
set showmatch
"" [basic] ignore case
set ignorecase
"" [basic] smart case (when using capital character then ignore non capital character)
set smartcase
"" [basic] use smart indent
set smartindent
"" [basic] indent property when press tab on in the head of line
set smarttab
"" [basic] space num for tab
set tabstop=2
"" [basic] off vi compatible
set nocompatible
"" [basic] wrap line
set whichwrap=h,l,b,s,<,>,[,]
"" [basic] no return head of the file when searching
set nowrapscan
"" [basic] show status bar
set laststatus=2
"" [basic] highlight search result
set hlsearch
"" [basic] encoding
set encoding=UTF-8
set fileencoding=UTF-8
set termencoding=UTF-8
"" [basic] complete file name in command line mode
set wildmenu
"" [basic] show title and path inforomation
set title
"" [basic] copy to clipboard when yank
set clipboard=unnamed,autoselect
"" [basic] enable backspace
set backspace=indent,eol,start
"" [basic] do not make .swp
set nobackup
"" [basic] make special character visible
set list
set listchars=tab:..,trail:_,eol:↲,extends:>,precedes:<,nbsp:%
"" [basic] show menu in the bottom of vim
set wildmenu
set wildmode=full
"" [basic] show num of row & col
set ruler
" [basic] no update yank register when push down x key
noremap PP "0p
noremap x  "_x
" [basic] conceallevel
set conceallevel=2 concealcursor=niv

"" [conf] spell check
source ${HOME}/dotfiles/vimconf/spell_check.vim
"" [conf] restore_cursor
source ${HOME}/dotfiles/vimconf/restore_cursor.vim
"" [conf] auto complete when enter '(', '[', '{', '\'', '"'
source ${HOME}/dotfiles/vimconf/auto_bracket.vim
"" [conf] delete last space per line
source ${HOME}/dotfiles/vimconf/trim_space.vim
"" [conf] spell check
source ${HOME}/dotfiles/vimconf/spell_check.vim
"" [conf] set filetype
source ${HOME}/dotfiles/vimconf/set_filetype.vim
"" [conf] color-scheme
source ${HOME}/dotfiles/vimconf/color_scheme.vim
"" [conf] complete html end tag when enter </
source ${HOME}/dotfiles/vimconf/complete_html_tag.vim

"" [conf] Indent with 2 spaces
autocmd filetype coffee,javascript setlocal shiftwidth=2 softtabstop=2 tabstop=2 expandtab


"" [command] Junkfile
source ${HOME}/dotfiles/vimconf/junk_file.vim


"" [plug] vim-plag
filetype plugin on
call plug#begin('~/.vim/plugged')
Plug 'scrooloose/nerdtree'
Plug 'xavierd/clang_complete'
Plug 'neomake/neomake'
Plug 'itchyny/lightline.vim'
Plug 'kana/vim-submode'
Plug 'jistr/vim-nerdtree-tabs'
Plug 'rhysd/vim-clang-format'
Plug 'elzr/vim-json'
Plug 'prettier/vim-prettier', {
      \ 'do': 'yarn install',
      \ 'for': ['javascript', 'typescript', 'css', 'less',
      \ 'scss', 'json', 'graphql', 'vue'] }
Plug 'mzlogin/vim-markdown-toc'
Plug 'previm/previm'
Plug 'nathanaelkane/vim-indent-guides'
call plug#end()


"" [plug-conf] previm/previm
let g:previm_open_cmd = 'open -a Google\ Chrome'
let g:previm_enable_realtime = 1
let g:previm_disable_default_css = 1
let g:previm_custom_css_path = '~/dotfiles/vimconf/markdown.css'

"" [plug-conf] elzr/vim-json JSON syntax
let g:vim_json_syntax_conceal = 0

"" [plug-conf] itchny/lightline
let g:lightline = { 'colorscheme': 'seoul256' }

"" [plug-conf] scrooloose/nerdtree
let g:nerdtree_tabs_autoclose=0
let g:nerdtree_tabs_smart_startup_focus=2
augroup NERDTreeExec
  autocmd!
  filetype on
  autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
  autocmd VimEnter * wincmd l
  map <C-n> :NERDTreeTabsToggle<CR>
augroup END

"" [plug-conf] neomake/neomake eslint on save
augroup Eslint
  autocmd! BufWritePost * Neomake
  let g:neomake_javascript_enabled_makers = ['eslint']
  let g:neomake_ruby_enabled_makers = ['rubocop']
  let g:neomake_error_sign = {'text': '>>', 'texthl': 'Error'}
  let g:neomake_warning_sign = {'text': '>>',  'texthl': 'Todo'}
augroup END
"" [plug-conf] neomake/neomake clang formatting
augroup Clang
  let g:clang_format#style_options = {
    \ "AccessModifierOffset" : -4,
    \ "AllowShortIfStatementsOnASingleLine" : "true",
    \ "AlwaysBreakTemplateDeclarations" : "true",
    \ "Standard" : "C++11",
    \ "BreakBeforeBraces" : "Stroustrup" }
  let g:clang_format#code_style = "google"
  let g:clang_format#auto_format = 1
  let g:neomake_cpp_enable_makers = ['clang']
  let g:neomake_cpp_clang_maker = { 'args': ['-std=c++14'] }
augroup END

"" [plug-conf] elzr/vim-json
let g:vim_json_syntax_conceal = 0

"" [plug-conf] plasticboy/vim-markdown options
let g:vim_markdown_folding_disabled = 1


"" [plug-conf] nathanaelkane/vim-indent-guides
let g:indent_guides_enable_on_vim_startup = 1
let g:indent_guides_auto_colors = 0
autocmd VimEnter,Colorscheme * :hi IndentGuidesOdd  guibg=red   ctermbg=236
autocmd VimEnter,Colorscheme * :hi IndentGuidesEven guibg=green ctermbg=237

"" [plug-conf] prettier/vim-prettier vim prettier setting
autocmd BufWritePre *.js,*.jsx,*.mjs,*.ts,*.tsx,*.css,*.less,*.scss,*.json,*.graphql,*.vue PrettierAsync"
let g:prettier#autoformat = 1
let g:prettier#config#print_width =  80
let g:prettier#config#single_quote = 1
let g:prettier#config#single_quote = 'true'
let g:prettier#config#trailing_comma = 'all'
let g:prettier#config#prose_wrap = 'preserve'



"" [keymap] Delete highlight when press esc twice
nmap <ESC><ESC> :nohlsearch<CR><ESC>

"" [keymap] vim tab operation
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

"" [keymap] vim window resize
call submode#enter_with('bufmove', 'n', '', 's>', '<C-w>>')
call submode#enter_with('bufmove', 'n', '', 's<', '<C-w><')
call submode#enter_with('bufmove', 'n', '', 's+', '<C-w>+')
call submode#enter_with('bufmove', 'n', '', 's-', '<C-w>-')
call submode#map('bufmove', 'n', '', '>', '<C-w>>')
call submode#map('bufmove', 'n', '', '<', '<C-w><')
call submode#map('bufmove', 'n', '', '+', '<C-w>+')
call submode#map('bufmove', 'n', '', '-', '<C-w>-')

"" [keymap] ctrl+j to esc
inoremap <C-j> <esc>
nnoremap <C-j> <esc>
vnoremap <C-j> <esc>

" delete line Ctrl+d
inoremap <C-d> <esc>dd
nnoremap <C-d> dd

" vim grep
nnoremap [q :cprevious<CR>
nnoremap ]q :cnext<CR>
nnoremap [Q :<C-u>cfirst<CR>
nnoremap ]Q :<C-u>clast<CR>

" Ctags
"nnoremap <C-]> <C-]>
"nnoremap <C-[> <C-t>

" hook quick fixcmd
" autocmd QuickFixCmdPost *grep* cwindow

" Clang format setting
" function! Formatonsave()
"   let l:formatdiff = 1
"   :py3f /usr/local/Cellar/clang-format/2018-04-24/share/clang/clang-format.py
" endfunction
" autocmd BufWritePre *.c,*.h,*.cc,*.cpp call Formatonsave()


"" 'Shougo/neocomplete.vim' {{{
"let g:neocomplete#enable_at_startup = 1
"if !exists('g:neocomplete#force_omni_input_patterns')
"        let g:neocomplete#force_omni_input_patterns = {}
"endif
"let g:neocomplete#force_overwrite_completefunc = 1
"let g:neocomplete#force_omni_input_patterns.c = '[^.[:digit:] *\t]\%(\.\|->\)'
"let g:neocomplete#force_omni_input_patterns.cpp = '[^.[:digit:] *\t]\%(\.\|->\)\|\h\w*::'
""""}}}
"
"" 'justmao945/vim-clang' {{{
"
"" disable auto completion for vim-clanG
"let g:clang_auto = 0
"let g:clang_complete_auto = 0
"let g:clang_auto_select = 0
"let g:clang_use_library = 1
"
"" default 'longest' can not work with neocomplete
"let g:clang_c_completeopt   = 'menuone'
"let g:clang_cpp_completeopt = 'menuone'
"
"if executable('clang-3.6')
"    let g:clang_exec = 'clang-3.6'
"elseif executable('clang-3.5')
"    let g:clang_exec = 'clang-3.5'
"elseif executable('clang-3.4')
"    let g:clang_exec = 'clang-3.4'
"else
"    let g:clang_exec = 'clang'
"endif
"
"let g:clang_c_options = '-std=c11'
"let g:clang_cpp_options = '-std=c++11 -stdlib=libc++'
"
"" }}}

