return {
    'roodolv/markdown-toggle.nvim',
    opts = {},
    keys = {
        {
            '<leader>tu',
            function()
                require('markdown-toggle').list()
            end,
            mode = { 'n', 'x' },
        },
        {
            '<leader>to',
            function()
                require('markdown-toggle').olist()
            end,
            mode = { 'n', 'x' },
        },
        {
            '<leader>tm',
            function()
                require('markdown-toggle').checkbox()
            end,
            mode = { 'n', 'x' },
        },
    },
}
