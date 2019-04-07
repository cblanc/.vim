
execute pathogen#infect()
syntax on
set nocompatible
filetype plugin indent on

set number
set history=1000
set expandtab
set tabstop=2
set shiftwidth=2
set autoindent
set autoread
set ruler
set laststatus=2
set cursorline
set cursorcolumn
set winwidth=79
set cmdheight=2
set lazyredraw
set ttyfast
set nobackup
set nowritebackup
set showtabline=2
set incsearch
set hlsearch
set ignorecase smartcase
set wildmenu
set wildmode=longest,list
set foldcolumn=1
set encoding=utf8
set splitbelow
set splitright

" Use login shell (reads in .bash_profile)
set shell=/bin/bash\ -l

" Smart way to move between windows
map <C-j> <C-W>j
map <C-k> <C-W>k
map <C-h> <C-W>h
map <C-l> <C-W>l
map <C-i> <C-W>r
map <C-y> <C-W>R

" No annoying sound on errors
set noerrorbells
set novisualbell
set t_vb=
set tm=500

" Backspace everything
set backspace=indent,eol,start

" Colours
:set t_Co=256 " 256 colors
:set background=light
color PaperColor
" :color monokai

" MULTIPURPOSE TAB KEY
" Indent if we're at the beginning of a line. Else, do completion.
function! InsertTabWrapper()
    let col = col('.') - 1
    if !col || getline('.')[col - 1] !~ '\k'
        return "\<tab>"
    else
        return "\<c-p>"
    endif
endfunction
inoremap <expr> <tab> InsertTabWrapper()
inoremap <s-tab> <c-n>

" STATUS LINE
:set statusline=%<%f\ (%{&ft})\ %-4(%m%)%=%-19(%3l,%02c%03V%)

" vim-javascript
let g:javascript_plugin_jsdoc = 1 " Enables Syntax highlighting for JsDocs

" NerdTree
map <C-o> :NERDTreeToggle<CR>
let NERDTreeShowHidden=1
let NERDTreeIgnore = ['.DS_Store', '^.git$', '^node_modules$', '.nyc_output$', '.cache$', 'docs$', 'coverage$', 'dist$', '.capistrano$']
let NERDTreeMinimalUI = 1
let NERDTreeDirArrows = 1

" GitGutter
set updatetime=500

" CtrlP
let g:ctrlp_custom_ignore = 'node_modules/\|\.DS_Store\|\.git/\|\.?tmp/\|.nyc_output/\|.cache/\|dist/\|docs/\|coverage/'
let g:ctrlp_show_hidden = 1

" Use ag with ack.vim
let g:ackprg = 'ag --nogroup --nocolor --column'

" Config for VIM JsDoc
" https://github.com/heavenshell/vim-jsdoc
let g:jsdoc_enable_es6=1
let g:jsdoc_underscore_private=1
" Map jsdoc to ctrl-m
nmap <silent> <C-m> <Plug>(jsdoc)

" Creates a persistent undofile
set undofile
set undodir=~/.vim/undodir

map <Leader>r :! chrome-cli reload<CR><CR>

" Ale configuration
" Linter config
let g:ale_linters = {
\ 'javascript': ['prettier'],
\ 'typescript': ['tslint'],
\ 'json': ['prettier'],
\ 'css': ['prettier'],
\}

" Fixer config
let g:ale_fixers = {
\ 'javascript': ['prettier'],
\ 'typescript': ['prettier'],
\ 'json': ['prettier'],
\ 'css': ['prettier'],
\}
" Only run fixer on above configurations
let g:ale_fix_on_save = 1
let g:ale_lint_on_save = 1

"Attach lint information to airline
let g:airline#extensions#ale#enabled = 1

" Tsuquyomi (typescript completion) config
let g:tsuquyomi_completion_detail = 1
let g:tsuquyomi_definition_split = 1
set completeopt=longest,menuone
set omnifunc=tsuquyomi#complete
