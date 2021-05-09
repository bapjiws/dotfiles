call plug#begin('~/.config/nvim/plugged')

" Editing
Plug 'tpope/vim-surround' "https://github.com/tpope/vim-surround
Plug 'mg979/vim-visual-multi', {'branch': 'master'} "https://github.com/mg979/vim-visual-multi
Plug 'tpope/vim-unimpaired' "https://github.com/tpope/vim-unimpaired
Plug 'tpope/vim-repeat' "https://github.com/tpope/vim-repeat
Plug 'szw/vim-maximizer' "https://github.com/szw/vim-maximizer

" Visuals
Plug 'sainnhe/sonokai' "https://github.com/sainnhe/sonokai
Plug 'vim-airline/vim-airline' "https://github.com/vim-airline/vim-airline
Plug 'vim-airline/vim-airline-themes' "https://github.com/vim-airline/vim-airline-themes

" Navigation
Plug 'mhinz/vim-startify' "https://github.com/mhinz/vim-startify
Plug 'airblade/vim-rooter' "https://github.com/airblade/vim-rooter
Plug 'moll/vim-bbye' "https://github.com/moll/vim-bbye

" Git stuff
Plug 'tpope/vim-fugitive' "https://github.com/tpope/vim-fugitive
Plug 'airblade/vim-gitgutter' "https://github.com/airblade/vim-gitgutter
Plug 'APZelos/blamer.nvim' "https://github.com/APZelos/blamer.nvim

" Syntax and styling
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}  "https://github.com/nvim-treesitter/nvim-treesitter
" TODO: do we need it?
Plug 'styled-components/vim-styled-components', { 'branch': 'main' } "https://github.com/styled-components/vim-styled-components
Plug 'norcalli/nvim-colorizer.lua' "https://github.com/norcalli/nvim-colorizer.lua

" LSP and code completion
Plug 'neovim/nvim-lspconfig' "https://github.com/neovim/nvim-lspconfig
Plug 'hrsh7th/nvim-compe' "https://github.com/hrsh7th/nvim-compe
Plug 'jose-elias-alvarez/nvim-lsp-ts-utils' "https://github.com/jose-elias-alvarez/nvim-lsp-ts-utils
Plug 'romgrk/nvim-treesitter-context' "https://github.com/romgrk/nvim-treesitter-context
Plug 'nvim-treesitter/nvim-treesitter-refactor' "https://github.com/nvim-treesitter/nvim-treesitter-refactor

" Snippets
Plug 'SirVer/ultisnips' "https://github.com/sirver/UltiSnips

" Search
Plug 'nvim-lua/popup.nvim' "https://github.com/nvim-lua/popup.nvim
Plug 'nvim-lua/plenary.nvim' "https://github.com/nvim-lua/plenary.nvim
Plug 'nvim-telescope/telescope.nvim' "https://github.com/nvim-telescope/telescope.nvim

" Floating terminal
Plug 'voldikss/vim-floaterm' "https://github.com/voldikss/vim-floaterm

" Debugging
Plug 'puremourning/vimspector'

" Initialize plugin system
call plug#end()

set termguicolors

source $HOME/.config/nvim/plugin/startify.vim
source $HOME/.config/nvim/plugin/floaterm.vim
source $HOME/.config/nvim/plugin/blamer.vim
:lua require('lsp_init')
:lua require('telescope_init')
:lua require('compe_init')
:lua require('treesitter_init')
:lua require('colorizer_init')
source $HOME/.config/nvim/plugin/sonokai.vim
source $HOME/.config/nvim/plugin/airline.vim

set list lcs=tab:\ \ 

let g:vimspector_enable_mappings = 'HUMAN'
"packadd! vimspector

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
nnoremap <leader>mbf :MaximizerToggle<CR>

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

set foldmethod=expr
set foldexpr=nvim_treesitter#foldexpr()

"TODO: check if we need these settings left from Coc.
set signcolumn=yes
set cursorline
set foldcolumn=0
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
"END TODO

" Use <Tab> and <S-Tab> to navigate through popup menu
inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

" Set completeopt to have a better completion experience
set completeopt=menuone,noinsert,noselect

" Avoid showing message extra message when using completion
set shortmess+=c

"TODO: change TODO color to yellow.
highlight CursorLine guibg=#3E4452

" TODO: make if work.
augroup highlight_yank
    autocmd!
    autocmd TextYankPost * silent! lua require'vim.highlight'.on_yank()
augroup END

" TODO: rewrite in lua, move ti its file.
inoremap <silent><expr> <C-Space> compe#complete()
inoremap <silent><expr> <CR>      compe#confirm('<CR>')
inoremap <silent><expr> <C-e>     compe#close('<C-e>')
inoremap <silent><expr> <C-f>     compe#scroll({ 'delta': +4 })
inoremap <silent><expr> <C-d>     compe#scroll({ 'delta': -4 })

nnoremap [d :lua vim.lsp.diagnostic.goto_prev()<CR>zz
nnoremap ]d :lua vim.lsp.diagnostic.goto_next()<CR>zz

nnoremap ]c :GitGutterNextHunk<CR>zz
nnoremap [c :GitGutterPrevHunk<CR>zz

nnoremap <leader>ipg :PlugInstall<CR>
nnoremap <leader>cpg :PlugClean<CR>
nnoremap <leader>upg :PlugUpdate<CR>

nnoremap <leader>cab :w <bar> %bd <bar> e# <bar> bd# <CR>

nnoremap <leader>rnm :lua vim.lsp.buf.rename()<CR>
nnoremap <leader>rpc :%s/<C-r>=printf("%s", expand("<cword>"))<CR>//g<left><left>

nnoremap <leader>fmt :lua vim.lsp.buf.formatting()<CR>

nnoremap <leader>und :GitGutterUndoHunk<CR>
nnoremap <leader>prw :GitGutterPreviewHunk<CR>
nnoremap <leader>fld :GitGutterFold<CR>

nnoremap <leader>dff :Gvdiffsplit<CR>
nnoremap <leader>dfm :Gvdiffsplit master<CR><c-w>r
nnoremap <leader>rst :Gread<CR>
nnoremap <leader>blf :Gblame<CR>
nnoremap <leader>bll :BlamerToggle<CR>

nnoremap <leader>vsc :FloatermNew lazygit<CR>

nnoremap <leader>tdf :lua vim.lsp.buf.type_definition()<CR>
nnoremap <leader>hov :lua vim.lsp.buf.hover()<CR>
nnoremap <leader>sgn :lua vim.lsp.buf.signature_help()<CR>
nnoremap <leader>imp :lua vim.lsp.buf.implementation()<CR>
"nnoremap <leader>rfc :lua require('telescope.builtin').lsp_references()<CR>

nnoremap <leader>trm :FloatermNew zsh<CR>

nnoremap <leader>ssn :SSave<CR>
nnoremap <leader>lsn :SLoad<CR>
nnoremap <leader>dsn :SDelete<CR>

nnoremap <leader>wrt :w<CR>
nnoremap <leader>src :source $MYVIMRC<CR>

nnoremap <leader>fex :FloatermNew ranger<CR>

" To change 2 spaces to a tab 
":%s/\(^\s*\)\@<=    /\t/g
