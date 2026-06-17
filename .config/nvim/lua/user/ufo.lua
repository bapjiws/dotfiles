local ok, ufo = pcall(require, "ufo")
if not ok then return end

local ok_sc, statuscol = pcall(require, "statuscol")
if ok_sc then
  local builtin = require("statuscol.builtin")
  statuscol.setup({
    relculright = true,
    segments = {
      { text = { builtin.foldfunc }, click = "v:lua.ScFa" },
      { text = { "%s" },            click = "v:lua.ScSa" },
      { text = { builtin.lnumfunc, " " }, click = "v:lua.ScLa" },
    },
  })
end

ufo.setup()

vim.keymap.set("n", "K", function()
  local winid = ufo.peekFoldedLinesUnderCursor()
  if not winid then
    vim.lsp.buf.hover()
  end
end, { desc = "Peek fold / hover" })
