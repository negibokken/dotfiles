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
"" [basic] wrap line
"" set wrap
"" [basic] show status bar
set laststatus=2
"" [basic] highlight search result
set hlsearch
"" [basic] encoding
set encoding=utf-8
set fileencoding=utf-8
set termencoding=utf-8
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
"" [basic] do not make .swp
set noswapfile
"" [basic] make special character visible
set list
set listchars=tab:..,trail:_,eol:↲,extends:>,precedes:<,nbsp:%
"" [basic] show menu in the bottom of vim
set wildmenu
set wildmode=full
"" [basic] show num of row & col
set ruler
set cursorline
"" [basic] color
set t_Co=256
"" [basic] disable mouse
set mouse=
"" [basic] enable to multi byte for formatting
set formatoptions+=mM
"" [basic] textwidth
set textwidth=80
"" [basic] reload when files are changed
set autoread
au CursorHold * checktim

""highlight CursorLine cterm=NONE ctermfg=white ctermbg=white
" [basic] no update yank register when push down x key
noremap PP "0p
noremap x  "_x
" [basic] conceallevel
set conceallevel=0 concealcursor=niv

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
""Plug 'xavierd/clang_complete'
""Plug 'dense-analysis/ale'
""Plug 'itchyny/lightline.vim'
Plug 'kana/vim-submode'
Plug 'jistr/vim-nerdtree-tabs'
""Plug 'rhysd/vim-clang-format'
Plug 'elzr/vim-json'
""Plug 'prettier/vim-prettier', {
""      \ 'do': 'yarn install',
""      \ 'for': ['javascript', 'typescript', 'css', 'less', 'scss', 'json', 'graphql', 'markdown', 'vue', 'yaml', 'html',]}
Plug 'mzlogin/vim-markdown-toc'
Plug 'previm/previm'
Plug 'nathanaelkane/vim-indent-guides'
Plug 'Shougo/neocomplcache'
Plug 'Shougo/neosnippet'
Plug 'Shougo/neosnippet-snippets'
Plug 'Shougo/vimproc.vim', { 'do' : 'make' }
Plug 'Shougo/unite.vim'
Plug 'Shougo/neomru.vim'
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'
Plug 'PhilRunninger/nerdtree-visual-selection'
Plug 'MattesGroeger/vim-bookmarks'
""Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }
Plug 'tpope/vim-surround'
Plug 'mattn/emmet-vim'
Plug 'previm/previm'
Plug 'easymotion/vim-easymotion'

""candidastes
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'prabirshrestha/asyncomplete.vim'
Plug 'prabirshrestha/asyncomplete-lsp.vim'
Plug 'prabirshrestha/vim-lsp'
Plug 'mattn/vim-lsp-settings'
Plug 'prabirshrestha/async.vim'
""Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'
Plug 'thomasfaingnaert/vim-lsp-snippets'
Plug 'thomasfaingnaert/vim-lsp-ultisnips'
Plug 'hrsh7th/vim-vsnip'
Plug 'hrsh7th/vim-vsnip-integ'
Plug 'morhetz/gruvbox'
Plug 'sheerun/vim-polyglot'
Plug 'bronson/vim-trailing-whitespace'
call plug#end()

" [plug-conf] 'rhysd/vim-clang-format'
let g:clang_format#auto_format = 1
let g:clang_format#code_style = 'google'

"" [plug-conf] xavierd/clang_complete
let g:clang_library_path='/usr/local/opt/llvm/lib'

"" [plug-conf] previm/previm
let g:previm_open_cmd = 'open -a Google\ Chrome'
let g:previm_enable_realtime = 1
let g:previm_disable_default_css = 1
let g:previm_custom_css_path = '~/dotfiles/vimconf/markdown.css'
nnoremap <C-m> <Nop>
nnoremap <silent> <C-m><C-o> :PrevimOpen<CR>

"" [plug-conf] elzr/vim-json JSON syntax
let g:vim_json_syntax_conceal = 0

"" [plug-conf] scrooloose/nerdtree
let NERDTreeShowHidden=1
let g:nerdtree_tabs_autoclose=0
let g:nerdtree_tabs_smart_startup_focus=2
augroup NERDTreeExec
  autocmd!
  filetype on
  autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
  autocmd VimEnter * wincmd l
  map <C-n> :NERDTreeTabsToggle<CR>
augroup END

"" [plug-config] 'dense-analysis/ale'
let g:ale_statusline_format = ['E%d', 'W%d', 'OK']
""let g:ale_linters = {'c':['clang'],'cpp':['clang'],'markdown':['prettier']}
""let g:ale_fixers = {
""\   'typescript': ['prettier'],
""\   'typescriptreact': ['prettier'],
""\   'javascript': ['prettier'],
""\   'javascriptreact': ['prettier'],
""\   'css': ['prettier'],
""\}
let g:ale_linters_explicit = 1
let g:ale_cpp_clang_executable='clang++'
""let g:ale_javascript_prettier_use_local_config = 1
""let g:ale_javascript_prettier_options = '--config ${HOME}/.prettierrc'
let g:ale_cpp_clang_options = '-std=c++14 -I/Users/bokken/blib/include'
let g:ale_c_clang_options='-I/Users/bokken/blib/include'
""let g:ale_fix_on_save = 1

"" [plug-conf] plasticboy/vim-markdown options
let g:vim_markdown_folding_disabled = 1

"" [plug-conf] nathanaelkane/vim-indent-guides
let g:indent_guides_enable_on_vim_startup = 1
let g:indent_guides_auto_colors = 0
autocmd VimEnter,Colorscheme * :hi IndentGuidesOdd  guibg=red   ctermbg=236
autocmd VimEnter,Colorscheme * :hi IndentGuidesEven guibg=green ctermbg=237

autocmd BufWritePre *.py,*.js,*.ts,*.rs,*.go LspDocumentFormatSync

"" [plug-conf] Shougo/neocomplcache
source ${HOME}/dotfiles/vimconf/neocomplcache_conf.vim

"" [plug-conf] Shougo/Unite.vim
source ${HOME}/dotfiles/vimconf/unite_conf.vim

"" [plug-conf] unite-grep
source ${HOME}/dotfiles/vimconf/quick_grep.vim

"" [conf] python
source ${HOME}/dotfiles/vimconf/ftplugin/python.vim

"" [plug-conf] 'tpope/vim-fugitive'
autocmd QuickFixCmdPost *grep* cwindow

" [plug-conf] 'MattesGroeger/vim-bookmarks'
highlight BookmarkSign ctermbg=NONE ctermfg=160
highlight BookmarkLine ctermbg=031 ctermfg=007
let g:bookmark_sign = '♥'
let g:bookmark_highlight_lines = 1

" [plug-conf] 'fatih/vim-go'
let g:go_highlight_functions = 1
let g:go_highlight_methods = 1
let g:go_highlight_structs = 1
let g:go_fmt_command = "goimports"
let g:go_imports_autosave = 1
let g:go_auto_type_info = 1

"" [plug-conf] easymotion/vim-easymotion
nmap s <Plug>(easymotion-overwin-f)
map <Leader> <Plug>(easymotion-prefix)
let g:EasyMotion_smartcase = 1

"" [plug-conf] 
let g:everforest_background = 'soft'
colorscheme gruvbox
highligh Normal ctermbg=none
highlight LineNr ctermfg=243 ""hi Visual cterm=NONE ctermbg=037 ctermfg=007 guibg=darkred guifg=white
hi CursorLine   cterm=NONE ctermbg=023 ctermfg=015 guibg=darkred guifg=white
hi CursorColumn cterm=NONE ctermbg=023 ctermfg=015 guibg=darkred guifg=white

"" [keymap] Delete highlight when press esc twice
nmap <C-j><C-j> :nohlsearch<CR><ESC>
nmap <Esc><Esc> :nohlsearch<CR><ESC>

"" [keymap] vim tab operation
"" nnoremap s <Nop>
nnoremap <C-w>s :<C-u>sp<CR>
nnoremap <C-w>v :<C-u>vs<CR>
nnoremap <C-w>n gt
nnoremap <C-w>p gT
nnoremap <C-w>t :<C-u>tabnew<CR>

"" [keymap] vim window resize
call submode#enter_with('bufmove', 'n', '', '<C-w>,', '<C-w>>')
call submode#enter_with('bufmove', 'n', '', '<C-w>.', '<C-w><')
call submode#enter_with('bufmove', 'n', '', '<C-w>+', '<C-w>+')
call submode#enter_with('bufmove', 'n', '', '<C-w>-', '<C-w>-')
call submode#map('bufmove', 'n', '', ',', '<C-w>>')
call submode#map('bufmove', 'n', '', '.', '<C-w><')
call submode#map('bufmove', 'n', '', '+', '<C-w>+')
call submode#map('bufmove', 'n', '', '-', '<C-w>-')

"" [keymap] ctrl+j to esc
inoremap <C-j> <esc>
nnoremap <C-j> <esc>
vnoremap <C-j> <esc>

nnoremap j gj
nnoremap k gk

"" [keymap] delete line Ctrl+d
inoremap <C-d> <esc>dd
nnoremap <C-d> dd

"" [keymap] vim grep
nnoremap <C-y> <Nop>
nnoremap <C-u> <Nop>
nnoremap <C-y> :cprevious<CR>
nnoremap <C-u> :cnext<CR>
nnoremap [Q :<C-u>cfirst<CR>
nnoremap ]Q :<C-u>clast<CR>

"" [keymap] fugitive keymap
source ${HOME}/dotfiles/vimconf/fugitive_keymap.vim

"" [keymap] reload all files
noremap <C-r><C-r>  :bufdo e!<CR>

"" [keymap] reload vimrc
nnoremap <Space>s :source $HOME/.vimrc<CR>

"" candidates
function! s:on_lsp_buffer_enabled() abort
  setlocal omnifunc=lsp#complete
  setlocal signcolumn=yes
  nmap <buffer> gd <plug>(lsp-peek-definition)
  nmap <buffer> <C-]> <plug>(lsp-definition)
  nmap <buffer> <f2> <plug>(lsp-rename)
  nmap <buffer> <Leader>d <plug>(lsp-type-definition)
  nmap <buffer> <Leader>r <plug>(lsp-peek-references)
  nmap <buffer> gi <plug>(lsp-peek-implementation)
  inoremap <expr> <cr> pumvisible() ? "\<c-y>\<cr>" : "\<cr>"
  nmap gt :tab LspDefinition<cr>
  nmap gs :sp<cr>:LspDefinition<cr>
  nmap <c-l> :rightbelow vertical LspDefinition<cr>
endfunction

augroup lsp_install
  au!
  autocmd User lsp_buffer_enabled call s:on_lsp_buffer_enabled()
augroup END
""command! LspDebug let lsp_log_verbose=1 | let lsp_log_file = expand('~/lsp.log')

let g:lsp_diagnostics_enabled = 0
let g:lsp_diagnostics_echo_cursor = 1
let g:asyncomplete_auto_popup = 1
let g:asyncomplete_auto_completeopt = 1
let g:asyncomplete_popup_delay = 50
let g:lsp_text_edit_enabled = 1
let g:lsp_auto_enable= 1
let g:lsp_highlight_references_delay = 50
let g:lsp_preview_float = 1
let g:lsp_diagnostics_float_cursor = 1
let g:lsp_settings_filetype_go = ['gopls', 'golangci-lint-langserver']

""let g:lsp_log_verbose = 1
""let g:lsp_log_file = expand('~/vim-lsp.log')
""call lsp#register_server({
""    \ 'name': 'clangd',
""    \ 'cmd': {server_info->['clangd']},
""    \ 'whitelist': ['c', 'cpp', 'objc', 'objcpp'],
""    \ })

" configuration
autocmd FileType typescript,go,cpp,ruby setlocal omnifunc=lsp#complete

let g:lsp_settings = {}
let g:lsp_settings['gopls'] = {
  \  'workspace_config': {
  \    'usePlaceholders': v:true,
  \    'analyses': {
  \      'fillstruct': v:true,
  \    },
  \  },
  \  'initialization_options': {
  \    'usePlaceholders': v:true,
  \    'analyses': {
  \      'fillstruct': v:true,
  \    },
  \  },
  \}
"" LSP settings for JavaScript
au User lsp_setup call lsp#register_server({
  \ 'name': 'javascript support using typescript-language-server',
  \ 'cmd': {server_info->[&shell, &shellcmdflag, 'typescript-language-server --stdio']},
  \ 'root_uri':{server_info->lsp#utils#path_to_uri(lsp#utils#find_nearest_parent_file_directory(lsp#utils#get_buffer_path(), 'package.json'))},
  \ 'whitelist': ['javascript', 'javascript.jsx', 'javascriptreact'],
  \ })

" For snippets
let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsJumpForwardTrigger="<tab>"
let g:UltiSnipsJumpBackwardTrigger="<s-tab>"
let g:UltiSnipsSnippetDirectories=[$HOME.'/dotfiles/vimconf/snippets']

set completeopt+=menuone

"" tab completion
inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
inoremap <expr> <cr>    pumvisible() ? asyncomplete#close_popup() : "\<cr>"

"" [plug-conf] junegunn/fzf
nnoremap <C-p> <Nop>
nnoremap <silent> <C-p> :Files<CR>
nnoremap <silent> <C-r> :LspReferences<CR>
"" <C-o> back to original place
nnoremap <C-d> <Nop>
nnoremap <silent> <C-d> :LspDefinition<CR>
nnoremap <silent> <C-i> :LspImplementation<CR>
nnoremap <silent> <C-a> :Ag<CR>
" [Buffers] Jump to the existing window if possible
let g:fzf_buffers_jump = 1
let g:fzf_action = {
  \ 'ctrl-s': 'tab split',
  \ 'ctrl-x': 'split',
  \ 'ctrl-v': 'vsplit' }

" If you want :UltiSnipsEdit to split your window.
let g:UltiSnipsEditSplit="vertical"

let g:rustfmt_autosave = 1

"" status line
set statusline=
set statusline+=%#PmenuSel#
set statusline+=%#LineNr#
set statusline+=%m
set statusline+=%=
set statusline+=%f
set statusline+=%#CursorColumn#
set statusline+=\ %y
set statusline+=\ %{&fileencoding?&fileencoding:&encoding}
set statusline+=\[%{&fileformat}\]
set statusline+=\ %3p%%
set statusline+=\ %3l:%3c
set statusline+=\ 
