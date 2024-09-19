return {
    'roodolv/markdown-toggle.nvim',
    event = 'VeryLazy',
    config = function()
        require('markdown-toggle').setup()
        local opts = { silent = true, noremap = true }
        local toggle = require('markdown-toggle')
        vim.keymap.set({ 'n', 'x' }, '<leader>tu', toggle.list, opts)
        vim.keymap.set({ 'n', 'x' }, '<leader>to', toggle.olist, opts)
        vim.keymap.set({ 'n', 'x' }, '<leader>tm', toggle.checkbox, opts)
    end,
}
