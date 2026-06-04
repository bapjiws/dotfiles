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

vim.keymap.set("n", "<S-x>", function() Snacks.bufdelete() end, { noremap = true, silent = true, desc = "Close buffer" })
