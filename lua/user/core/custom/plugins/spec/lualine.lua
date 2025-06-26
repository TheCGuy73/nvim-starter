-- Installazione di lualine.nvim con caricamento della configurazione custom
return {
  {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons', lazy = true },
    config = function()
      require('user.core.custom.configs.spec.lualine')
    end,
  },
}