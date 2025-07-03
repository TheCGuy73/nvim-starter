-- Configurazione di base per nvim-lspconfig
-- La configurazione principale è gestita da Mason LSP handlers
-- Questo file serve per configurazioni aggiuntive o override

-- Configurazione globale per la diagnostica con segni moderni
vim.diagnostic.config({
  virtual_text = true,
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = " ",
      [vim.diagnostic.severity.WARN] = " ",
      [vim.diagnostic.severity.INFO] = " ",
      [vim.diagnostic.severity.HINT] = " ",
    },
    numhl = {
      [vim.diagnostic.severity.ERROR] = "DiagnosticSignError",
      [vim.diagnostic.severity.WARN] = "DiagnosticSignWarn",
      [vim.diagnostic.severity.INFO] = "DiagnosticSignInfo",
      [vim.diagnostic.severity.HINT] = "DiagnosticSignHint",
    },
    texthl = {
      [vim.diagnostic.severity.ERROR] = "DiagnosticSignError",
      [vim.diagnostic.severity.WARN] = "DiagnosticSignWarn",
      [vim.diagnostic.severity.INFO] = "DiagnosticSignInfo",
      [vim.diagnostic.severity.HINT] = "DiagnosticSignHint",
    },
  },
  underline = true,
  update_in_insert = false,
  severity_sort = true,
})

-- Configurazione per il floating window della diagnostica
vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
  border = "rounded",
})

vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
  border = "rounded",
})

-- Configurazione per il floating window delle azioni del codice
vim.lsp.handlers["textDocument/codeAction"] = vim.lsp.with(vim.lsp.handlers.code_action, {
  border = "rounded",
})

-- Configurazione per il floating window delle definizioni
vim.lsp.handlers["textDocument/definition"] = vim.lsp.with(vim.lsp.handlers.definition, {
  border = "rounded",
})

-- Configurazione per il floating window delle implementazioni
vim.lsp.handlers["textDocument/implementation"] = vim.lsp.with(vim.lsp.handlers.implementation, {
  border = "rounded",
})

-- Configurazione per il floating window dei riferimenti
vim.lsp.handlers["textDocument/references"] = vim.lsp.with(vim.lsp.handlers.references, {
  border = "rounded",
}) 