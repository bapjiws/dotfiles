call plug#begin('~/.config/nvim/plugged')

" Editing
Plug 'tpope/vim-surround'
Plug 'mg979/vim-visual-multi', {'branch': 'master'}
Plug 'tpope/vim-unimpaired'
Plug 'tpope/vim-repeat'
Plug 'szw/vim-maximizer'

" Visuals
Plug 'sainnhe/sonokai'
Plug 'glepnir/galaxyline.nvim' , {'branch': 'main'}
Plug 'kyazdani42/nvim-web-devicons'

" Project navigation
Plug 'glepnir/dashboard-nvim'
Plug 'airblade/vim-rooter'
Plug 'moll/vim-bbye'
Plug 'akinsho/nvim-bufferline.lua'

" Git stuff
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-rhubarb'
Plug 'lewis6991/gitsigns.nvim'

" Syntax and styling
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'} 
" TODO: do we need it?
Plug 'styled-components/vim-styled-components', { 'branch': 'main' }
Plug 'norcalli/nvim-colorizer.lua'

" LSP and code completion
Plug 'hrsh7th/nvim-cmp'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-nvim-lua'

Plug 'neovim/nvim-lspconfig'

Plug 'jose-elias-alvarez/nvim-lsp-ts-utils'
Plug 'romgrk/nvim-treesitter-context'
Plug 'nvim-treesitter/nvim-treesitter-refactor'
Plug 'cohama/lexima.vim'
Plug 'mattn/emmet-vim'

" Snippets
Plug 'SirVer/ultisnips'
Plug 'quangnguyen30192/cmp-nvim-ultisnips'

" Search
Plug 'nvim-lua/popup.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'

" Floating terminal
Plug 'voldikss/vim-floaterm'

" Fix gx
Plug 'stsewd/gx-extended.vim'

" Initialize plugin system
call plug#end()

set termguicolors

source $HOME/.config/nvim/plugin/floaterm.vim
:lua require('general_init')
:lua require('dashboard_init')
:lua require('lsp_init')
:lua require('telescope_init')
:lua require('cmp_init')
:lua require('treesitter_init')
:lua require('gitsigns_init')
:lua require('galaxyline_init')
:lua require('colorizer_init')
:lua require('sonokai_init')
:lua require('bufferline_init')
:lua require('bbye_init')



set list lcs=tab:\ \ 

" Disable automatic folding when opening a file
set nofoldenable

set foldmethod=expr
set foldexpr=nvim_treesitter#foldexpr()

set relativenumber
set number

set noswapfile

set splitbelow splitright

" Tab counts for 2 spaces
set tabstop=2
" When indenting with '>', use 2 spaces width
set shiftwidth=2
" On pressing tab, insert 2 spaces
set expandtab

set signcolumn=yes

set cursorline
"TODO: change TODO color to yellow.
highlight CursorLine guibg=#3E4452

" Give more space for displaying messages.
set cmdheight=2
" Having longer updatetime leads to noticeable delays.
set updatetime=300

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

nnoremap <leader>ipg :PlugInstall<CR>
nnoremap <leader>cpg :PlugClean<CR>
nnoremap <leader>upg :PlugUpdate<CR>

nnoremap <leader>cab :w <bar> %bd <bar> e# <bar> bd# <CR>

nnoremap <leader>rpc :%s/<C-r>=printf("%s", expand("<cword>"))<CR>//g<left><left>

nnoremap <leader>dff :Gvdiffsplit<CR>
nnoremap <leader>dfm :Gvdiffsplit master<CR><c-w>r
nnoremap <leader>blf :Git blame<CR>
nnoremap <leader>brg :GBrowse<CR>

nnoremap <leader>vsc :FloatermNew lazygit<CR>

nnoremap <leader>trm :FloatermNew fish<CR>

nnoremap <leader>wrt :w<CR>
nnoremap <leader>src :source $MYVIMRC<CR>

nnoremap <leader>fex :FloatermNew ranger<CR>

" To change 2 spaces to a tab 
":%s/\(^\s*\)\@<=    /\t/g
