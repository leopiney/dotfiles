set nocompatible              " required
filetype off                  " required

"
"
" Plugins
"
"
"

call plug#begin('~/.vim/plugged')

" Utils
Plug 'tmhedberg/simpylfold'
Plug 'scrooloose/nerdtree'
Plug 'shougo/vimshell.vim'

Plug '/usr/local/opt/fzf'
Plug 'junegunn/fzf.vim'

Plug 'w0rp/ale'

" Python
Plug 'skywind3000/asyncrun.vim'
Plug 'nvie/vim-flake8'
Plug 'davidhalter/jedi-vim'

" React
Plug 'pangloss/vim-javascript'
Plug 'mxw/vim-jsx'
Plug 'mattn/emmet-vim'

" Haskell and Idris
Plug 'eagletmt/ghcmod-vim'
Plug 'eagletmt/neco-ghc'
Plug 'shougo/vimproc.vim'
Plug 'idris-hackers/idris-vim'

" Themes & Customization
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'jnurmine/Zenburn'
Plug 'altercation/vim-colors-solarized'
Plug 'NLKNguyen/papercolor-theme'

" Initialize plugin system
call plug#end()


" 
"
"
" Base configurations
"
"
"

filetype plugin indent on    " required
set encoding=utf-8
syntax on
set backspace=indent,eol,start

" Fuzzy search
let g:fzf_action = {
      \ 'ctrl-s': 'split',
      \ 'ctrl-v': 'vsplit'
      \ }
nnoremap <c-p> :FZF<cr>

" Split layouts
set splitbelow
set splitright

" Split navigations
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

" Enable folding
set foldmethod=indent
set foldlevel=99

let g:SimpylFold_docstring_preview=1

" Enable folding with the spacebar
nnoremap <space> za

" Nerd tree
" ignore files in NERD tree
let NERDTreeIgnore=['.git', '\.pyc$', 'node_modules', 'lib', '.DS_Store', '__pycache__', '\.ibc$', '\.swp$', '\.idr\~$', '\.jpg$', '\.png$']
let NERDTreeShowHidden=1
map <C-n> :NERDTreeToggle<CR>


"
"
" React configurations
"
"
"

let g:user_emmet_leader_key='<Tab>'
let g:user_emmet_settings = {
  \  'javascript.jsx' : {
    \      'extends' : 'js',
    \  },
  \}

let g:ale_sign_error = '●' " Less aggressive than the default '>>'
let g:ale_sign_warning = '.'
let g:ale_lint_on_enter = 0 " Less distracting when opening a new file

autocmd BufWritePost *.js AsyncRun -post=checktime ./node_modules/.bin/eslint --fix %

au BufNewFile,BufRead *.js
    \ set tabstop=2     |
    \ set softtabstop=2 |
    \ set shiftwidth=2  |
    \ set textwidth=100 |
    \ set expandtab     |
    \ set autoindent    |
    \ set fileformat=unix

"
"
"
" Python configurations
"
"
"

" Jedi-vim maps
let g:jedi#goto_command = "<leader>d"
let g:jedi#goto_assignments_command = "<leader>g"
let g:jedi#goto_definitions_command = ""
let g:jedi#documentation_command = "K"
let g:jedi#usages_command = "<leader>n"
let g:jedi#completions_command = "<C-Space>"
let g:jedi#rename_command = "<leader>r"

" python with virtualenv support
py3 << EOF
import os
import sys
if 'VIRTUAL_ENV' in os.environ:
  activate_this = os.environ['VIRTUAL_ENV_BASE_ACTIVATE_THIS']
  exec(open(activate_this).read(), dict(__file__=activate_this))
EOF

" PEP8 indentation specifications
au BufNewFile,BufRead *.py
    \ set tabstop=4     |
    \ set softtabstop=4 |
    \ set shiftwidth=4  |
    \ set textwidth=100 |
    \ set expandtab     |
    \ set autoindent    |
    \ set fileformat=unix

au BufWritePost *.py call Flake8()
let g:flake8_show_in_gutter=1
let g:flake8_show_in_file=1

" Python syntax highlighting
let python_highlight_all=1

"
"
" Visual configurations
"
"
"
set t_Co=256   " This is may or may not needed.

" if has('gui_running')
"   set background=dark
"   colorscheme PaperColor
" else
"   set background=light
"   colorscheme PaperColor
" endif

" Switch between themes
call togglebg#map("<F5>")

