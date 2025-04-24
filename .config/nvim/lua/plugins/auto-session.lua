return {
    'rmagatti/auto-session',
    lazy = false,
    config = function()
        vim.opt.sessionoptions = 'blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions'
        require('auto-session').setup({
            log_level = 'error',
            auto_session_suppress_dirs = { '~/', '/' },
            session_lens = { load_on_setup = false },
            no_restore_cmds = {
                function()
                    if vim.fn.argc() == 0 then
                        vim.cmd('Alpha')
                    end
                end,
            },
        })

        local session_lens_setup_done = false
        local function search_session()
            if not session_lens_setup_done then
                require('auto-session').setup_session_lens()
                session_lens_setup_done = true
            end
            require('auto-session.session-lens').search_session()
        end
        vim.keymap.set('n', '<C-s>', search_session, { desc = '[S]ession Manager' })
    end,
}
