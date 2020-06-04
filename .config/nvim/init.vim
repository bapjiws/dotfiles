call plug#begin('~/.config/nvim/plugged')

" Editing
Plug 'tpope/vim-surround' "https://github.com/tpope/vim-surround

" Visual stuff
Plug 'joshdick/onedark.vim' "https://github.com/joshdick/onedark.vim
Plug 'vim-airline/vim-airline' "https://github.com/vim-airline/vim-airline
Plug 'vim-airline/vim-airline-themes' "https://github.com/vim-airline/vim-airline-themes

" Navigation
Plug 'scrooloose/nerdtree' "https://github.com/scrooloose/nerdtree
Plug 'mhinz/vim-startify' "https://github.com/mhinz/vim-startify

" Git stuff
Plug 'Xuyuanp/nerdtree-git-plugin' "https://github.com/Xuyuanp/nerdtree-git-plugin
Plug 'tpope/vim-fugitive' "https://github.com/tpope/vim-fugitive
Plug 'airblade/vim-gitgutter' "https://github.com/airblade/vim-gitgutter

" Syntax and styling
Plug 'sheerun/vim-polyglot' "https://github.com/sheerun/vim-polyglot
Plug 'styled-components/vim-styled-components', { 'branch': 'main' }

" Snippets
Plug 'thomasfaingnaert/vim-lsp-snippets'
Plug 'thomasfaingnaert/vim-lsp-ultisnips'
Plug 'SirVer/ultisnips'

" LSP
Plug 'prabirshrestha/async.vim'
Plug 'prabirshrestha/vim-lsp'
Plug 'mattn/vim-lsp-settings'
" Autocompletion
Plug 'prabirshrestha/asyncomplete.vim'
Plug 'prabirshrestha/asyncomplete-lsp.vim'

Plug 'sbdchd/neoformat'

" Search
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

" TODO: add checks for fzf and lazygit to fish config to install them if missing.
Plug 'voldikss/vim-floaterm' "https://github.com/voldikss/vim-floaterm

Plug 'liuchengxu/vista.vim' "https://github.com/liuchengxu/vista.vim

" Initialize plugin system
call plug#end()

source $HOME/.config/nvim/plugin-config/startify.vim
source $HOME/.config/nvim/plugin-config/fzf.vim
source $HOME/.config/nvim/plugin-config/floaterm.vim
source $HOME/.config/nvim/plugin-config/vista.vim
source $HOME/.config/nvim/themes/onedark.vim
source $HOME/.config/nvim/themes/airline.vim

set foldmethod=marker

set relativenumber
set number

set noswapfile

set splitbelow splitright

" Invoke plugins
" TODO: move calls for Prettier and Floaterm here.
nnoremap <leader>g :FloatermNew lazygit<CR>

" Shift lines
vnoremap J :m '>+1<CR>gv=gv
vnoremap K :m '<-2<CR>gv=gv

nnoremap <C-s> :source $MYVIMRC<CR>
augroup myvimrc
  autocmd!
  autocmd BufWritePost $MYVIMRC source $MYVIMRC
augroup END

" Key mappings {{{
nnoremap <Down> <Nop>
nnoremap <Left> <Nop>
nnoremap <Right> <Nop>
nnoremap <Up> <Nop>
" }}}

"Find current word
nnoremap <leader>fw :<C-r>=printf("Rg %s", expand("<cword>"))<CR><CR>
"Find visual selection
vnoremap <leader>fv "*y<Esc> :Rg <C-r>*<CR>

nnoremap <C-K> :resize +5<CR>
nnoremap <C-J> :resize -5<CR>
nnoremap <C-H> :vertical resize +5<CR>
nnoremap <C-L> :vertical resize -5<CR>

"Code completion
inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
inoremap <expr> <cr>    pumvisible() ? "\<C-y>" : "\<cr>"

imap <c-space> <Plug>(asyncomplete_force_refresh)

let g:asyncomplete_auto_popup = 0

function! s:check_back_space() abort
    let col = col('.') - 1
    return !col || getline('.')[col - 1]  =~ '\s'
endfunction

inoremap <silent><expr> <TAB>
  \ pumvisible() ? "\<C-n>" :
  \ <SID>check_back_space() ? "\<TAB>" :
  \ asyncomplete#force_refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

let g:asyncomplete_auto_completeopt = 0
set completeopt=menuone,noinsert,noselect,preview
autocmd! CompleteDone * if pumvisible() == 0 | pclose | endif

let g:lsp_signs_error = {'text': '✗'}
let g:lsp_signs_warning = {'text': '⚠'}
let g:lsp_signs_hint = {'text': 'ℹ'}


let g:lsp_log_verbose = 1
let g:lsp_log_file = expand('~/vim-lsp.log')

" for asyncomplete.vim log
let g:asyncomplete_log_file = expand('~/asyncomplete.log')


" Snippets
let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsJumpForwardTrigger="<tab>"
let g:UltiSnipsJumpBackwardTrigger="<s-tab>"

let g:UltiSnipsEditSplit="vertical"

" Language {{{
" TODO: check if we need all these.
set langmenu=en_US
let $LANG = 'en_US'
source $VIMRUNTIME/delmenu.vim
source $VIMRUNTIME/menu.vim
" }}}

" Space {{{
" tab counts for 2 spaces
set tabstop=2
" when indenting with '>', use 2 spaces width
set shiftwidth=2
" on pressing tab, insert 2 spaces
set expandtab
" }}}
 
" NERDTree {{{

" Automatically close NerdTree when you open a file
let g:NERDTreeQuitOnOpen = 1

" Remove the 'Press ? for help' prompt from the top
let g:NERDTreeMinimalUI = 1

nnoremap <leader>n :NERDTreeToggle<CR>
nnoremap <silent> <leader>f :NERDTreeFind<CR> 
let g:NERDTreeIndicatorMapCustom = {
    \ "Modified"  : "✹",
    \ "Staged"    : "✚",
    \ "Untracked" : "✭",
    \ "Renamed"   : "➜",
    \ "Unmerged"  : "═",
    \ "Deleted"   : "✖",
    \ "Dirty"     : "✗",
    \ "Clean"     : "✔︎",
    \ 'Ignored'   : '☒',
    \ "Unknown"   : "?"
    \ }
" }}}
