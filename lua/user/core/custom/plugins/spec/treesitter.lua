-- Configurazione di nvim-treesitter
return {
  {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    dependencies = {
      'nvim-treesitter/nvim-treesitter-textobjects',
      'nvim-treesitter/nvim-treesitter-context',
      'windwp/nvim-ts-autotag',
    },
    config = function()
      require('nvim-treesitter.configs').setup({
        -- Parser da installare
        ensure_installed = {
          "lua",
          "vim",
          "vimdoc",
          "javascript",
          "typescript",
          "html",
          "css",
          "json",
          "yaml",
          "markdown",
          "python",
          "bash",
          "c",
          "cpp",
          "java",
          "go",
          "rust",
          "php",
          "ruby",
          "sql",
          "xml",
          "toml",
          "dockerfile",
          "gitignore",
          "norg", -- Parser per Neorg
          "zig", -- Parser per Zig
        },
        
        -- Abilita l'highlighting della sintassi
        highlight = {
          enable = true,
          additional_vim_regex_highlighting = false,
        },
        
        -- Abilita l'indentazione automatica
        indent = {
          enable = true,
        },
        
        -- Abilita l'incremento/decremento intelligente
        incremental_selection = {
          enable = true,
          keymaps = {
            init_selection = '<CR>',
            node_incremental = '<CR>',
            node_decremental = '<BS>',
            scope_incremental = '<TAB>',
          },
        },
        
        -- Configurazione per textobjects
        textobjects = {
          select = {
            enable = true,
            lookahead = true,
            keymaps = {
              ['af'] = '@function.outer',
              ['if'] = '@function.inner',
              ['ac'] = '@class.outer',
              ['ic'] = '@class.inner',
              ['aa'] = '@parameter.outer',
              ['ia'] = '@parameter.inner',
            },
          },
          move = {
            enable = true,
            set_jumps = true,
            goto_next_start = {
              [']m'] = '@function.outer',
              [']]'] = '@class.outer',
            },
            goto_next_end = {
              [']M'] = '@function.outer',
              [']['] = '@class.outer',
            },
            goto_previous_start = {
              ['[m'] = '@function.outer',
              ['[['] = '@class.outer',
            },
            goto_previous_end = {
              ['[M'] = '@function.outer',
              ['[]'] = '@class.outer',
            },
          },
        },
        
        -- Abilita l'autotag per HTML/JSX
        autotag = {
          enable = true,
        },
        
        -- Configurazione per il contesto
        context_commentstring = {
          enable = true,
        },
        
        -- Abilita il playground (opzionale)
        playground = {
          enable = false,
        },
        
        -- Abilita query per refactoring
        refactor = {
          highlight_definitions = {
            enable = true,
            clear_on_cursor_move = true,
          },
          highlight_current_scope = {
            enable = false,
          },
        },
      })
    end,
  },
}
