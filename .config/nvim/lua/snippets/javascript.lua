local ls  = require("luasnip")
local s   = ls.snippet
local i   = ls.insert_node
local t   = ls.text_node
local rep = require("luasnip.extras").rep

local snips = {
  s("clg", {
    t("console.log('"), i(1), t("');"),
  }),
  s("clo", {
    t("console.log('"), i(1, "label"), t("', "), rep(1), t(");"),
  }),
}

for _, ft in ipairs({ "javascript", "typescript", "javascriptreact", "typescriptreact" }) do
  ls.add_snippets(ft, snips)
end
