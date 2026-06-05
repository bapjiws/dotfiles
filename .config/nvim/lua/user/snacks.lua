-- snacks.picker keymaps (replaces telescope.nvim)
local map = vim.keymap.set
local opts = { noremap = true, silent = true }

map("n", "<leader>sif", function() Snacks.picker.files({ hidden = true }) end,                                     vim.tbl_extend("force", opts, { desc = "Find files" }))
map("n", "<leader>fwf", function() Snacks.picker.files({ hidden = true, pattern = vim.fn.expand("<cword>") }) end, vim.tbl_extend("force", opts, { desc = "Find files (cword)" }))

map("n", "<leader>sip", function() Snacks.picker.grep() end,       vim.tbl_extend("force", opts, { desc = "Grep" }))
map("n", "<leader>fwp", function() Snacks.picker.grep_word() end,  vim.tbl_extend("force", opts, { desc = "Grep (cword)" }))
local function grep_quoted(quote)
  local line    = vim.fn.getline(".")
  local pattern = quote .. "[^" .. quote .. "]+" .. quote
  local s       = string.find(line, pattern)
  local search  = ""
  if s then
    local e = string.find(line, quote, s + 1)
    if e then search = string.sub(line, s + 1, e - 1) end
  end
  Snacks.picker.grep({ search = search })
end

map("n", "<leader>fqp", function() grep_quoted('"') end, vim.tbl_extend("force", opts, { desc = "Grep double-quoted string" }))
map("n", "<leader>fqs", function() grep_quoted("'") end, vim.tbl_extend("force", opts, { desc = "Grep single-quoted string" }))

map("n", "<leader>sib", function() Snacks.picker.buffers() end,         vim.tbl_extend("force", opts, { desc = "Buffers" }))
map("n", "<leader>cmh", function() Snacks.picker.command_history() end, vim.tbl_extend("force", opts, { desc = "Command history" }))

map("n", "<leader>sih", function() Snacks.picker.help() end,                                                    vim.tbl_extend("force", opts, { desc = "Help" }))
map("n", "<leader>fwh", function() Snacks.picker.help({ pattern = vim.fn.expand("<cword>") }) end,              vim.tbl_extend("force", opts, { desc = "Help (cword)" }))

map("n", "<leader>rfc", function() Snacks.picker.lsp_references() end, vim.tbl_extend("force", opts, { desc = "LSP references" }))
map("n", "<leader>vst", function() Snacks.picker.git_status() end,     vim.tbl_extend("force", opts, { desc = "Git status" }))

-- Buffer
map("n", "<S-x>", function() Snacks.bufdelete() end, vim.tbl_extend("force", opts, { desc = "Close buffer" }))

-- Terminal / tools
map("n", "<leader>vct", function() Snacks.lazygit() end,          vim.tbl_extend("force", opts, { desc = "Lazygit" }))
map("n", "<leader>fex", function() Snacks.terminal("ranger") end, vim.tbl_extend("force", opts, { desc = "File explorer (ranger)" }))
map("n", "<leader>trm", function() Snacks.terminal("fish") end,   vim.tbl_extend("force", opts, { desc = "Terminal" }))

-- Git
map("n", "<leader>blg", function() Snacks.git.blame_line() end, vim.tbl_extend("force", opts, { desc = "Git log for line" }))

-- GitHub (requires gh CLI authenticated)
map("n", "<leader>ghi", function() Snacks.picker.gh_issue() end,                    vim.tbl_extend("force", opts, { desc = "Issues (open)" }))
map("n", "<leader>ghI", function() Snacks.picker.gh_issue({ state = "all" }) end,   vim.tbl_extend("force", opts, { desc = "Issues (all)" }))
map("n", "<leader>ghp", function() Snacks.picker.gh_pr() end,                       vim.tbl_extend("force", opts, { desc = "Pull requests (open)" }))
map("n", "<leader>ghP", function() Snacks.picker.gh_pr({ state = "all" }) end,      vim.tbl_extend("force", opts, { desc = "Pull requests (all)" }))
