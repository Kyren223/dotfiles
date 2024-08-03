return {
    'rcarriga/nvim-notify',
    event = 'VeryLazy',
    keys = {
        {
            '<leader>nd',
            function()
                require('notify').dismiss({ silent = true, pending = true })
            end,
            desc = '[N]otify [D]ismiss All',
        },
    },
    opts = {
        fps = 60,
        render = 'default',
        timeout = 500,
        topDown = true,
    },
}
