vim.loader.enable()

vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

_G.dd = function(...)
    Snacks.debug.inspect(...)
end
_G.bt = function()
    Snacks.debug.backtrace()
end
vim.print = _G.dd

require('options')
-- WARNING: not sure why it was in schedule but that caused issues
-- WARNING: so I removed it
-- vim.schedule(function()
    require('keymaps')
    require('autocmds')
    require('usrcmds')
    require('extra')
-- end)

-- Enable all LSPs
local lsp = require('lsp')
for server, value in pairs(lsp) do
    if server == 'global' then
        vim.lsp.config('*', value)
    elseif value then
        vim.lsp.enable(server)
    end
end

local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    vim.fn.system({
        'git',
        'clone',
        '--filter=blob:none',
        'https://github.com/folke/lazy.nvim.git',
        '--branch=stable',
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)
require('lazy').setup({ import = 'plugins' }, {
    defaults = { lazy = true },
    -- install = { colorscheme = { 'tokyonight', 'habamax' } },
    change_detection = { enabled = true, notify = false },
    checker = { enabled = true, notify = false },
    ui = {
        icons = {
            ft = ' ',
            lazy = '󰂠 ',
            loaded = ' ',
            not_loaded = ' ',
        },
    },
    performance = {
        rtp = {
            disabled_plugins = {
                '2html_plugin',
                'tohtml',
                'getscript',
                'getscriptPlugin',
                'gzip',
                'logipat',
                'netrw',
                'netrwPlugin',
                'netrwSettings',
                'netrwFileHandlers',
                'matchit',
                -- "matchparen"
                'tar',
                'tarPlugin',
                'rrhelper',
                'spellfile_plugin',
                'vimball',
                'vimballPlugin',
                'zip',
                'zipPlugin',
                'rplugin',
                'syntax',
                'synmenu',
                'optwin',
                'compiler',
                'bugreport',
                'tutor',
                'ftplugin', -- WARNING: seems to not break ftplugin, but if there r any issues, try commenting this!
            },
        },
    },
})
