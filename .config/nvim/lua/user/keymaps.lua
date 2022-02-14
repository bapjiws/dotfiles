-- TODO: decide if need it
local term_opts = {silent = true}

local opts = {noremap = true, silent = true}
local keymap = vim.api.nvim_set_keymap

-- Space as leader key
keymap("", "<Space>", "<Nop>", opts)
vim.g.mapleader = " "

-- Clean up the search results
keymap("n", "<Esc>", ":nohlsearch<CR>", opts)

-- Case-insensitive search
keymap("n", "/", "/\\c", opts)

-- Better window navigation
keymap("n", "<C-h>", ":vertical resize +5<CR>", opts)
keymap("n", "<C-j>", ":resize -5<CR>", opts)
keymap("n", "<C-k>", ":resize +5<CR>", opts)
keymap("n", "<C-l>", ":vertical resize -5<CR>", opts)

-- TODO: My keymaps

-- nnoremap , @@

-- augroup source_vimrc_on_save
--   autocmd!
--   autocmd BufWritePost *.vim source $MYVIMRC
-- augroup END

-- nnoremap <leader>mbf :MaximizerToggle<CR>

-- nnoremap * *zz
-- nnoremap # #zz
-- nnoremap N Nzz
-- nnoremap n nzz
-- nnoremap g* g*zz
-- nnoremap g# g#zz

-- nnoremap <C-d> <C-d>zz
-- nnoremap <C-u> <C-u>zz
-- nnoremap <C-f> <C-f>zz
-- nnoremap <C-b> <C-b>zz

-- nnoremap <leader>ipg :PlugInstall<CR>
-- nnoremap <leader>cpg :PlugClean<CR>
-- nnoremap <leader>upg :PlugUpdate<CR>

-- nnoremap <leader>cab :w <bar> %bd <bar> e# <bar> bd# <CR>

-- nnoremap <leader>rpc :%s/<C-r>=printf("%s", expand("<cword>"))<CR>//g<left><left>

-- nnoremap <leader>dff :Gvdiffsplit<CR>
-- nnoremap <leader>dfm :Gvdiffsplit master<CR><c-w>r
-- nnoremap <leader>blf :Git blame<CR>
-- nnoremap <leader>brg :GBrowse<CR>

-- nnoremap <leader>vsc :FloatermNew lazygit<CR>

-- nnoremap <leader>trm :FloatermNew fish<CR>

-- nnoremap <leader>wrt :w<CR>
-- nnoremap <leader>src :source $MYVIMRC<CR>

-- nnoremap <leader>fex :FloatermNew ranger<CR>

-- " To change 2 spaces to a tab 
-- ":%s/\(^\s*\)\@<=    /\t/g

-- TODD: try https://www.reddit.com/r/neovim/comments/jxub94/reload_lua_config/ for reloading
