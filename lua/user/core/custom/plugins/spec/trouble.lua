-- Installazione di trouble.nvim per la gestione della diagnostica
return {
  {
    'folke/trouble.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
      require('user.core.custom.configs.spec.trouble')
    end,
  },
} 