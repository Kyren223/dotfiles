vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- System
vim.g.have_nerd_font = true
vim.opt.mouse = 'a'               -- enable mouse
vim.opt.clipboard = 'unnamedplus' -- use system clipboard
vim.opt.undofile = true -- Persist undo history by saving it to a file

-- Tab
vim.opt.expandtab = true -- convert tabs to spaces
vim.opt.tabstop = 4      -- number of visual spaces per TAB
vim.opt.softtabstop = 4  -- number of idfk tab when editing
vim.opt.shiftwidth = 4   -- number of spaces to insert on tab

-- UI
vim.opt.signcolumn = 'auto:9'
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.cursorline = true -- highlight current line
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.showmode = false -- don't show mode, because lualine already does
vim.opt.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }
vim.diagnostic.config({ signs = false }) -- disable signcolumn diagnostics

-- Searching
vim.opt.hlsearch = true
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Misc
vim.opt.wrap = false
vim.opt.scrolloff = 8
vim.opt.undofile = true
vim.opt.termguicolors = true
vim.opt.laststatus = 3            -- views can only be fully collapsed with the global statusline
vim.opt.splitkeep = 'screen'      -- for edgy.nvim
vim.opt.inccommand = 'split'      -- shows preview for commands like :%s/from/to
vim.opt.formatoptions:remove('o') -- don't have `o` add a comment

-- Disable warnings for missing language providers
vim.g.loaded_node_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_python3_provider = 0
