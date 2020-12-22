call plug#begin('~/.config/nvim/plugged')

" Editing
Plug 'tpope/vim-surround' "https://github.com/tpope/vim-surround
Plug 'mg979/vim-visual-multi', {'branch': 'master'} "https://github.com/mg979/vim-visual-multi

" Visual stuff
Plug 'joshdick/onedark.vim' "https://github.com/joshdick/onedark.vim
Plug 'vim-airline/vim-airline' "https://github.com/vim-airline/vim-airline
Plug 'vim-airline/vim-airline-themes' "https://github.com/vim-airline/vim-airline-themes

" Navigation
" TODO: decide if we need NERDTree and related stuff.
Plug 'scrooloose/nerdtree' "https://github.com/scrooloose/nerdtree
Plug 'mhinz/vim-startify' "https://github.com/mhinz/vim-startify

" Git stuff
" TODO: [nerdtree-git-status] option 'g:NERDTreeIndicatorMapCustom' is deprecated, please use 'g:NERDTreeGitStatusIndicatorMapCustom'
Plug 'Xuyuanp/nerdtree-git-plugin' "https://github.com/Xuyuanp/nerdtree-git-plugin
Plug 'tpope/vim-fugitive' "https://github.com/tpope/vim-fugitive
Plug 'airblade/vim-gitgutter' "https://github.com/airblade/vim-gitgutter
Plug 'rhysd/git-messenger.vim' "https://github.com/rhysd/git-messenger.vim
Plug 'APZelos/blamer.nvim' "https://github.com/APZelos/blamer.nvim

" Syntax and styling
" TODO: do we need it?
Plug 'sheerun/vim-polyglot' "https://github.com/sheerun/vim-polyglot
" TODO: do we need it?
Plug 'styled-components/vim-styled-components', { 'branch': 'main' }

" Code completion
Plug 'neoclide/coc.nvim', {'branch': 'release'} "https://github.com/neoclide/coc.nvim

" Search
Plug 'liuchengxu/vim-clap', { 'do': ':Clap install-binary!' }

" Floating terminal
Plug 'voldikss/vim-floaterm' "https://github.com/voldikss/vim-floaterm

" Initialize plugin system
call plug#end()

source $HOME/.config/nvim/plugin-config/startify.vim
source $HOME/.config/nvim/plugin-config/clap.vim
source $HOME/.config/nvim/plugin-config/floaterm.vim
source $HOME/.config/nvim/plugin-config/nerdtree.vim
source $HOME/.config/nvim/plugin-config/blamer.vim
source $HOME/.config/nvim/themes/onedark.vim
source $HOME/.config/nvim/themes/airline.vim

map <Space> <leader>

" Exit terminal-mode
tnoremap <C-]> <C-\><C-n>

" TODO: check if we need all of these.
" disable automatic folding when opening a file
set nofoldenable
set foldmethod=syntax

set relativenumber
set number

set noswapfile
set splitbelow splitright

set langmenu=en_US
let $LANG = 'en_US'
source $VIMRUNTIME/delmenu.vim
source $VIMRUNTIME/menu.vim

set noshowmode

" tab counts for 2 spaces
set tabstop=2
" when indenting with '>', use 2 spaces width
set shiftwidth=2
" on pressing tab, insert 2 spaces
set expandtab

" Clean up the search results. 
nnoremap <esc> :noh<cr>
" Case-insensitive search.
nnoremap / /\c
" Search for visually selected text.
vnoremap // y/\V<C-R>=escape(@",'/\')<CR><CR>

nnoremap , @@

" Shift lines
" TODO: find out why how it works. 
vnoremap J :m '>+1<CR>gv=gv
vnoremap K :m '<-2<CR>gv=gv

augroup source_vimrc_on_save
  autocmd!
  autocmd BufWritePost *.vim source $MYVIMRC
augroup END

" Enable open commands for floaterm + ranger.
au filetype floaterm call SetFloatermMappings()
function! SetFloatermMappings()
   tnoremap <buffer> <c-o> <cmd>let g:floaterm_open_command = 'edit'    \| call feedkeys("l", "i")<CR>
   tnoremap <buffer> <c-t> <cmd>let g:floaterm_open_command = 'tabedit' \| call feedkeys("l", "i")<cr>
   tnoremap <buffer> <c-x> <cmd>let g:floaterm_open_command = 'split'  \| call feedkeys("l", "i")<CR>
   tnoremap <buffer> <c-v> <cmd>let g:floaterm_open_command = 'vsplit'  \| call feedkeys("l", "i")<CR>
endfunction

nnoremap <down> <nop>
nnoremap <left> <nop>
nnoremap <right> <nop>
nnoremap <up> <nop>

nnoremap <C-K> :resize +5<CR>
nnoremap <C-J> :resize -5<CR>
nnoremap <C-H> :vertical resize +5<CR>
nnoremap <C-L> :vertical resize -5<CR>

nnoremap oo o<esc>k
nnoremap OO O<esc>j

nnoremap * *zz
nnoremap # #zz
nnoremap N Nzz
nnoremap n nzz
nnoremap g* g*zz
nnoremap g# g#zz

nnoremap <C-d> <C-d>zz
nnoremap <C-u> <C-u>zz
nnoremap <C-f> <C-f>zz
nnoremap <C-b> <C-b>zz

let g:coc_global_extensions = [
  \ 'coc-tsserver',
  \ 'coc-json',
  \ 'coc-html', 
  \ 'coc-css', 
  \ 'coc-svg', 
  \ 'coc-emmet',
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

set cursorline
set foldcolumn=0

highlight CocHighlightText ctermbg=237 guibg=#3E4452
autocmd CursorHold * silent call CocActionAsync('highlight')

" TODO: make if work.
augroup highlight_yank
    autocmd!
    autocmd TextYankPost * silent! lua require'vim.highlight'.on_yank()
augroup END

nnoremap ]c :GitGutterNextHunk<CR>zz
nnoremap [c :GitGutterPrevHunk<CR>zz
nnoremap [d :<C-u>call CocActionAsync('diagnosticPrevious')<CR>zz
nnoremap ]d :<C-u>call CocActionAsync('diagnosticNext')<CR>zz

nnoremap <leader>ipg :PlugInstall<CR>
nnoremap <leader>cpg :PlugClean<CR>
nnoremap <leader>upg :PlugUpdate<CR>

" TODO: check if we need/use these two.
nnoremap <leader>cla :<C-u>call CocHasProvider('codeLens')<CR>
nnoremap <leader>cls :<C-u>call CocActionAsync('codeLensAction')<CR>

nnoremap <leader>rnm :<C-u>call CocActionAsync('rename')<CR>
nnoremap <leader>rpc :%s/<C-r>=printf("%s", expand("<cword>"))<CR>//g<left><left>

nnoremap <leader>fmt :CocCommand prettier.formatFile<CR>
nnoremap <leader>oim :CocCommand editor.action.organizeImport<CR>
nnoremap <leader>hlp :call <SID>show_documentation()<CR>

" TODO: already use lazygit for this operation.
nnoremap <leader>add :GitGutterStageHunk<CR>
nnoremap <leader>und :GitGutterUndoHunk<CR>
nnoremap <leader>prw :GitGutterPreviewHunk<CR>
nnoremap <leader>fld :GitGutterFold<CR>

nnoremap <leader>dff :Gvdiffsplit<CR>
nnoremap <leader>rst :Gread<CR>
nnoremap <leader>blm :Gblame<CR>
" TODO: find better name.
nnoremap <leader>atp :BlamerToggle<CR>
nnoremap <leader>cms :GitMessenger<CR>

nnoremap <leader>fcm :Clap bcommits<CR>
nnoremap <leader>pcm :Clap commits<CR>

nnoremap <leader>dgn :<C-u>CocList diagnostics<CR>

nnoremap <leader>ext  :<C-u>CocList extensions<CR>
nnoremap <leader>cmd  :<C-u>CocList commands<CR>

nnoremap <leader>vsn :FloatermNew lazygit<CR>

nnoremap <leader>dfn :<C-u>call CocActionAsync('jumpDefinition')<CR>
nnoremap <leader>aaa :call CocAction('jumpDefinition', 'vsplit')<CR>
nnoremap <leader>bbb :call CocAction('doHover')<CR>
nnoremap <leader>tdf :<C-u>call CocActionAsync('jumpTypeDefinition')<CR> 
nnoremap <leader>ccc :call CocActionAsync('showSignatureHelp')<CR>
" TODO: show in a floating window.
nnoremap <leader>imp :<C-u>call CocActionAsync('jumpImplementation')<CR> 
nnoremap <leader>rfc :<C-u>call CocActionAsync('jumpReferences')<CR>

nnoremap <leader>trm :FloatermNew fish<CR>

" TODO: create a func and use $VIM_SESSION_DIR. 
nnoremap <leader>mks :mksession ~/.config/nvim/session/.vim<Left><Left><Left><Left>
nnoremap <leader>mks! :mksession! ~/.config/nvim/session/.vim<Left><Left><Left><Left>

nnoremap <leader>wrt :w<CR>
nnoremap <leader>src :source $MYVIMRC<CR>

nnoremap <leader>fex :FloatermNew ranger<CR>
" TODO: find better name.
nnoremap <leader>fit :NERDTreeFind<CR> 

" TODO: File icons

" file search
nnoremap <leader>sif :Clap files<CR>
nnoremap <leader>fwf :Clap files ++query=<cword><CR>

" line search
nnoremap <leader>sil :Clap blines<CR>
nnoremap <leader>fwl :Clap blines ++query=<cword><CR>

nnoremap <leader>sip :Clap grep<CR>
nnoremap <leader>fwp :Clap grep ++query=<cword><CR>
xnoremap <leader>fwp :Clap grep ++query=@visual<CR>

" buffer search
nnoremap <leader>sib :Clap buffers<CR>
