return {
    'lewis6991/gitsigns.nvim',
    cmd = 'Gitsigns',
    event = 'VeryLazy',
    config = function()
        require('gitsigns').setup()

        vim.keymap.set('n', '<leader>gd', '<cmd>Gitsigns toggle_deleted<cr>', { desc = '[G]it [D]eleted' })
        vim.keymap.set(
            'n',
            '<leader>gB',
            '<cmd>Gitsigns toggle_current_line_blame<cr>',
            { desc = '[G]it [B]lame Line' }
        )
    end,
}
