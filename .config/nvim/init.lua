vim.loader.enable()

vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
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
require('lazy').setup({ import = 'custom/plugins' }, {
    change_detection = { enabled = true, notify = false },
    defaults = { lazy = true },
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
