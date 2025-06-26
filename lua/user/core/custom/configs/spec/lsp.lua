-- Configurazione di base per nvim-lspconfig
local lspconfig = require('lspconfig')

-- Esempio: Python (pyright)
lspconfig.pyright.setup {}

-- Esempio: Lua (lua_ls)
lspconfig.lua_ls.setup {
  settings = {
    Lua = {
      diagnostics = {
        globals = { 'vim' },
      },
    },
  },
}

-- Esempio: C/C++ (clangd)
lspconfig.clangd.setup {} 