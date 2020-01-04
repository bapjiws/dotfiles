" TODO: consider using vim 8's native installs. 
" Install vim-plug if missing
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" Specify a directory for plugins
" - For Neovim: stdpath('data') . '/plugged'
" - Avoid using standard Vim directory names like 'plugin'
call plug#begin('~/.vim/plugged')

" Visual stuff
Plug 'morhetz/gruvbox' "https://github.com/morhetz/gruvbox
Plug 'vim-airline/vim-airline' "https://github.com/vim-airline/vim-airline
Plug 'vim-airline/vim-airline-themes'

" Fuzzy search
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' } "https://github.com/junegunn/fzf
Plug 'junegunn/fzf.vim'

" File navigation
Plug 'scrooloose/nerdtree' "https://github.com/scrooloose/nerdtree

" Git stuff
Plug 'Xuyuanp/nerdtree-git-plugin' "https://github.com/Xuyuanp/nerdtree-git-plugin
Plug 'tpope/vim-fugitive' "https://github.com/tpope/vim-fugitive
Plug 'airblade/vim-gitgutter' "https://github.com/airblade/vim-gitgutter

" Syntax and styling
Plug 'sheerun/vim-polyglot' "https://github.com/sheerun/vim-polyglot
Plug 'vim-syntastic/syntastic' "https://github.com/vim-syntastic/syntastic
Plug 'prettier/vim-prettier', { 'do': 'npm install' } "https://github.com/prettier/vim-prettier

" Code completion
" :CocInstall coc-tsserver coc-json coc-html coc-css coc-svg
"  TODO: check out coc-emmet and coc-snippets 
Plug 'neoclide/coc.nvim', {'branch': 'release'} "https://github.com/neoclide/coc.nvim
Plug 'sirver/UltiSnips' "https://github.com/sirver/UltiSnips
Plug 'honza/vim-snippets' "https://github.com/honza/vim-snippets

" Initialize plugin system
call plug#end()

set foldmethod=marker

set relativenumber
set number

set noswapfile
set incsearch

" Make the backspace work like in most other programs
set backspace=indent,eol,start

syntax on

set splitbelow
set splitright

" Colour scheme {{{
colorscheme gruvbox
set background=dark
set t_Co=256
" }}}

" Key mappings {{{
nnoremap <Down> <Nop>
nnoremap <Left> <Nop>
nnoremap <Right> <Nop>
nnoremap <Up> <Nop>
" }}}

" Language {{{
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

" Snippets {{{
let g:UltiSnipsSnippetsDir="~/.vim/UltiSnips"
let g:UltiSnipsSnippetDirectories=["UltiSnips"]
" }}}

" Augmenting Rg command using fzf#vim#with_preview function
command! -bang -nargs=* Rg
  \ call fzf#vim#grep(
  \   'rg --column --line-number --no-heading --color=always --smart-case '.shellescape(<q-args>), 1,
  \   fzf#vim#with_preview(), <bang>0)

" Example settings for nerdtree-git-plugin {{{
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

let g:syntastic_javascript_checkers = ['syntastic-html-eslint', 'syntastic-javascript-eslint']

" Recommended settings for syntastic {{{ 
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
" }}}
