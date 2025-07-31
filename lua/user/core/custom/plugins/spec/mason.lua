-- Configurazione di Mason e Mason LSP
return {
  {
    'williamboman/mason.nvim',
    config = function()
      require('mason').setup({
        ui = {
          icons = {
            package_installed = "✓",
            package_pending = "➜",
            package_uninstalled = "✗"
          }
        }
      })
    end
  },
  {
    'williamboman/mason-lspconfig.nvim',
    config = function()
      require('mason-lspconfig').setup({
        -- Lista dei server LSP da installare automaticamente
        ensure_installed = {
          'lua_ls',      -- Lua
          'pyright',     -- Python
          'clangd',      -- C/C++
          'rust_analyzer', -- Rust
          'html',        -- HTML
          'cssls',       -- CSS
          'jsonls',      -- JSON
          'jdtls',       -- Java (Eclipse JDT Language Server)
          'zls',         -- Zig Language Server
          'nimls',       -- Nim Language Server
        },
        -- Configurazione automatica dei server LSP
        automatic_installation = true,
        -- IMPORTANTE: Configura automaticamente i server per LSPConfig
        handlers = {
          -- Handler di default per tutti i server
          function(server_name)
            require('lspconfig')[server_name].setup({})
          end,
          
          -- Configurazioni specifiche per server particolari
          ['lua_ls'] = function()
            require('lspconfig').lua_ls.setup({
              settings = {
                Lua = {
                  diagnostics = {
                    globals = { 'vim' },
                  },
                  workspace = {
                    library = vim.api.nvim_get_runtime_file("", true),
                  },
                },
              },
            })
          end,
          
          ['pyright'] = function()
            require('lspconfig').pyright.setup({
              settings = {
                python = {
                  analysis = {
                    autoSearchPaths = true,
                    useLibraryCodeForTypes = true,
                    diagnosticMode = "workspace",
                  },
                },
              },
            })
          end,
          
          ['clangd'] = function()
            require('lspconfig').clangd.setup({
              cmd = {
                "clangd",
                "--background-index",
                "--clang-tidy",
                "--header-insertion=iwyu",
                "--completion-style=detailed",
                "--fallback-style=Google",
                "--pch-storage=memory",
                "--log=verbose",
                "--pretty",
                "--cross-file-rename",
                "--compile-commands-dir=.",
                "--query-driver=**",
              },
              filetypes = { "c", "cpp", "objc", "objcpp", "cuda", "proto" },
              init_options = {
                compilationDatabaseDirectory = ".",
                clangdFileStatus = true,
                usePlaceholders = true,
                completeUnimported = true,
                semanticHighlighting = true,
              },
              settings = {
                clangd = {
                  arguments = {
                    "--background-index",
                    "--clang-tidy",
                    "--header-insertion=iwyu",
                    "--completion-style=detailed",
                    "--fallback-style=Google",
                    "--pch-storage=memory",
                    "--log=verbose",
                    "--pretty",
                    "--cross-file-rename",
                    "--compile-commands-dir=.",
                    "--query-driver=**",
                  },
                  compilationDatabaseDirectory = ".",
                  clangdFileStatus = true,
                  usePlaceholders = true,
                  completeUnimported = true,
                  semanticHighlighting = true,
                },
              },
            })
          end,
          
          ['jdtls'] = function()
            require('lspconfig').jdtls.setup({
              cmd = {
                "java",
                "-Declipse.application=org.eclipse.jdt.ls.core.id1",
                "-Dosgi.bundles.defaultStartLevel=4",
                "-Declipse.product=org.eclipse.jdt.ls.core.product",
                "-Dlog.protocol=true",
                "-Dlog.level=ALL",
                "-Xms1g",
                "-Xmx2G",
                "-jar",
                vim.fn.expand("$HOME/.local/share/nvim/mason/packages/jdtls/plugins/org.eclipse.equinox.launcher_*.jar"),
                "-configuration",
                vim.fn.expand("$HOME/.local/share/nvim/mason/packages/jdtls/config_linux"),
                "-data",
                vim.fn.expand("$HOME/.local/share/nvim/mason/packages/jdtls/workspace"),
              },
              filetypes = { "java" },
              root_dir = function(fname)
                return require("lspconfig.util").root_pattern("pom.xml", "gradle.build", ".git")(fname) or
                       require("lspconfig.util").path.dirname(fname)
              end,
              settings = {
                java = {
                  home = vim.fn.expand("$JAVA_HOME"),
                  configuration = {
                    runtimes = {
                      {
                        name = "JavaSE-17",
                        path = vim.fn.expand("$JAVA_HOME"),
                        default = true,
                      },
                    },
                  },
                  maven = {
                    downloadSources = true,
                  },
                  gradle = {
                    downloadSources = true,
                  },
                  completion = {
                    favoriteStaticMembers = {
                      "org.junit.Assert.*",
                      "org.junit.Assume.*",
                      "org.junit.jupiter.api.Assertions.*",
                      "org.junit.jupiter.api.Assumptions.*",
                      "org.junit.jupiter.api.DynamicContainer.*",
                      "org.junit.jupiter.api.DynamicTest.*",
                      "org.mockito.Mockito.*",
                      "org.mockito.ArgumentMatchers.*",
                      "org.mockito.Answers.*",
                    },
                    importOrder = {
                      "java",
                      "javax",
                      "com",
                      "org",
                    },
                  },
                  sources = {
                    organizeImports = {
                      starThreshold = 9999,
                      staticStarThreshold = 9999,
                    },
                  },
                  codeGeneration = {
                    toString = {
                      template = "${object.className} [${member.name()}=${member.value}, ${otherMembers}]",
                    },
                    useBlocks = true,
                  },
                  saveActions = {
                    organizeImports = true,
                  },
                },
              },
              init_options = {
                bundles = {},
              },
            })
          end,
          
          ['rust_analyzer'] = function()
            require('lspconfig').rust_analyzer.setup({
              settings = {
                ['rust-analyzer'] = {
                  cargo = {
                    allFeatures = true,
                  },
                  checkOnSave = {
                    command = "clippy",
                  },
                },
              },
            })
          end,
          
          ['zls'] = function()
            require('lspconfig').zls.setup({
              settings = {
                zls = {
                  -- Abilita l'analisi semantica
                  enable_semantic_tokens = true,
                  -- Abilita l'auto-completamento
                  enable_autofix = true,
                  -- Abilita la diagnostica in tempo reale
                  enable_inlay_hints = true,
                  -- Configurazione per l'inlay hints
                  inlay_hints = {
                    show_parameter_name = true,
                    show_variable_type = true,
                    show_function_return_type = true,
                  },
                  -- Configurazione per la diagnostica
                  diagnostics = {
                    enable = true,
                    exclude = {},
                  },
                  -- Configurazione per il completamento
                  completions = {
                    enable = true,
                    snippets = true,
                  },
                },
              },
            })
          end,
          
          ['nimls'] = function()
            require('lspconfig').nimls.setup({
              settings = {
                nim = {
                  -- Abilita l'analisi semantica
                  enableSemanticTokens = true,
                  -- Abilita l'auto-completamento
                  enableAutoCompletion = true,
                  -- Abilita la diagnostica in tempo reale
                  enableDiagnostics = true,
                  -- Configurazione per il completamento
                  completion = {
                    enable = true,
                    snippets = true,
                  },
                  -- Configurazione per la diagnostica
                  diagnostics = {
                    enable = true,
                    exclude = {},
                  },
                  -- Configurazione per il formattatore
                  formatting = {
                    enable = true,
                  },
                  -- Configurazione per il linter
                  linting = {
                    enable = true,
                  },
                },
              },
            })
          end,
        }
      })
    end
  },
  {
    'jay-babu/mason-null-ls.nvim',
    optional = true,
    config = function()
      require('mason-null-ls').setup({
        automatic_installation = true,
        automatic_setup = true,
      })
    end
  },
} 