call plug#begin('~/.vim/plugins')

"==========================================
"Common Plugins
"==========================================

Plug 'lokaltog/vim-distinguished'
Plug 'easymotion/vim-easymotion'
Plug 'haya14busa/incsearch.vim'
Plug 'haya14busa/incsearch-easymotion.vim'
Plug 'haya14busa/incsearch-fuzzy.vim'
Plug 'airblade/vim-gitgutter'
Plug 'tpope/vim-repeat'
Plug 'mileszs/ack.vim'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-commentary'
Plug 'PeterRincker/vim-argumentative'
Plug 'Raimondi/delimitMate'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'vim-syntastic/syntastic'
Plug 'Chiel92/vim-autoformat'

"==========================================
"Typescript Plugins
"==========================================
Plug 'pangloss/vim-javascript'
Plug 'ternjs/tern_for_vim'
Plug 'vim-scripts/AutoComplPop'
Plug 'quramy/tsuquyomi'
"vv dependency for tsuquyomi 
Plug 'shougo/vimproc.vim', {'build': 'make'}
Plug 'alessioalex/syntastic-local-tslint.vim'
Plug 'helino/vim-json'
Plug 'leafgarland/typescript-vim'
"daemonize tslint process - works like 
"eslint_d
Plug 'quramy/syntastic-node-daemon'
call plug#end()

"==========================================
"Common Config
"==========================================

syntax on
colorscheme distinguished

"close all open windows\buffers when we quit, since we use screen 
"windows more than vim windows in this setup
cnoreabbrev q qa

"use fuzzy searching with easymotion for a killer one-two navigation punch
function! s:config_easyfuzzymotion(...) abort
   return extend(copy({
     \   'converters': [incsearch#config#fuzzyword#converter()],
     \   'modules': [incsearch#config#easymotion#module({'overwin': 1})],
     \   'keymap': {"\<CR>": '<Over>(easymotion)'},
     \   'is_expr': 0,
     \   'is_stay': 1
     \ }), get(a:, 1, {}))
endfunction

noremap <silent><expr> / incsearch#go(<SID>config_easyfuzzymotion())

"don't keep the text highlighted after using fuzzy search to navigate
set hls!

"for moving between hunks of modified code (via vim-gitgutter)
nmap ) <Plug>GitGutterNextHunk
nmap ( <Plug>GitGutterPrevHunk

if executable('ag')
   let g:ackprg = 'ag --vimgrep'
endif

"tell ctrl-p not to search through files in .gitignore
let g:ctrlp_user_command = ['.git/', 'git --git-dir=%s/.git ls-files -oc --exclude-standard']

"alias :a to :Ack! (use '!' so we don't jump to the first result when searching)
cnoreabbrev a Ack!

"sensible defaults for syntastic type checking
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1

"make sure we display errors from both the compiler and the linter
let g:syntastic_aggregate_errors = 1

"use H and L to move between loclist locations 
"(this is useful for e.g. eslint errors)
noremap L :lne<cr>
noremap H :lp<cr>

"I mapped ctrl-P to toggle my windows in screen :O. need to use something else 
"for quick find. 
let g:ctrlp_map = '<c-f>'

"auto-formatting
noremap F :Autoformat<CR>

"code completion
filetype plugin on
set omnifunc=syntaxcomplete#Complete

"indentation - two spaces (per eslint)
:set tabstop=4
:set expandtab 
:set shiftwidth=4
:set autoindent
:set smartindent

"==========================================
"Typescript Config
"==========================================

"couple 'a Tsuquyomi aliases
cnoreabbrev ti TsuImport

"tsuquyomi opts (Typescript compilation)
let g:tsuquyomi_disable_quickfix = 1

"enable Typescript linting with tslint, and 
"compilation with tsuquyomi.
"We need to use syntastic-local-tslint (listed above) so that 
"tslint looks like a global program to syntastic 
"(even though we've only installed it locally 
"via yarn)
"From Syntastic's github: 
"
""The most likely reason is that none of the syntax checkers that it requires
"are installed. For example: by default, python requires either flake8 or
"pylint to be installed and in your $PATH. Read the manual (:help
"syntastic-checkers in Vim) to find out what executables are supported. Note
"that aliases do not work; the actual executables must be available in your
"$PATH. Symbolic links are okay though. You can see syntastic's idea of
"available checkers by running :SyntasticInfo.)"
let g:syntastic_typescript_checkers = ['tsuquyomi', 'tslint']
