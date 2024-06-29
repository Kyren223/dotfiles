vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- System
vim.g.have_nerd_font = true
vim.opt.mouse = 'a' -- enable mouse
vim.opt.clipboard = 'unnamedplus' -- use system clipboard

-- Tab
vim.opt.expandtab = true -- convert tabs to spaces
vim.opt.tabstop = 4 -- number of visual spaces per TAB
vim.opt.softtabstop = 4 -- number of idfk tab when editing
vim.opt.shiftwidth = 4 -- number of spaces to insert on tab

-- UI
vim.opt.signcolumn = 'auto'
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.cursorline = true -- highlight current line
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.showmode = false -- don't show mode, because lualine already does
vim.opt.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

-- Searching
vim.opt.hlsearch = true
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Misc
vim.opt.scrolloff = 8
vim.opt.undofile = true
