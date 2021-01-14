call plug#begin('~/.config/nvim/plugged')

" Editing
Plug 'tpope/vim-surround' "https://github.com/tpope/vim-surround
Plug 'mg979/vim-visual-multi', {'branch': 'master'} "https://github.com/mg979/vim-visual-multi
Plug 'tpope/vim-unimpaired' "https://github.com/tpope/vim-unimpaired

" Visuals
Plug 'sainnhe/sonokai' "https://github.com/sainnhe/sonokai
Plug 'vim-airline/vim-airline' "https://github.com/vim-airline/vim-airline
Plug 'vim-airline/vim-airline-themes' "https://github.com/vim-airline/vim-airline-themes
Plug 'Yggdroot/indentLine' "https://github.com/Yggdroot/indentLine

" Navigation
Plug 'airblade/vim-rooter' "https://github.com/airblade/vim-rooter
Plug 'glepnir/dashboard-nvim' "https://github.com/glepnir/dashboard-nvim

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

" Snippets
Plug 'SirVer/ultisnips' "https://github.com/sirver/UltiSnips

" Search
Plug 'nvim-lua/popup.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'

" Floating terminal
Plug 'voldikss/vim-floaterm' "https://github.com/voldikss/vim-floaterm

" Initialize plugin system
call plug#end()

source $HOME/.config/nvim/plugin-config/startify.vim
source $HOME/.config/nvim/plugin-config/floaterm.vim
source $HOME/.config/nvim/plugin-config/blamer.vim
source $HOME/.config/nvim/themes/sonokai.vim
source $HOME/.config/nvim/themes/airline.vim

lua require 'lsp'
"TODO: rework file structure.
lua require 'plugins'	
:lua require'colorizer'.setup()

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

let g:dashboard_default_executive='telescope'
let g:dashboard_default_header='pikachu'

nnoremap <down> <nop>
nnoremap <left> <nop>
nnoremap <right> <nop>
nnoremap <up> <nop>

nnoremap <C-K> :resize +5<CR>
nnoremap <C-J> :resize -5<CR>
nnoremap <C-H> :vertical resize +5<CR>
nnoremap <C-L> :vertical resize -5<CR>

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
  ensure_installed = { "javascript", "typescript", "html", "css", "json", "graphql", "bash", "regex", "yaml", "lua" },
  highlight = {
    enable = true,
  },
}
EOF

"TODO: check if we need these settings left from Coc.
set signcolumn=yes
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

highlight TelescopeMatching       guifg=#16AA65

"TODO: fix.
"TODO: change TODO color to yellow.
highlight LspReferenceRead guibg=#fb571f
highlight CursorLine guibg=#3E4452
:lua << EOF
  vim.api.nvim_command [[autocmd CursorHold  <buffer> lua vim.lsp.buf.document_highlight()]]
  vim.api.nvim_command [[autocmd CursorHoldI <buffer> lua vim.lsp.buf.document_highlight()]]
  vim.api.nvim_command [[autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()]]
EOF

" TODO: make if work.
augroup highlight_yank
    autocmd!
    autocmd TextYankPost * silent! lua require'vim.highlight'.on_yank()
augroup END

sign define LspDiagnosticsSignHint text=ℹ texthl=LspDiagnosticsSignHint linehl= numhl=
sign define LspDiagnosticsSignWarning text=⚠ texthl=LspDiagnosticsSignWarning linehl= numhl=
sign define LspDiagnosticsSignError text=✗ texthl=LspDiagnosticsSignError linehl= numhl=
   
let g:indentLine_char = '│'
au BufRead,BufNewFile *.js,*.jsx set list lcs=tab:\│\ ,eol:↴
let g:indentLine_fileTypeExclude = ['dashboard', 'help', 'vim']

nnoremap [d <cmd>lua vim.lsp.diagnostic.goto_prev()<CR>zz
nnoremap ]d <cmd>lua vim.lsp.diagnostic.goto_next()<CR>zz

nnoremap ]c :GitGutterNextHunk<CR>zz
nnoremap [c :GitGutterPrevHunk<CR>zz

nnoremap <leader>ipg :PlugInstall<CR>
nnoremap <leader>cpg :PlugClean<CR>
nnoremap <leader>upg :PlugUpdate<CR>

nnoremap <leader>sih <cmd>lua require('telescope.builtin').help_tags()<CR>
nnoremap <leader>fwh <cmd>lua require('telescope.builtin').help_tags({ default_text = vim.fn.expand("<cword>") })<CR>

nnoremap <leader>rnm <cmd>lua vim.lsp.buf.rename()<CR>
nnoremap <leader>rpc :%s/<C-r>=printf("%s", expand("<cword>"))<CR>//g<left><left>

nnoremap <leader>fmt :lua vim.lsp.buf.formatting()<CR>

nnoremap <leader>und :GitGutterUndoHunk<CR>
nnoremap <leader>prw :GitGutterPreviewHunk<CR>
nnoremap <leader>fld :GitGutterFold<CR>

nnoremap <leader>dff :Gvdiffsplit<CR>
nnoremap <leader>dfm :Gvdiffsplit master<CR><c-w>r
nnoremap <leader>rst :Gread<CR>
nnoremap <leader>blm :Gblame<CR>
" TODO: find better name.
nnoremap <leader>atp :BlamerToggle<CR>

nnoremap <leader>fcm <cmd>lua require('telescope.builtin').git_bcommits()<CR>
nnoremap <leader>pcm <cmd>lua require('telescope.builtin').git_commits()<CR>

nnoremap <leader>vsc :FloatermNew lazygit<CR>

nnoremap <leader>dfn <cmd>lua vim.lsp.buf.definition()<CR>zz
nnoremap <leader>tdf <cmd>lua vim.lsp.buf.type_definition()<CR>
nnoremap <leader>hov <cmd>lua vim.lsp.buf.hover()<CR>
nnoremap <leader>sgn <cmd>lua vim.lsp.buf.signature_help()<CR>
nnoremap <leader>imp <cmd>lua vim.lsp.buf.implementation()<CR>
nnoremap <leader>rfc <cmd>lua vim.lsp.buf.references()<CR>

nnoremap <leader>trm :FloatermNew zsh<CR>

nnoremap <leader>ssn :SessionSave<CR>
nnoremap <leader>lsn :SessionLoad<CR>

nnoremap <leader>wrt :w<CR>
nnoremap <leader>src :source $MYVIMRC<CR>

nnoremap <leader>fex :FloatermNew ranger<CR>

" TODO: File icons

" file search
nnoremap <leader>sif <cmd>lua require('telescope.builtin').find_files()<CR>
nnoremap <leader>fwf <cmd>lua require('telescope.builtin').find_files({ default_text = vim.fn.expand("<cword>") })<CR>

" line search
nnoremap <leader>sil <cmd>lua require('telescope.builtin').current_buffer_fuzzy_find()<CR>
nnoremap <leader>fwl <cmd>lua require('telescope.builtin').current_buffer_fuzzy_find({ default_text = vim.fn.expand("<cword>") })<CR>

nnoremap <leader>sip <cmd>lua require('telescope.builtin').live_grep()<CR>
nnoremap <leader>fwp <cmd>lua require('telescope.builtin').live_grep({ default_text = vim.fn.expand("<cword>") })<CR>
" TODO: not cword, but selected text.
xnoremap <leader>fwp <cmd>lua require('telescope.builtin').live_grep({ default_text = vim.fn.expand("<cword>") })<CR>

" buffer search
nnoremap <leader>sib <cmd>lua require('telescope.builtin').buffers()<CR>

" command search
nnoremap <leader>cmd <cmd>lua require('telescope.builtin').commands()<CR>
nnoremap <leader>cmh <cmd>lua require('telescope.builtin').command_history()<CR>

" TODO: jump search
