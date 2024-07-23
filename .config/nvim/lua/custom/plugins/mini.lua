return {
    'echasnovski/mini.nvim',
    version = false,
    keys = {
        {
            'Q',
            function()
                if vim.bo.modified then
                    vim.cmd.write()
                end
                require('mini.bufremove').delete(0)
            end,
            desc = '[Q]uit Buffer',
        },
    },
}
