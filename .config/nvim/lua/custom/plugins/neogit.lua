return {
    'NeogitOrg/neogit',
    cmd = 'Neogit',
    keys = {
        { '<leader>gb', '<cmd>Neogit branch<cr>' },
        { '<leader>gs', '<cmd>Neogit<cr>' },
        { '<leader>gL', '<cmd>Neogit log<cr>' },
        { '<leader>gc', '<cmd>Neogit commit<cr>' },
        { '<leader>gp', '<cmd>Neogit push<cr>' },
        { '<leader>gP', '<cmd>Neogit pull<cr>' },
        { '<leader>gr', '<cmd>Neogit rebase<cr>' },
        { '<leader>gm', '<cmd>Neogit merge<cr>' },
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
