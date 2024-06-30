return {
    'nvim-neo-tree/neo-tree.nvim',
    branch = 'v3.x',
    dependencies = {
        'nvim-lua/plenary.nvim',
        'nvim-tree/nvim-web-devicons',
        'MunifTanjim/nui.nvim',
    },
    config = function()
        vim.keymap.set('n', '<leader>gp', ':Neotree toggle reveal left<cr>', { desc = '[G]oto [P]roject (toggle)' })
        vim.keymap.set('n', 'gp', ':Neotree float<cr>', { desc = '[G]oto [P]roject (floating)' })
    end,
}
