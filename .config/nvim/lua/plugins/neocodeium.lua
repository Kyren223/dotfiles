return {
    'monkoose/neocodeium',
    event = 'VeryLazy',
    config = function()
        local neocodeium = require('neocodeium')
        neocodeium.setup()
        vim.keymap.set('i', '<c-y>', neocodeium.accept)
    end,
}
