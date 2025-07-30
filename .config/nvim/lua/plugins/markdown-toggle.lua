return {
    'roodolv/markdown-toggle.nvim',
    opts = {},
    keys = {
        {
            '<leader>tl', -- toggle list
            function()
                require('markdown-toggle').list()
            end,
            mode = { 'n', 'x' },
        },
        {
            '<leader>tn', -- toggle numbered list
            function()
                require('markdown-toggle').olist()
            end,
            mode = { 'n', 'x' },
        },
        {
            '<leader>tm', -- toggle checkbox (why the m??? I don't remember)
            function()
                require('markdown-toggle').checkbox()
            end,
            mode = { 'n', 'x' },
        },
    },
}
