return {
    'kylechui/nvim-surround',
    version = '*',
    event = 'VeryLazy',
    config = function()
        require('nvim-surround').setup({})
        local opts = {}
        vim.keymap.set('v', '(', '<Plug>(nvim-surround-visual)(', opts)
        vim.keymap.set('v', ')', '<Plug>(nvim-surround-visual))', opts)
        vim.keymap.set('v', '{', '<Plug>(nvim-surround-visual){', opts)
        vim.keymap.set('v', '}', '<Plug>(nvim-surround-visual)}', opts)
        -- NOTE: I still want to be able to do < and > for indentation
        -- vim.keymap.set('v', '<', '<Plug>(nvim-surround-visual)<', opts)
        -- vim.keymap.set('v', '>', '<Plug>(nvim-surround-visual)>', opts)
        vim.keymap.set('v', '[', '<Plug>(nvim-surround-visual)[', opts)
        vim.keymap.set('v', ']', '<Plug>(nvim-surround-visual)]', opts)
        vim.keymap.set('v', "'", "<Plug>(nvim-surround-visual)'", opts)
        vim.keymap.set('v', '"', '<Plug>(nvim-surround-visual)"', opts)
        vim.keymap.set('v', '`', '<Plug>(nvim-surround-visual)`', opts)
    end,
}
