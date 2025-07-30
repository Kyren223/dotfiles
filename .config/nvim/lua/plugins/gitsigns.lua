return {
    'lewis6991/gitsigns.nvim',
    cmd = 'Gitsigns',
    -- INFO: Disabled lazy loading to see if the errors stop
    -- Not sure if it's an issue with lazy loading or just a gitsigns bug
    -- INFO: re-enabled to see if the errors stop
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
