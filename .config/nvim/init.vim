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

" Code completion
Plug 'neoclide/coc.nvim', {'branch': 'release'} "https://github.com/neoclide/coc.nvim

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
source $HOME/.config/nvim/plugin-config/nerdtree.vim
source $HOME/.config/nvim/themes/onedark.vim
source $HOME/.config/nvim/themes/airline.vim

map <Space> <leader>

set foldmethod=marker

set relativenumber
set number

set noswapfile

set splitbelow splitright

" Shift lines
vnoremap J :m '>+1<CR>gv=gv
vnoremap K :m '<-2<CR>gv=gv

" Source on save 
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

nnoremap <C-K> :resize +5<CR>
nnoremap <C-J> :resize -5<CR>
nnoremap <C-H> :vertical resize +5<CR>
nnoremap <C-L> :vertical resize -5<CR>

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
 
" TODO: remove or update the comments
" https://github.com/neoclide/coc-css
" https://github.com/iamcco/coc-svg
" https://github.com/neoclide/coc-emmet
" https://github.com/neoclide/coc-pairs
" https://github.com/neoclide/coc-snippets
let g:coc_global_extensions = [
  \ 'coc-tsserver',
  \ 'coc-json',
  \ 'coc-html', 
  \ 'coc-css', 
  \ 'coc-svg', 
  \ 'coc-emmet',
  \ 'coc-pairs',
  \ 'coc-snippets',
  \ 'coc-eslint',
  \ 'coc-prettier'
  \]

" TextEdit might fail if hidden is not set.
set hidden

" Some servers have issues with backup files, see #649.
set nobackup
set nowritebackup

" Give more space for displaying messages.
set cmdheight=2

" Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
" delays and poor user experience.
set updatetime=300

" Don't pass messages to |ins-completion-menu|.
set shortmess+=c

" Always show the signcolumn, otherwise it would shift the text each time
" diagnostics appear/become resolved.
set signcolumn=yes

" Use tab for trigger completion with characters ahead and navigate.
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Trigger completion.
inoremap <silent><expr> <c-space> coc#refresh()

" Use <CR> to confirm completion, `<C-g>u` means break undo chain at current
" position. Coc only does snippet and additional edit on confirm.
if exists('*complete_info')
  inoremap <expr> <CR> complete_info()["selected"] != "-1" ? "\<C-y>" : "\<C-g>u\<CR>"
else
  imap <expr> <CR> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
endif

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

"TODO: highlight brighter.
autocmd CursorHold * silent call CocActionAsync('highlight')

"TODO: introduce "force"/"screaming" commands like mks! or rld!  

nnoremap rnm <Plug>(coc-rename)
"TODO: run on save.
"TODO: rename.
nnoremap <silent> prt :CocCommand prettier.formatFile<CR>
nnoremap <silent> oip :CocCommand editor.action.organizeImport<CR>
nnoremap <silent> hlp :call <SID>show_documentation()<CR>

nnoremap ]h <Plug>(GitGutterNextHunk)
nnoremap [h <Plug>(GitGutterPrevHunk)
nnoremap hst <Plug>(GitGutterStageHunk)
nnoremap hud <Plug>(GitGutterUndoHunk)
nnoremap hpw <Plug>(GitGutterPreviewHunk)
nnoremap <silent> fld :GitGutterFold<CR>

"TODO: rename without the git part.
nnoremap <silent> gdf :Gdiffsplit<CR>
nnoremap <silent> gck :Gread<CR>
nnoremap <silent> gbl :Gblame<CR>

nnoremap <silent> dgs  :<C-u>CocList diagnostics<CR>
nnoremap <silent> [d <Plug>(coc-diagnostic-prev)
nnoremap <silent> ]d <Plug>(coc-diagnostic-next)

nnoremap <silent> ext  :<C-u>CocList extensions<CR>
nnoremap <silent> cmd  :<C-u>CocList commands<CR>

"TODO: rename.
nnoremap <leader>lzg :FloatermNew lazygit<CR>

nnoremap <silent> dfn <Plug>(coc-definition)
nnoremap <silent> tdf <Plug>(coc-type-definition)
nnoremap <silent> imp <Plug>(coc-implementation)
nnoremap <silent> rfc <Plug>(coc-references)

nnoremap <silent> trm :FloatermNew<CR>
"TODO: rename to smb or something.
nnoremap <silent> vst :Vista coc<CR>

nnoremap mks :mksession ~/.config/nvim/session/.vim<Left><Left><Left><Left>

" TODO: meta: save, reload, find, deps management with Plug, file navigation, terminal
" TODO: try `src` and `wrt`.
nnoremap wrt :w<CR>
"nnoremap <C-s> :source $MYVIMRC<CR>
nnoremap src :source $MYVIMRC<CR>
" rld  --rld> :e
nnoremap <leader>n :NERDTreeToggle<CR>
nnoremap <silent> <leader>f :NERDTreeFind<CR> 
" TODO: is version control meta?

"nnoremap caw "*yaw 
"nnoremap paw "*p

" TODO: try `fcw` and ``.
nnoremap <leader>fw :<C-r>=printf("Rg %s", expand("<cword>"))<CR><CR>
vnoremap <leader>fv "*y<Esc> :Rg <C-r>*<CR>

