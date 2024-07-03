return {
    'uga-rosa/ccc.nvim',
    lazy = false,
    config = function()
        require('ccc').setup({
            highlighter = {
                auto_enable = true,
            },
        })
        vim.keymap.set('n', '<leader>cp', ':CccPick<cr>', { desc = '[C]olor [P]icker' })
        vim.keymap.set('n', '<leader>ct', ':CccHighlighterToggle<cr>', { desc = '[C]olor [T]oggle' })
    end,
}
