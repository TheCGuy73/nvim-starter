-- Configurazione di base per nvim-cmp
local cmp = require('cmp')

local source_names = {
  nvim_lsp = '[LSP]',
  luasnip = '[Snippet]',
  buffer = '[Buffer]',
  path = '[Path]',
  cmdline = '[Cmd]',
}

cmp.setup({
  snippet = {
    expand = function(args)
      require('luasnip').lsp_expand(args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<CR>'] = cmp.mapping.confirm({ select = true }),
  }),
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
    { name = 'buffer' },
    { name = 'path' },
  }),
  formatting = {
    format = function(entry, vim_item)
      vim_item.menu = source_names[entry.source.name] or ('[' .. entry.source.name .. ']')
      return vim_item
    end,
  },
})

-- Completamento per la command-line (/:)
cmp.setup.cmdline('/', {
  mapping = cmp.mapping.preset.cmdline(),
  sources = {
    { name = 'buffer' }
  },
  formatting = {
    format = function(entry, vim_item)
      vim_item.menu = source_names[entry.source.name] or ('[' .. entry.source.name .. ']')
      return vim_item
    end,
  },
})

cmp.setup.cmdline(':', {
  mapping = cmp.mapping.preset.cmdline(),
  sources = cmp.config.sources({
    { name = 'path' }
  }, {
    { name = 'cmdline' }
  }),
  formatting = {
    format = function(entry, vim_item)
      vim_item.menu = source_names[entry.source.name] or ('[' .. entry.source.name .. ']')
      return vim_item
    end,
  },
}) 