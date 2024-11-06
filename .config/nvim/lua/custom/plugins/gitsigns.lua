return {
    'lewis6991/gitsigns.nvim',
    cmd = 'Gitsigns',
    -- INFO: lazy loading seems to have some issues so I am trying to load it on buffer load
    -- event = 'VeryLazy',
    event = { 'BufReadPre', 'BufNewFile'},
    config = function()
        require('gitsigns').setup()

        local function stage_visual_chunk()
            require('gitsigns').stage_hunk({ vim.fn.line('.'), vim.fn.line('v') })
        end
        local function reset_visual_chunk()
            require('gitsigns').reset_hunk({ vim.fn.line('.'), vim.fn.line('v') })
        end

        vim.keymap.set('n', '<leader>gD', '<cmd>Gitsigns toggle_deleted<cr>', { desc = '[G]it [D]eleted' })
        vim.keymap.set('n', '<leader>hp', '<cmd>Gitsigns preview_hunk<cr>', { desc = '[H]unk [P]review' })
        vim.keymap.set('n', '<leader>hs', '<cmd>Gitsigns stage_hunk<cr>', { desc = '[H]unk [S]tage' })
        vim.keymap.set('n', '<leader>hr', '<cmd>Gitsigns reset_hunk<cr>', { desc = '[H]unk [R]eset' })
        vim.keymap.set('v', '<leader>hs', stage_visual_chunk, { desc = '[H]unk [S]tage' })
        vim.keymap.set('v', '<leader>hr', reset_visual_chunk, { desc = '[H]unk [S]tage' })
        vim.keymap.set('n', '<leader>hS', '<cmd>Gitsigns stage_buffer<cr>', { desc = '[S]tage Buffer' })
        vim.keymap.set('n', '<leader>hR', '<cmd>Gitsigns reset_buffer<cr>', { desc = '[R]eset Buffer' })
        vim.keymap.set('n', '<leader>hu', '<cmd>Gitsigns undo_stage_hunk<cr>', { desc = '[H]unk [U]ndo' })
        vim.keymap.set(
            'n',
            '<leader>gB',
            '<cmd>Gitsigns toggle_current_line_blame<cr>',
            { desc = '[G]it [B]lame Line' }
        )
    end,
}
