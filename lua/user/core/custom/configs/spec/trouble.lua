-- Configurazione di trouble.nvim per la gestione della diagnostica
local trouble = require('trouble')

-- Configurazione principale
trouble.setup({
  -- Configurazione generale
  auto_preview = false,           -- disabilita l'anteprima automatica
  auto_fold = false,              -- disabilita il fold automatico
  use_diagnostic_signs = true,    -- usa i segni di diagnostica
  
  -- Configurazione dell'interfaccia
  action_keys = {
    -- Mappature predefinite
    close = "q",                    -- chiudi trouble
    cancel = "<esc>",               -- cancella
    refresh = "r",                  -- aggiorna
    jump = {"<cr>", "<tab>"},       -- vai alla posizione
    open_in_browser = "gx",         -- apri nel browser
    copy_to_clipboard = "<C-c>",    -- copia negli appunti
    toggle_preview = "P",           -- toggle anteprima
    hover = "K",                    -- hover
    preview = "p",                  -- anteprima
    close_folds = {"zM", "zm"},     -- chiudi tutti i fold
    open_folds = {"zR", "zr"},      -- apri tutti i fold
    toggle_fold = {"zA", "za"},     -- toggle fold
    previous = "k",                 -- elemento precedente
    next = "j",                     -- elemento successivo
    help = "?",                     -- aiuto
  },
  
  -- Configurazione dei segni
  signs = {
    -- errori
    error = " ",
    warning = " ",
    hint = " ",
    information = " ",
    other = " ",
  },
  
  -- Configurazione dei gruppi
  group = true,                     -- raggruppa per file
  padding = true,                   -- aggiungi padding
  cycle_results = true,             -- ciclo nei risultati
  auto_jump = {},                   -- salto automatico per specifici tipi
  
  -- Configurazione del filtro
  include_declaration = false,      -- non includere dichiarazioni
  cycle_group = true,               -- ciclo nei gruppi
  
  -- Configurazione della finestra
  width = 50,                       -- larghezza della finestra
  height = 10,                      -- altezza della finestra
  position = "bottom",              -- posizione: bottom, top, left, right
  border = "rounded",               -- bordo: single, double, rounded, solid, shadow
  
  -- Configurazione dell'ordinamento
  indent_lines = true,              -- indentazione delle linee
  fold_closed = " ",                -- icona per fold chiuso
  fold_open = " ",                  -- icona per fold aperto
  multiline = true,                 -- supporto per linee multiple
  
  -- Configurazione del filtro
  filter = {
    tag = ".*",                     -- filtro per tag
    severity = vim.diagnostic.severity.ERROR, -- solo errori di default
  },
  
  -- Configurazione del formato
  format = function(items, opts)
    local result = {}
    for _, item in ipairs(items) do
      local filename = vim.fn.fnamemodify(item.filename, ":t")
      local line = item.lnum
      local col = item.col
      local message = item.message
      local severity = item.severity
      
      -- Formatta il messaggio
      local severity_icon = {
        [vim.diagnostic.severity.ERROR] = " ",
        [vim.diagnostic.severity.WARN] = " ",
        [vim.diagnostic.severity.INFO] = " ",
        [vim.diagnostic.severity.HINT] = " ",
      }
      
      local formatted = string.format("%s %s:%d:%d %s", 
        severity_icon[severity] or " ",
        filename, line, col, message)
      
      table.insert(result, formatted)
    end
    return result
  end,
})

-- Mappature globali
vim.keymap.set("n", "<leader>xx", function() trouble.toggle() end, { desc = "Trouble Toggle" })
vim.keymap.set("n", "<leader>xw", function() trouble.toggle("workspace_diagnostics") end, { desc = "Workspace Diagnostics" })
vim.keymap.set("n", "<leader>xd", function() trouble.toggle("document_diagnostics") end, { desc = "Document Diagnostics" })
vim.keymap.set("n", "<leader>xq", function() trouble.toggle("quickfix") end, { desc = "Quickfix" })
vim.keymap.set("n", "<leader>xl", function() trouble.toggle("loclist") end, { desc = "Location List" })
vim.keymap.set("n", "<leader>xr", function() trouble.toggle("lsp_references") end, { desc = "LSP References" })
vim.keymap.set("n", "<leader>xs", function() trouble.toggle("lsp_definitions") end, { desc = "LSP Definitions" })
vim.keymap.set("n", "<leader>xt", function() trouble.toggle("lsp_type_definitions") end, { desc = "LSP Type Definitions" })

-- Mappature specifiche per i buffer di trouble
vim.api.nvim_create_autocmd("FileType", {
  pattern = "Trouble",
  callback = function()
    -- Mappature locali per i buffer di trouble
    local opts = { buffer = true, silent = true }
    
    -- Navigazione
    vim.keymap.set("n", "j", "<cmd>lua require('trouble').next({skip_groups = true, jump = true})<cr>", opts)
    vim.keymap.set("n", "k", "<cmd>lua require('trouble').previous({skip_groups = true, jump = true})<cr>", opts)
    
    -- Azioni
    vim.keymap.set("n", "<cr>", "<cmd>lua require('trouble').open()<cr>", opts)
    vim.keymap.set("n", "<tab>", "<cmd>lua require('trouble').open()<cr>", opts)
    vim.keymap.set("n", "q", "<cmd>lua require('trouble').close()<cr>", opts)
    vim.keymap.set("n", "<esc>", "<cmd>lua require('trouble').close()<cr>", opts)
    
    -- Filtri
    vim.keymap.set("n", "e", "<cmd>lua require('trouble').toggle({mode = 'workspace_diagnostics', filter = {severity = vim.diagnostic.severity.ERROR}})<cr>", opts)
    vim.keymap.set("n", "w", "<cmd>lua require('trouble').toggle({mode = 'workspace_diagnostics', filter = {severity = vim.diagnostic.severity.WARN}})<cr>", opts)
    vim.keymap.set("n", "i", "<cmd>lua require('trouble').toggle({mode = 'workspace_diagnostics', filter = {severity = vim.diagnostic.severity.INFO}})<cr>", opts)
    vim.keymap.set("n", "h", "<cmd>lua require('trouble').toggle({mode = 'workspace_diagnostics', filter = {severity = vim.diagnostic.severity.HINT}})<cr>", opts)
    vim.keymap.set("n", "a", "<cmd>lua require('trouble').toggle('workspace_diagnostics')<cr>", opts)
  end,
})

-- Funzioni di utilità
local M = {}

-- Funzione per aprire trouble con filtri specifici
function M.open_with_filter(severity)
  trouble.toggle({
    mode = "workspace_diagnostics",
    filter = { severity = severity }
  })
end

-- Funzione per aprire trouble solo per il file corrente
function M.open_current_file()
  trouble.toggle("document_diagnostics")
end

-- Funzione per aprire trouble per i riferimenti LSP
function M.open_references()
  trouble.toggle("lsp_references")
end

-- Funzione per aprire trouble per le definizioni LSP
function M.open_definitions()
  trouble.toggle("lsp_definitions")
end

-- Comandi personalizzati
vim.api.nvim_create_user_command('TroubleErrors', function()
  M.open_with_filter(vim.diagnostic.severity.ERROR)
end, { desc = "Open Trouble with only errors" })

vim.api.nvim_create_user_command('TroubleWarnings', function()
  M.open_with_filter(vim.diagnostic.severity.WARN)
end, { desc = "Open Trouble with only warnings" })

vim.api.nvim_create_user_command('TroubleCurrent', function()
  M.open_current_file()
end, { desc = "Open Trouble for current file" })

vim.api.nvim_create_user_command('TroubleRefs', function()
  M.open_references()
end, { desc = "Open Trouble for LSP references" })

vim.api.nvim_create_user_command('TroubleDefs', function()
  M.open_definitions()
end, { desc = "Open Trouble for LSP definitions" })

return M 