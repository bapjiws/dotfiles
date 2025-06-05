require("CopilotChat").setup {
  -- See Configuration section for options
  agent = 'copilot',
  mappings = {
    reset = {
      normal = '<C-x>',
      insert = '<C-x>',
    },
  }
}
