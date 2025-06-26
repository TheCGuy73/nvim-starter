return {
    'rebelot/kanagawa.nvim',
    name = 'kanagawa',
    lazy = false, -- Imposta a false per caricarlo all'avvio
    priority = 1000, -- Assicura che si carichi prima di altri plugin
    config = function()
        require('kanagawa').setup({
            transparent = true, -- Rendi lo sfondo trasparente
            compile = false,    -- Compila il tema per prestazioni migliori (potresti volerlo impostare su true dopo averlo testato)
            undercurl = true,   -- Abilita il 'sottolineato ondulato'
            overrides = function(colors)
                return {
                    -- Usa la struttura aggiornata dei colori di Kanagawa
                    Pmenu = { bg = colors.theme.ui.bg_p1 },
                    PmenuSel = { bg = colors.theme.ui.bg_search },
                }
            end,
            theme = "wave", -- Scegli tra 'wave', 'dragon', 'thoth'
        })
    end
}
