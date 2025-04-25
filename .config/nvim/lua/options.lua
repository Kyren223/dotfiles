-- System
vim.g.have_nerd_font = true
vim.opt.mouse = 'a' -- enable mouse
vim.opt.clipboard = 'unnamedplus' -- use system clipboard
vim.opt.undofile = true -- persist undo history by saving it to a file
vim.opt.exrc = true -- WARNING: runs .nvim.lua in cwd, which may execute arbitrary code

-- Tab
vim.opt.expandtab = true -- convert tabs to spaces
vim.opt.tabstop = 4 -- number of visual spaces per TAB
vim.opt.softtabstop = 4 -- number of idfk tab when editing
vim.opt.shiftwidth = 4 -- number of spaces to insert on tab

-- UI
vim.opt.colorcolumn = '80'
vim.opt.signcolumn = 'auto:9'
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.cursorline = true -- highlight current line
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.showmode = false -- don't show mode, because lualine already does
vim.opt.list = true
vim.opt.listchars = { tab = '  ', trail = '·', nbsp = '␣' }
vim.diagnostic.config({ signs = false }) -- disable signcolumn diagnostics
vim.opt.fillchars:append({ diff = '╱' }) -- nicer diff view for filled spaces

-- Searching
vim.opt.hlsearch = true
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Misc
vim.opt_local.wrap = false
vim.opt.wrap = false
vim.opt.scrolloff = 8
vim.opt.termguicolors = true
vim.opt.laststatus = 3 -- views can only be fully collapsed with the global statusline
vim.opt.splitkeep = 'screen' -- for edgy.nvim
vim.opt.inccommand = 'split' -- shows preview for commands like :%s/from/to
vim.opt.sessionoptions = 'blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions'

-- Disable warnings for missing language providers
vim.g.loaded_node_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_python3_provider = 0

-- LSP
vim.lsp.inlay_hint.enable()
vim.diagnostic.config({ virtual_text = false, update_in_insert = true })

-- Add support for mdx files
vim.filetype.add({
    extension = {
        mdx = 'markdown',
    },
})

-- Zig LSP settings
vim.g.zig_fmt_parse_errors = 0
vim.g.zig_fmt_autosave = 0
