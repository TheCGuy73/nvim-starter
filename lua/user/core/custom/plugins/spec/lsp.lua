-- Installazione di nvim-lspconfig e server LSP di esempio
return {
  {
    'neovim/nvim-lspconfig',
    dependencies = {
      'williamboman/mason.nvim',
      'williamboman/mason-lspconfig.nvim',
    },
  },
  {
    'williamboman/mason.nvim',
    -- build = ':MasonUpdate', -- RIMOSSO: causa errori in fase di build
  },
  {
    'williamboman/mason-lspconfig.nvim',
  },
  {
    'jay-babu/mason-null-ls.nvim',
    optional = true,
  },
  -- Server LSP installabili tramite Mason: pyright, lua_ls, clangd
} 