return {
    'ggandor/leap.nvim',
    dependencies = { "tpope/vim-repeat" },
    config = function()
        vim.keymap.set({ 'n', 'x', 'o' }, 's', '<Plug>(leap-forward)')
        vim.keymap.set({ 'n', 'x', 'o' }, 'S', '<Plug>(leap-backward)')
        vim.keymap.set({ 'n', 'x', 'o' }, 'gs', '<Plug>(leap-from-window)')

        -- Define equivalence classes for brackets and quotes, in addition to
        -- the default whitespace group.
        require('leap').opts.equivalence_classes = { ' \t\r\n', '([{', ')]}', '\'"`' }

        -- Set background to gray in searchable area
        vim.api.nvim_set_hl(0, 'LeapBackdrop', { fg = '#777777' })
    end,
}
