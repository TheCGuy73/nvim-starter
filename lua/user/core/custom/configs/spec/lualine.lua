-- Configurazione di base per lualine con icona dinamica del sistema operativo
require('lualine').setup({
  options = {
    theme = 'auto',
    section_separators = '',
    component_separators = '',
  },
  sections = {
    lualine_a = {
      function()
        if vim.fn.has('win32') == 1 then
          return '' -- Windows
        elseif vim.fn.has('macunix') == 1 then
          return '' -- Mac
        else
          return '' -- Linux
        end
      end,
      'mode',
    },
    lualine_b = {'branch', 'diff', 'diagnostics'},
    lualine_c = {'filename'},
    lualine_x = {'encoding', 'fileformat', 'filetype'},
    lualine_y = {'progress'},
    lualine_z = {'location'},
  },
}) 