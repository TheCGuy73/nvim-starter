return {
    "loctvl842/monokai-pro.nvim",
    name = "monokai-pro", -- Il nome che vuoi dare al plugin
    lazy = false, -- Carica il plugin all'avvio di Neovim
    priority = 1000, -- Assicurati che il plugin venga caricato per primo
      config = function()
        require("monokai-pro").setup({
          -- Configurazione semplificata
          options = {
            devicons = true,
            italic = true,
            undercurl = true,
            underline = true,
            bold = true,
          },
          -- Rimossa la palette per evitare errori di caricamento
        })
      end
    
    
}