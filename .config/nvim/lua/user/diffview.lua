local map = vim.keymap.set
local opts = { noremap = true, silent = true }

map("n", "<leader>dvo", "<cmd>DiffviewOpen<cr>",             vim.tbl_extend("force", opts, { desc = "Diffview: working tree" }))
map("n", "<leader>dvb", "<cmd>DiffviewOpen origin/HEAD<cr>", vim.tbl_extend("force", opts, { desc = "Diffview: diff vs base branch" }))
map("n", "<leader>dvh", "<cmd>DiffviewFileHistory %<cr>",    vim.tbl_extend("force", opts, { desc = "Diffview: file history" }))
map("n", "<leader>dvH", "<cmd>DiffviewFileHistory<cr>",      vim.tbl_extend("force", opts, { desc = "Diffview: branch history" }))
map("n", "<leader>dvc", "<cmd>DiffviewClose<cr>",            vim.tbl_extend("force", opts, { desc = "Diffview: close" }))
