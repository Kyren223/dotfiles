return {
    'folke/snacks.nvim',
    ---@type snacks.Config
    opts = {
        image = {
            -- your image configuration comes here
            -- or leave it empty to use the default settings
            -- refer to the configuration section below
        },
    },
    keys = {
        {
            '<leader>si',
            function()
                require('snacks').image.hover()
            end,
        },
    },
    lazy = false,
}
