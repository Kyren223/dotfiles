return {
    enabled = false, -- Don't want this
    'monkoose/neocodeium',
    event = 'VeryLazy',
    config = function()
        local neocodeium = require('neocodeium')
        neocodeium.setup({
            show_label = false,
            silent = true,
        })
        vim.keymap.set('i', '<c-y>', neocodeium.accept)
    end,
}
