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
        vim.keymap.set('v', '<', '<Plug>(nvim-surround-visual)<', opts)
        vim.keymap.set('v', '>', '<Plug>(nvim-surround-visual)>', opts)
        vim.keymap.set('v', '[', '<Plug>(nvim-surround-visual)[', opts)
        vim.keymap.set('v', ']', '<Plug>(nvim-surround-visual)]', opts)
        vim.keymap.set('v', "'", "<Plug>(nvim-surround-visual)'", opts)
        vim.keymap.set('v', '"', '<Plug>(nvim-surround-visual)"', opts)
        vim.keymap.set('v', '`', '<Plug>(nvim-surround-visual)`', opts)
    end,
}
