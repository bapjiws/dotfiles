-- Neovim 0.12: treesitter highlighting is built-in, no .configs.setup needed.
-- This file handles: parser installation, indentation, incremental selection.

local ok, ts = pcall(require, "nvim-treesitter")
if not ok then return end

-- Install any parsers that aren't already present
local installed = require("nvim-treesitter.config").get_installed()
local wanted = {
  "bash", "css", "dockerfile", "fish", "graphql", "html",
  "javascript", "json", "lua", "regex", "tsx", "typescript",
  "vim", "yaml",
}
local missing = vim.tbl_filter(function(p)
  return not vim.tbl_contains(installed, p)
end, wanted)
if #missing > 0 then
  ts.install(missing)
end

-- Treesitter-powered indentation
vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("UserTreesitterIndent", { clear = true }),
  callback = function()
    if pcall(vim.treesitter.get_parser, 0) then
      vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
    end
  end,
})

-- Textobjects — standalone setup (nvim-treesitter.configs no longer exists)
local ok_to, textobjects = pcall(require, "nvim-treesitter-textobjects")
if ok_to then
  textobjects.setup({
    select = {
      enable = true,
      lookahead = true,
      keymaps = {
        ["ab"] = { query = "@block.outer",    desc = "Around block" },
        ["ib"] = { query = "@block.inner",    desc = "Inner block" },
      },
    },
  })
end

-- Incremental selection using built-in vim.treesitter API
-- ]v: start on smallest node, then expand outward. [v: shrink back.
local _sel_stack = {}

local function select_node(node)
  local sr, sc, er, ec = node:range()
  -- node:range() → 0-indexed rows, 0-indexed cols, end col exclusive.
  -- setpos expects 1-indexed row and 1-indexed col.
  local end_row, end_col
  if ec == 0 then
    -- node ends exactly at the start of the next line → select to end of er-1
    end_row = er      -- already 1-indexed (er is 0-indexed line AFTER the node)
    end_col = #vim.fn.getline(er)
  else
    end_row = er + 1
    end_col = ec      -- exclusive 0-indexed = inclusive 1-indexed last char
  end
  vim.fn.setpos("'<", { 0, sr + 1, sc + 1, 0 })
  vim.fn.setpos("'>", { 0, end_row, end_col, 0 })
  vim.cmd("normal! gv")
end

vim.keymap.set("n", "]v", function()
  _sel_stack = {}
  pcall(vim.treesitter.start)  -- ensure parser is active for this buffer
  local node = vim.treesitter.get_node()
  if not node then
    vim.notify("No treesitter node at cursor", vim.log.levels.WARN)
    return
  end
  table.insert(_sel_stack, node)
  select_node(node)
end, { desc = "Treesitter: start selection" })

vim.keymap.set("x", "]v", function()
  local top = _sel_stack[#_sel_stack]
  if not top then return end
  local parent = top:parent()
  if not parent then return end
  table.insert(_sel_stack, parent)
  select_node(parent)
end, { desc = "Treesitter: expand selection" })

vim.keymap.set("x", "[v", function()
  if #_sel_stack <= 1 then return end
  table.remove(_sel_stack)
  local prev = _sel_stack[#_sel_stack]
  if prev then select_node(prev) end
end, { desc = "Treesitter: shrink selection" })
