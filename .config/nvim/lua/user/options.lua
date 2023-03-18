-- Set highlight on search
vim.o.hlsearch = true

-- Make line numbers default
vim.wo.number = true
-- highlight the current line
vim.opt.cursorline = true 

-- Enable mouse mode
vim.o.mouse = 'a'

-- Sync clipboard between OS and Neovim.
vim.o.clipboard = 'unnamedplus'

-- Enable break indent
vim.o.breakindent = true

-- Save undo history
vim.o.undofile = true

-- Case insensitive searching unless /C or capital in search
vim.o.ignorecase = true
vim.o.smartcase = true

-- Keep signcolumn on by default
vim.wo.signcolumn = 'yes'

-- Decrease update time
vim.o.updatetime = 250
vim.o.timeout = true
vim.o.timeoutlen = 300

-- Set completeopt to have a better completion experience
vim.o.completeopt = 'menuone,noselect'

-- Make sure your terminal supports this
vim.o.termguicolors = true

-- Force all horizontal splits to go below current window
vim.o.splitbelow = true
-- Force all vertical splits to go to the right of current window
vim.o.splitright = true                       

-- Convert tabs to spaces
vim.o.expandtab = true
-- The number of spaces inserted for each indentation
vim.o.shiftwidth = 2 
-- Insert 2 spaces for a tab
vim.o.tabstop = 2                     
