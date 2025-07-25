return {
    'rmagatti/auto-session',
    lazy = false,
    opts = {
        suppressed_dirs = { '~/', '/' },
        session_lens = { load_on_setup = false },
        no_restore_cmds = {
            function()
                if vim.fn.argc() == 0 then
                    -- Snacks.dashboard()
                    -- vim.cmd('Alpha')
                end
            end,
        },
    },
    keys = {
        { '<C-s>', '<cmd>SessionSearch<cr>', desc = '[S]ession Manager' },
    },
}
