return {
    'folke/edgy.nvim',
    event = 'VeryLazy',
    opts = {
        bottom = {
            'Trouble',
            { ft = 'qf', title = 'QuickFix' },
            {
                ft = 'help',
                size = { height = 20 },
                filter = function(buf) -- only show help buffers
                    return vim.bo[buf].buftype == 'help'
                end,
            },
            { ft = 'spectre_panel', size = { height = 0.4 } },
        },
        left = {
            {
                title = 'Neo-Tree',
                ft = 'neo-tree',
                filter = function(buf)
                    return vim.b[buf].neo_tree_source == 'filesystem'
                end,
                size = { height = 0.5 },
            },
        },
    },
}
