-- Configurazioni aggiuntive per Mason
-- La configurazione principale è gestita nel file del plugin
-- Questo file serve per configurazioni aggiuntive e comandi

-- Funzione per configurare i server LSP con impostazioni di base
-- (Questa funzione è già definita nel plugin, ma la manteniamo qui per comandi personalizzati)
local function setup_lsp_server(server_name, config)
  config = config or {}
  
  -- Configurazione di base per tutti i server
  local default_config = {
    capabilities = require('cmp_nvim_lsp').default_capabilities(),
    on_attach = function(client, bufnr)
      -- Mappings locali per il buffer
      local opts = { noremap = true, silent = true, buffer = bufnr }
      
      -- Navigazione
      vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
      vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
      vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
      vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
      
      -- Azioni
      vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
      vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, opts)
      vim.keymap.set('n', '<leader>f', vim.lsp.buf.format, opts)
      
      -- Diagnostica
      vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
      vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
      vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, opts)
    end
  }
  
  -- Unisci la configurazione di default con quella specifica
  for k, v in pairs(config) do
    default_config[k] = v
  end
  
  require('lspconfig')[server_name].setup(default_config)
end

-- Funzione per generare compile_commands.json con CMake
local function generate_compile_commands()
  local cwd = vim.fn.getcwd()
  local cmake_build_dir = cwd .. "/build"
  
  -- Crea la directory build se non esiste
  if vim.fn.isdirectory(cmake_build_dir) == 0 then
    vim.fn.mkdir(cmake_build_dir, "p")
  end
  
  -- Genera compile_commands.json
  local cmd = string.format("cd %s && cmake -DCMAKE_EXPORT_COMPILE_COMMANDS=ON ..", cmake_build_dir)
  local result = vim.fn.system(cmd)
  
  if vim.v.shell_error == 0 then
    -- Copia compile_commands.json nella root del progetto
    local copy_cmd = string.format("cp %s/compile_commands.json %s/", cmake_build_dir, cwd)
    vim.fn.system(copy_cmd)
    print("✅ compile_commands.json generato con successo!")
  else
    print("❌ Errore nella generazione di compile_commands.json:")
    print(result)
  end
end

-- Funzione per configurare clangd con percorsi personalizzati
local function setup_clangd_with_paths(include_paths)
  local config = {
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
  }
  
  -- Aggiungi percorsi di include personalizzati
  if include_paths and #include_paths > 0 then
    for _, path in ipairs(include_paths) do
      table.insert(config.cmd, "-I" .. path)
      table.insert(config.settings.clangd.arguments, "-I" .. path)
    end
  end
  
  require('lspconfig').clangd.setup(config)
  print("✅ clangd configurato con percorsi personalizzati!")
end

-- Comandi utili per Mason
vim.api.nvim_create_user_command('MasonInstallAll', function()
  vim.cmd('MasonInstall ' .. table.concat({
    'lua_ls',
    'pyright', 
    'clangd',
    'rust_analyzer',
    'html',
    'cssls',
    'jsonls',
    'jdtls'
  }, ' '))
end, {})

vim.api.nvim_create_user_command('MasonUninstallAll', function()
  vim.cmd('MasonUninstall ' .. table.concat({
    'lua_ls',
    'pyright', 
    'clangd',
    'rust_analyzer',
    'html',
    'cssls',
    'jsonls',
    'jdtls'
  }, ' '))
end, {})

-- Comando per verificare i server installati (versione corretta)
vim.api.nvim_create_user_command('MasonListInstalled', function()
  local ok, registry = pcall(require, 'mason-registry')
  if not ok then
    print("Mason Registry non è disponibile. Assicurati che Mason sia caricato correttamente.")
    return
  end
  
  local installed = {}
  for _, package in pairs(registry.get_all_package_names()) do
    if registry.is_installed(package) then
      table.insert(installed, package)
    end
  end
  
  if #installed == 0 then
    print("Nessun server LSP installato")
  else
    print("Server LSP installati:")
    for _, name in ipairs(installed) do
      print("  - " .. name)
    end
  end
end, {})

-- Comandi specifici per clangd e librerie di terze parti
vim.api.nvim_create_user_command('ClangdGenerateCompileCommands', function()
  generate_compile_commands()
end, {})

vim.api.nvim_create_user_command('ClangdSetupWithPaths', function(args)
  local paths = {}
  if args.args ~= "" then
    for path in args.args:gmatch("[^,]+") do
      table.insert(paths, path:match("^%s*(.-)%s*$")) -- trim whitespace
    end
  end
  
  if #paths == 0 then
    print("Uso: ClangdSetupWithPaths <path1,path2,path3>")
    print("Esempio: ClangdSetupWithPaths /usr/include,/usr/local/include,/opt/homebrew/include")
    return
  end
  
  setup_clangd_with_paths(paths)
end, { nargs = 1 })

-- Comando per configurare manualmente un server LSP
vim.api.nvim_create_user_command('MasonSetupServer', function(args)
  local server_name = args.args
  if server_name == "" then
    print("Uso: MasonSetupServer <nome_server>")
    return
  end
  
  -- Configurazioni specifiche per server
  local configs = {
    lua_ls = {
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
    },
    pyright = {
      settings = {
        python = {
          analysis = {
            autoSearchPaths = true,
            useLibraryCodeForTypes = true,
            diagnosticMode = "workspace",
          },
        },
      },
    },
    clangd = {
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
    },
    jdtls = {
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
    },
    rust_analyzer = {
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
    },
  }
  
  local config = configs[server_name] or {}
  setup_lsp_server(server_name, config)
  print("Server " .. server_name .. " configurato manualmente")
end, { nargs = 1 })

-- Comando per aprire l'interfaccia grafica di Mason
vim.api.nvim_create_user_command('MasonUI', function()
  vim.cmd('Mason')
end, {})

-- Comando per verificare lo stato di Mason
vim.api.nvim_create_user_command('MasonStatus', function()
  local ok, mason = pcall(require, 'mason')
  if not ok then
    print("❌ Mason non è caricato")
    return
  end
  
  local ok_lsp, mason_lsp = pcall(require, 'mason-lspconfig')
  if not ok_lsp then
    print("❌ Mason LSP non è caricato")
    return
  end
  
  local ok_registry, registry = pcall(require, 'mason-registry')
  if not ok_registry then
    print("❌ Mason Registry non è caricato")
    return
  end
  
  print("✅ Mason è caricato correttamente")
  print("✅ Mason LSP è caricato correttamente")
  print("✅ Mason Registry è caricato correttamente")
  
  -- Conta i server installati
  local installed_count = 0
  for _, package in pairs(registry.get_all_package_names()) do
    if registry.is_installed(package) then
      installed_count = installed_count + 1
    end
  end
  
  print("📦 Server installati: " .. installed_count)
end, {}) 