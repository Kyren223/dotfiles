return {
    {
        'rmagatti/auto-session',
        config = function()
            vim.opt.sessionoptions = 'blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions'
            require('auto-session').setup({
                log_level = 'error',
                auto_session_suppress_dirs = { '~/', '/' },
            })
            local session = require('auto-session.session-lens')
            vim.keymap.set('n', '<C-s>', session.search_session, { desc = '[S]ession Manager' })
        end,
    },
    {
        'wakatime/vim-wakatime',
        lazy = false,
    },
    {
        'AckslD/nvim-neoclip.lua',
        dependencies = {
            { 'kkharji/sqlite.lua',           module = 'sqlite' },
            { 'nvim-telescope/telescope.nvim' },
        },
        config = function()
            require('neoclip').setup({
                enable_persistent_history = true,
                keys = {
                    telescope = {
                        i = {
                            paste = '<C-y>',
                            paste_behind = '<C-S-Y>',
                        },
                    },
                },
            })
            -- NOTE: Using `plus` to set the plus register to the selected value
            vim.keymap.set('n', '<leader>nc', ':Telescope neoclip plus<cr>', { desc = '[N]eo[c]lip History' })
        end,
    },
}
