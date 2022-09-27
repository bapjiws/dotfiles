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

keymap("n", "<C-d>", "<C-d>zz", opts)
keymap("n", "<C-u>", "<C-u>zz", opts)
keymap("n", "<C-f>", "<C-f>zz", opts)
keymap("n", "<C-b>", "<C-b>zz", opts)

keymap("n", "*", "*zz", opts)
keymap("n", "#", "#zz", opts)
keymap("n", "N", "Nzz", opts)
keymap("n", "n", "nzz", opts)

keymap("n", "<leader>wrt", ":w<CR>", opts)
keymap("n", "<leader>src", ":source ~/Git/dotfiles/.config/nvim/init.lua<CR>", opts)

keymap("x", "<leader>pst", "\"_dP", opts)

-- TODO: My keymaps
-- " To change 2 spaces to a tab 
-- ":%s/\(^\s*\)\@<=    /\t/g

-- TODD: try https://www.reddit.com/r/neovim/comments/jxub94/reload_lua_config/ for reloading

-- nnoremap , @@

-- augroup source_vimrc_on_save
--   autocmd!
--   autocmd BufWritePost *.vim source $MYVIMRC
-- augroup END

-- TODO: My commands

-- nnoremap <leader>mbf :MaximizerToggle<CR>

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
-- nnoremap <leader>fex :FloatermNew ranger<CR>
