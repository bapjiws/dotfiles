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
Plug 'nvim-lua/completion-nvim' "https://github.com/nvim-lua/completion-nvim
Plug 'steelsojka/completion-buffers' "https://github.com/steelsojka/completion-buffers
Plug 'romgrk/nvim-treesitter-context' "https://github.com/romgrk/nvim-treesitter-context
Plug 'nvim-treesitter/nvim-treesitter-refactor', { 'commit': '130d94' } "https://github.com/nvim-treesitter/nvim-treesitter-refactor

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

source $HOME/.config/nvim/plugin-config/startify.vim
source $HOME/.config/nvim/plugin-config/floaterm.vim
source $HOME/.config/nvim/plugin-config/blamer.vim
source $HOME/.config/nvim/plugin-config/telescope.vim
source $HOME/.config/nvim/plugin-config/colorizer.vim

source $HOME/.config/nvim/lsp/diagnosticls.vim
source $HOME/.config/nvim/lsp/tsserver.vim

source $HOME/.config/nvim/themes/sonokai.vim
source $HOME/.config/nvim/themes/airline.vim

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

:lua <<EOF
require'nvim-treesitter.configs'.setup {
  ensure_installed = { "javascript", "typescript", "tsx", "html", "css", "json", "graphql", "bash", "regex", "yaml", "lua" },
  highlight = {
    enable = true,
  },
  incremental_selection = {
    enable = true,
    keymaps = {
      node_incremental = "]v", --"grn",
      node_decremental = "[v", --"grm",
    },
  },
  refactor = {
    highlight_definitions = { enable = true },
    navigation = {
      enable = true,
      keymaps = {
        goto_definition_lsp_fallback = "<leader>dfn",
        goto_next_usage = "]w",
        goto_previous_usage = "[w",
      },
    },
  },
}
EOF

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

" Use completion-nvim in every buffer
autocmd BufEnter * lua require'completion'.on_attach()

let g:completion_chain_complete_list = [
    \{'complete_items': ['lsp', 'snippet', 'buffers']},
    \{'mode': '<c-p>'},
    \{'mode': '<c-n>'}
\]

let g:completion_enable_snippet = 'UltiSnips'

highlight TelescopeSelection      guifg=#F27C04 gui=bold " selected item
highlight TelescopeSelectionCaret guifg=#CC241D " selection caret
highlight TelescopeMultiSelection guifg=#928374 " multisections
highlight TelescopeNormal         guibg=#00000  " floating windows created by telescope.

highlight TelescopeMatching       guifg=#16DBC2

"TODO: change TODO color to yellow.
highlight CursorLine guibg=#3E4452

" TODO: make if work.
augroup highlight_yank
    autocmd!
    autocmd TextYankPost * silent! lua require'vim.highlight'.on_yank()
augroup END

sign define LspDiagnosticsSignHint text=ℹ texthl=LspDiagnosticsSignHint linehl= numhl=
sign define LspDiagnosticsSignWarning text=⚠ texthl=LspDiagnosticsSignWarning linehl= numhl=
sign define LspDiagnosticsSignError text=✗ texthl=LspDiagnosticsSignError linehl= numhl=

nnoremap [d :lua vim.lsp.diagnostic.goto_prev()<CR>zz
nnoremap ]d :lua vim.lsp.diagnostic.goto_next()<CR>zz

nnoremap ]c :GitGutterNextHunk<CR>zz
nnoremap [c :GitGutterPrevHunk<CR>zz

nnoremap <leader>ipg :PlugInstall<CR>
nnoremap <leader>cpg :PlugClean<CR>
nnoremap <leader>upg :PlugUpdate<CR>

nnoremap <leader>cab :w <bar> %bd <bar> e# <bar> bd# <CR>

nnoremap <leader>sih :lua require('telescope.builtin').help_tags()<CR>
nnoremap <leader>fwh :lua require('telescope.builtin').help_tags({ default_text = vim.fn.expand("<cword>") })<CR>

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

nnoremap <leader>fcm :lua require('telescope.builtin').git_bcommits()<CR>
nnoremap <leader>pcm :lua require('telescope.builtin').git_commits()<CR>
nnoremap <leader>chf :lua require('telescope.builtin').git_status()<CR>

nnoremap <leader>vsc :FloatermNew lazygit<CR>

nnoremap <leader>tdf :lua vim.lsp.buf.type_definition()<CR>
nnoremap <leader>hov :lua vim.lsp.buf.hover()<CR>
nnoremap <leader>sgn :lua vim.lsp.buf.signature_help()<CR>
nnoremap <leader>imp :lua vim.lsp.buf.implementation()<CR>
nnoremap <leader>rfc :lua vim.lsp.buf.references()<CR>

nnoremap <leader>trm :FloatermNew zsh<CR>

nnoremap <leader>ssn :SSave<CR>
nnoremap <leader>lsn :SLoad<CR>
nnoremap <leader>dsn :SDelete<CR>

nnoremap <leader>wrt :w<CR>
nnoremap <leader>src :source $MYVIMRC<CR>

nnoremap <leader>fex :FloatermNew ranger<CR>

" TODO: File icons

" file search
nnoremap <leader>sif :lua require('telescope.builtin').find_files()<CR>
nnoremap <leader>fwf :lua require('telescope.builtin').find_files({ default_text = vim.fn.expand("<cword>") })<CR>

" line search
nnoremap <leader>sil :lua require('telescope.builtin').current_buffer_fuzzy_find()<CR>
nnoremap <leader>fwl :lua require('telescope.builtin').current_buffer_fuzzy_find({ default_text = vim.fn.expand("<cword>") })<CR>

nnoremap <leader>sip :lua require('telescope.builtin').live_grep()<CR>
nnoremap <leader>fwp :lua require('telescope.builtin').live_grep({ default_text = vim.fn.expand("<cword>") })<CR>
" TODO: not cword, but selected text.
xnoremap <leader>fwp :lua require('telescope.builtin').live_grep({ default_text = vim.fn.expand("<cword>") })<CR>

" buffer search
nnoremap <leader>sib :lua require('telescope.builtin').buffers()<CR>

" command search
nnoremap <leader>cmd :lua require('telescope.builtin').commands()<CR>
nnoremap <leader>cmh :lua require('telescope.builtin').command_history()<CR>

" TODO: jump search
