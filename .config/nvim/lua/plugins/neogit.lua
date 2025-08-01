return {
    'NeogitOrg/neogit',
    cmd = { 'Neogit', 'NeogitCommit', 'NeogitLogCurrent', 'NeogitResetState' },
    keys = {
        { '<leader>gs', '<cmd>Neogit<cr>' },
        { '<leader>gh', '<cmd>NeogitLogCurrent<cr>' },
    },
    opts = function()
        return {
            commit_editor = { spell_check = false },
            mappings = {
                commit_editor = {
                    ['<C-y>'] = 'Submit',
                    ['<C-n>'] = 'Abort',
                },
                commit_editor_I = {
                    ['<C-y>'] = 'Submit',
                    ['<C-n>'] = 'Abort',
                },
                popup = {
                    ['p'] = 'PushPopup',
                    ['P'] = 'PullPopup',
                },
            },
        }
    end,
}
