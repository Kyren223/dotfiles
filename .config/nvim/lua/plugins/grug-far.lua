return {
    'MagicDuck/grug-far.nvim',
    event = 'VeryLazy',
    cmd = 'GrugFar',
    opts = {
        headerMaxWidth = 80,
        windowCreationCommand = 'botright split',
    },
    keys = {
        {
            '<leader>sr',
            function()
                local grug = require('grug-far')
                local ext = vim.bo.buftype == '' and vim.fn.expand('%:e')
                grug.open({
                    transient = true,
                    prefills = {
                        filesFilter = ext and ext ~= '' and '*.' .. ext or nil,
                    },
                })
            end,
            mode = { 'n', 'v' },
            desc = '[S]earch and [R]eplace',
        },
    },
}
