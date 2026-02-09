local status_ok, illuminate = pcall(require, "illuminate")
if not status_ok then
  return
end

illuminate.configure({
  disable_keymaps = true,
})

-- Set custom keymaps for navigation
vim.keymap.set('n', ']w', function()
  require('illuminate').goto_next_reference(true)
end, {noremap=true, silent=true, desc="Next reference"})

vim.keymap.set('n', '[w', function()
  require('illuminate').goto_prev_reference(true)
end, {noremap=true, silent=true, desc="Previous reference"})
