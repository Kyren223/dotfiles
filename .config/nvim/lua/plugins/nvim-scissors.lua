return {
    'chrisgrieser/nvim-scissors',
    dependencies = 'folke/snacks.nvim',
    event = 'VeryLazy',
    opts = {
        ---@type "yq"|"jq"|"none"|string[]
        jsonFormatter = 'jq',
    },
    keys = {
        {
            '<leader>sa',
            function()
                require('scissors').addNewSnippet()
            end,
            desc = '[S]nippet [A]dd',
            mode = { 'n', 'x' },
        },
        {
            '<leader>se',
            function()
                require('scissors').editSnippet()
            end,
            desc = '[S]nippet [E]dit',
            mode = { 'n', 'x' },
        },
    },
}
