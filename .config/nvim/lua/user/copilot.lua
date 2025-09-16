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
