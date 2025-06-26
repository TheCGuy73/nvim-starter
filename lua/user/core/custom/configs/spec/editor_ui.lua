-- Configurazione UI nativa di Neovim

-- Numeri di linea
vim.opt.number = true
vim.opt.relativenumber = true

-- Evidenzia la riga corrente
vim.opt.cursorline = true

-- Abilita il mouse
vim.opt.mouse = 'a'

-- Mostra sempre la barra di stato
vim.opt.laststatus = 2



-- Colori truecolor
vim.opt.termguicolors = true



-- Visualizza la riga di comando
vim.opt.showcmd = true

-- Visualizza la modalità corrente
vim.opt.showmode = true

-- Select theme
vim.cmd.colorscheme("ef-dream")