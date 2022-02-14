local opts = { noremap = true, silent = true }

local term_opts = { silent = true }

-- Shorten function name
local keymap = vim.api.nvim_set_keymap

--Remap space as leader key
keymap("", "<Space>", "<Nop>", opts)
vim.g.mapleader = " "


-- TODO: My keymaps

-- " Clean up the search results. 
-- nnoremap <esc> :noh<cr>
-- " Case-insensitive search.
-- nnoremap / /\c
-- " Search for visually selected text.
-- vnoremap // y/\V<C-R>=escape(@",'/\')<CR><CR>

-- nnoremap , @@

-- augroup source_vimrc_on_save
--   autocmd!
--   autocmd BufWritePost *.vim source $MYVIMRC
-- augroup END

-- nnoremap <down> <nop>
-- nnoremap <left> <nop>
-- nnoremap <right> <nop>
-- nnoremap <up> <nop>

-- nnoremap <C-K> :resize +5<CR>
-- nnoremap <C-J> :resize -5<CR>
-- nnoremap <C-H> :vertical resize +5<CR>
-- nnoremap <C-L> :vertical resize -5<CR>
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
