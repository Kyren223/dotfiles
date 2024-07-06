return {
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
}
