return {
    'kylechui/nvim-surround',
    version = '*',
    event = 'VeryLazy',
    config = function()
        require('nvim-surround').setup({})
        -- TODO: Add a way to not have to press S while in visual mode
    end,
}
