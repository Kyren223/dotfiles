return {
    'uga-rosa/ccc.nvim',
    opts = { highlighter = { auto_enable = true } },
    event = 'VeryLazy',
    keys = {
        { '<leader>cp', '<cmd>CccPick<cr>', desc = '[C]olor [P]icker' },
        { '<leader>ct', '<cmd>CccHighlighterToggle<cr>', desc = '[C]olor [T]oggle' },
    },
}
