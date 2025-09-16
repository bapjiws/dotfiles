require("CopilotChat").setup {
  agent = 'copilot',
  mappings = {
    reset = {
      normal = '<C-x>',
      insert = '<C-x>',
    },
  }
}

vim.keymap.set('n', '<leader>cbc', function()
  local input = vim.fn.input("Quick Chat: ")
  if input ~= "" then
    require("CopilotChat").ask("#buffer " .. input)
  end
end, { desc = "CopilotChat - Quick chat" })

vim.g.copilot_no_tab_map = true
vim.keymap.set('i', '<S-Tab>', 'copilot#Accept("\\<S-Tab>")', { expr = true, replace_keycodes = false })
