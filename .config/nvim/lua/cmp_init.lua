local cmp = require'cmp'

cmp.setup({
  snippet = {
    expand = function(args)
      vim.fn["UltiSnips#Anon"](args.body)
    end,
  },
  mapping = {
    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.close(),
    ['<CR>'] = cmp.mapping.confirm({ select = true }),
  },
  sources = {
    { name = 'nvim_lsp' },
    { name = 'ultisnips' },
    { name = 'buffer' },
    { name = 'path' },
    { name = 'nvim_lua' },
  },
  formatting = {
  format = function(entry, vim_item)
      -- vim_item.menu = ({
      --   nvim_lsp = '',
      --   buffer   = '',
      -- })[entry.source.name]
      vim_item.kind = ({
        Text          = '  ',
        Method        = '  ',
        Function      = '  ',
        Constructor   = '  ',
        Field         = '  ',
        Variable      = '  ',
        Class         = '  ',
        Interface     = ' ﰮ ',
        Module        = '  ',
        Property      = '  ',
        Unit          = '  ',
        Value         = '  ',
        Enum          = '  ',
        Keyword       = '  ',
        Snippet       = ' ﬌ ',
        Color         = '  ',
        File          = '  ',
        Reference     = '  ',
        Folder        = '  ',
        EnumMember    = '  ',
        Constant      = '  ',
        Struct        = '  ',
        Event         = '  ',
        Operator      = ' ﬦ ',
        TypeParameter = '  ',
      })[vim_item.kind]
      return vim_item
    end
  },
})
