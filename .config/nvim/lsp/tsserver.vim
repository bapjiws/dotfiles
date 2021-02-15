--https://github.com/neovim/nvim-lspconfig/blob/master/CONFIG.md#tsserver
require'lspconfig'.tsserver.setup{on_attach=require'completion'.on_attach}
