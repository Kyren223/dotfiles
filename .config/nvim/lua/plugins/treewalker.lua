return {
    'aaronik/treewalker.nvim',
    keys = {
        { 'H', '<cmd>Treewalker SwapLeft<cr>', silent = true },
        { 'L', '<cmd>Treewalker SwapRight<cr>', silent = true },
    },
    opts = {
        highlight = true,
        highlight_duration = 250,
        highlight_group = 'CursorLine',
    },
}
