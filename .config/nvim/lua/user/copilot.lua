require("CopilotChat").setup {
  agent = 'copilot',
  mappings = {
    reset = {
      normal = '<C-x>',
      insert = '<C-x>',
    },
  }
}
