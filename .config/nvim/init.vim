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

Plug 'prettier/vim-prettier', { 'do': 'yarn install' }

" Code completion
Plug 'nvim-lua/completion-nvim'

" Snippets
Plug 'SirVer/ultisnips'
Plug 'norcalli/snippets.nvim' "https://github.com/norcalli/snippets.nvim

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

lua require 'plugins'

"local map = function(type, key, value)
"	vim.fn.nvim_buf_set_keymap(0,type,key,value,{noremap = true, silent = true});
"end
"
"local custom_attach = function(client)
"	print("LSP started.");
"	require'completion'.on_attach(client)
"
"	map('i','<c-space>','<cmd>lua vim.lsp.buf.completion()<CR>')
"end
"EOF

"https://github.com/neovim/nvim-lspconfig/blob/master/CONFIG.md#tsserver
:lua << EOF
  require'lspconfig'.tsserver.setup{on_attach=require'completion'.on_attach}
EOF

"https://github.com/iamcco/diagnostic-languageserver/wiki/Linters#eslint
:lua << EOF
require'lspconfig'.diagnosticls.setup{
  filetypes = { "javascript", "javascript.jsx" },
  init_options = {
    filetypes = {
      javascript = "eslint",
      ["javascript.jsx"] = "eslint",
      javascriptreact = "eslint",
      typescriptreact = "eslint",
    },
    linters = {
      eslint = {
        sourceName = "eslint",
        command = "./node_modules/.bin/eslint",
        rootPatterns = { ".git" },
        debounce = 100,
        args = {
          "--stdin",
          "--stdin-filename",
          "%filepath",
          "--format",
          "json",
        },
        parseJson = {
          errorsRoot = "[0].messages",
          line = "line",
          column = "column",
          endLine = "endLine",
          endColumn = "endColumn",
          message = "${message} [${ruleId}]",
          security = "severity",
        };
        securities = {
          [2] = "error",
          [1] = "warning"
        }
      }
    }
  }
}
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
" Don't pass messages to |ins-completion-menu|.
set shortmess+=c

" Use <Tab> and <S-Tab> to navigate through popup menu
inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

" Set completeopt to have a better completion experience
set completeopt=menuone,noinsert,noselect

" Avoid showing message extra message when using completion
set shortmess+=c

" Use completion-nvim in every buffer
autocmd BufEnter * lua require'completion'.on_attach()

" possible value: 'UltiSnips', 'Neosnippet', 'vim-vsnip', 'snippets.nvim'
let g:completion_enable_snippet = 'snippets.nvim'

" Trigger configuration. You need to change this to something other than <tab> if you use one of the following:
" - https://github.com/Valloric/YouCompleteMe
" - https://github.com/nvim-lua/completion-nvim
let g:UltiSnipsExpandTrigger="<c-space>"
let g:UltiSnipsJumpForwardTrigger="<c-b>"
let g:UltiSnipsJumpBackwardTrigger="<c-z>"

lua require'snippets'.use_suggested_mappings()

:lua << EOF
require'snippets'.snippets = {
  -- The _global dictionary acts as a global fallback.
  -- If a key is not found for the specific filetype, then
  --  it will be lookup up in the _global dictionary.
  _global = {
    clg = "console.log();";
    clo = "console.log(':', );";

    -- Insert a basic snippet, which is a string.
    todo = "TODO(ashkan): ";

    uname = function() return vim.loop.os_uname().sysname end;
    date = os.date;

    -- Evaluate at the time of the snippet expansion and insert it. You
    --  can put arbitrary lua functions inside of the =... block as a
    --  dynamic placeholder. In this case, for an anonymous variable
    --  which doesn't take user input and is evaluated at the start.
    epoch = "${=os.time()}";
    -- Equivalent to above.
    epoch = function() return os.time() end;

    -- Use the expansion to read the username dynamically.
    note = [[NOTE(${=io.popen("id -un"):read"*l"}): ]];

    -- Do the same as above, but by using $1, we can make it user input.
    -- That means that the user will be prompted at the field during expansion.
    -- You can *EITHER* specify an expression as a placeholder for a variable
    --  or a literal string/snippet using `${var:...}`, but not both.
    note = [[NOTE(${1=io.popen("id -un"):read"*l"}): ]];
  };
}
EOF

"inoremap <silent><expr> <TAB>
"      \ pumvisible() ? "\<C-n>" :
"      \ <SID>check_back_space() ? "\<TAB>" :
"      \ coc#refresh()
"inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"
"
"function! s:check_back_space() abort
"  let col = col('.') - 1
"  return !col || getline('.')[col - 1]  =~# '\s'
"endfunction

" Trigger completion.
"inoremap <silent><expr> <c-space> coc#refresh()
"inoremap <expr> <c-space> lua vim.lsp.buf.completion()<CR>

" Use <CR> to confirm completion, `<C-g>u` means break undo chain at current
" position. Coc only does snippet and additional edit on confirm.
"if exists('*complete_info')
"  inoremap <expr> <CR> complete_info()["selected"] != "-1" ? "\<C-y>" : "\<C-g>u\<CR>"
"else
"  imap <expr> <CR> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
"endif

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

  "diagnostic.infoSign": "ℹ",
  "diagnostic.warningSign": "⚠",
  "diagnostic.errorSign": "✗",
  
"    sign define LspDiagnosticsSignError text=E texthl=LspDiagnosticsSignError linehl= numhl=
"    sign define LspDiagnosticsSignWarning text=W texthl=LspDiagnosticsSignWarning linehl= numhl=
"    sign define LspDiagnosticsSignInformation text=I texthl=LspDiagnosticsSignInformation linehl= numhl=
"    sign define LspDiagnosticsSignHint text=H texthl=LspDiagnosticsSignHint linehl= numhl=
"
sign define LspDiagnosticsSignHint text=ℹ texthl=LspDiagnosticsSignHint linehl= numhl=
sign define LspDiagnosticsSignError text=✗ texthl=LspDiagnosticsSignError linehl= numhl=
    
nnoremap <leader>dgn :<C-u>CocList diagnostics<CR>
nnoremap [d <cmd>lua vim.lsp.diagnostic.goto_prev()<CR>zz
nnoremap ]d <cmd>lua vim.lsp.diagnostic.goto_next()<CR>zz

nnoremap ]c :GitGutterNextHunk<CR>zz
nnoremap [c :GitGutterPrevHunk<CR>zz

nnoremap <leader>ipg :PlugInstall<CR>
nnoremap <leader>cpg :PlugClean<CR>
nnoremap <leader>upg :PlugUpdate<CR>

nnoremap <leader>hlp :Clap help_tags<CR>

nnoremap <leader>rnm <cmd>lua vim.lsp.buf.rename()<CR>
nnoremap <leader>rpc :%s/<C-r>=printf("%s", expand("<cword>"))<CR>//g<left><left>

nnoremap <leader>fmt :Prettier<CR>

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
