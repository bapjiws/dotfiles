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

"TODO: introduce "force"/"yelling" commands like mks! or rld!  

nnoremap <leader>rnm <Plug>(coc-rename)
"TODO: run on save.
nnoremap <leader>fmt :CocCommand prettier.formatFile<CR>
nnoremap <leader>oim :CocCommand editor.action.organizeImport<CR>
nnoremap <leader>hlp :call <SID>show_documentation()<CR>

nnoremap ]c :GitGutterNextHunk<CR>
nnoremap [c :GitGutterPrevHunk<CR>
nnoremap <leader>add <Plug>(GitGutterStageHunk)
nnoremap <leader>und <Plug>(GitGutterUndoHunk)
nnoremap <leader>prw <Plug>(GitGutterPreviewHunk)
nnoremap <leader>fld :GitGutterFold<CR>

nnoremap <leader>dff :Gdiffsplit<CR>
nnoremap <leader>rst :Gread<CR>
nnoremap <leader>blm :Gblame<CR>

nnoremap [d :<C-u>call CocActionAsync('diagnosticPrevious')<CR>
nnoremap ]d :<C-u>call CocActionAsync('diagnosticNext')<CR>
nnoremap <leader>dgn :<C-u>CocList diagnostics<CR>

nnoremap <leader>ext  :<C-u>CocList extensions<CR>
nnoremap <leader>cmd  :<C-u>CocList commands<CR>

nnoremap <leader>vsn :FloatermNew lazygit<CR>

nnoremap <leader>dfn <Plug>(coc-definition)
nnoremap <leader>tdf <Plug>(coc-type-definition)
nnoremap <leader>imp <Plug>(coc-implementation)
nnoremap <leader>rfc <Plug>(coc-references)

nnoremap <leader>trm :FloatermNew<CR>
nnoremap <leader>sym :Vista coc<CR>

" TODO: create a func and use $VIM_SESSION_DIR. 
nnoremap <leader>mks :mksession ~/.config/nvim/session/.vim<Left><Left><Left><Left>

nnoremap <leader>wrt :w<CR>
nnoremap <leader>src :source $MYVIMRC<CR>

" TODO: `rld`  --rld> :e

nnoremap <leader>fex :NERDTreeToggle<CR>
nnoremap <leader>fit :NERDTreeFind<CR> 

nnoremap <leader>yaw "*yaw
" moves the cursor one character to the right after executing.
nnoremap <leader>yiw "*yiw 
vnoremap <leader>yvs "*y
"nnoremap paw "*p

" TODO: try `fcw` and ``.
nnoremap <leader>fwp :<C-r>=printf("Rg %s", expand("<cword>"))<CR><CR>
" TODO: make a func for Files  and pass the copied word as an argument.
" nnoremap <leader>fwf :<C-r>=printf("Files %s", expand("<cword>"))<CR><CR>
vnoremap <leader>fv "*y<Esc> :Rg <C-r>*<CR>

