return {
    'm4xshen/hardtime.nvim',
    dependencies = { 'MunifTanjim/nui.nvim', 'nvim-lua/plenary.nvim' },
    event = { 'BufReadPre', 'BufNewFile' },
    keys = {
        { '<leader>ht', '<<cmd>Hardtime toggle<cr>', desc = '[H]ardtime [T]oggle' },
        { '<leader>hT', '<<cmd>Hardtime report<cr>', desc = '[H]ardtime Report' },
    },
    opts = {
        restriction_mode = 'hint',
        restricted_keys = {
            ['h'] = {},
            ['l'] = {},
        },
    },
}
