call plug#begin('~/.config/nvim/plugged')

" Editing
Plug 'tpope/vim-surround' "https://github.com/tpope/vim-surround
Plug 'mg979/vim-visual-multi', {'branch': 'master'} "https://github.com/mg979/vim-visual-multi

" Visual stuff
Plug 'sainnhe/sonokai' "https://github.com/sainnhe/sonokai
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
" TODO: consider https://github.com/nvim-treesitter/nvim-treesitter
Plug 'sheerun/vim-polyglot' "https://github.com/sheerun/vim-polyglot
" TODO: do we need it?
Plug 'styled-components/vim-styled-components', { 'branch': 'main' }

" Code completion

" LSP for Telescope
Plug 'neovim/nvim-lspconfig'

" Search
Plug 'liuchengxu/vim-clap', { 'do': ':Clap install-binary!' }

" Telescope
Plug 'nvim-lua/popup.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'

" Floating terminal
Plug 'voldikss/vim-floaterm' "https://github.com/voldikss/vim-floaterm

" Initialize plugin system
call plug#end()

source $HOME/.config/nvim/plugin-config/startify.vim
source $HOME/.config/nvim/plugin-config/clap.vim
source $HOME/.config/nvim/plugin-config/floaterm.vim
source $HOME/.config/nvim/plugin-config/nerdtree.vim
source $HOME/.config/nvim/plugin-config/blamer.vim
source $HOME/.config/nvim/themes/sonokai.vim
source $HOME/.config/nvim/themes/airline.vim

highlight TelescopeMatching       guifg=#16AA65

" TODO: lua require'plugins'
:lua << EOF
local actions = require('telescope.actions')

require('telescope').setup{
  defaults = {
    mappings = {
      i = {
        ["<C-j>"] = actions.move_selection_next,
        ["<C-k>"] = actions.move_selection_previous,
        ["<esc>"] = actions.close,
      },
      n = {
        ["<C-j>"] = actions.move_selection_next,
        ["<C-k>"] = actions.move_selection_previous,
        ["<esc>"] = actions.close,
      },
    },
    vimgrep_arguments = {
      'rg',
      '--color=auto',
      '--no-heading',
      '--with-filename',
      '--line-number',
      '--column',
      '--ignore-case'
    },
    prompt_position = "bottom",
    prompt_prefix = ">",
    selection_strategy = "reset",
    sorting_strategy = "descending",
    layout_strategy = "horizontal",
    layout_defaults = {
      -- TODO add builtin options.
    },
    file_sorter =  require'telescope.sorters'.get_fuzzy_file,
    file_ignore_patterns = {},
    generic_sorter =  require'telescope.sorters'.get_generic_fuzzy_sorter,
    shorten_path = true,
    winblend = 0,
    width = 0.75,
    preview_cutoff = 120,
    results_height = 1,
    results_width = 0.8,
    border = {},
    borderchars = { '─', '│', '─', '│', '╭', '╮', '╯', '╰'},
    color_devicons = true,
    use_less = true,
    set_env = { ['COLORTERM'] = 'truecolor' }, -- default { }, currently unsupported for shells like cmd.exe / powershell.exe
    file_previewer = require'telescope.previewers'.vim_buffer_cat.new,
    grep_previewer = require'telescope.previewers'.vim_buffer_vimgrep.new,
    qflist_previewer = require'telescope.previewers'.vim_buffer_qflist.new,
  }
}
EOF

"https://github.com/neovim/nvim-lspconfig/blob/master/CONFIG.md#tsserver
:lua << EOF
  require'lspconfig'.tsserver.setup{}
EOF

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

nnoremap <leader>hlp :Clap help_tags<CR>

nnoremap <leader>rnm <cmd>lua vim.lsp.buf.rename()<CR>
nnoremap <leader>rpc :%s/<C-r>=printf("%s", expand("<cword>"))<CR>//g<left><left>

nnoremap <leader>fmt :CocCommand prettier.formatFile<CR>
nnoremap <leader>oim :CocCommand editor.action.organizeImport<CR>

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

nnoremap <leader>vsc :FloatermNew lazygit<CR>

nnoremap <leader>dfn <cmd>lua vim.lsp.buf.definition()<CR>zz
nnoremap <leader>tdf <cmd>lua vim.lsp.buf.type_definition()<CR>
nnoremap <leader>hov <cmd>lua vim.lsp.buf.hover()<CR>
nnoremap <leader>sgn <cmd>lua vim.lsp.buf.signature_help()<CR>
nnoremap <leader>imp <cmd>lua vim.lsp.buf.implementation()<CR>
"nnoremap <leader>rfc <cmd>lua vim.lsp.buf.references()<CR>
nnoremap <leader>rfc :Telescope lsp_references<CR>

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
nnoremap <leader>fwf2 <cmd>lua require('telescope.builtin').find_files({ default_text = vim.fn.expand("<cword>") })<CR>

" line search
nnoremap <leader>sil :Clap blines<CR>
nnoremap <leader>fwl :Clap blines ++query=<cword><CR>

nnoremap <leader>sip :Clap grep<CR>
nnoremap <leader>sip2 <cmd>lua require('telescope.builtin').live_grep()<CR>
nnoremap <leader>fwp :Clap grep ++query=<cword><CR>
xnoremap <leader>fwp :Clap grep ++query=@visual<CR>
nnoremap <leader>fwp2 <cmd>lua require('telescope.builtin').live_grep({ default_text = vim.fn.expand("<cword>") })<CR>

" buffer search
nnoremap <leader>sib :Clap buffers<CR>

" command search
nnoremap <leader>cmd :Clap command<CR>
nnoremap <leader>cmh :Clap command_history<CR>
