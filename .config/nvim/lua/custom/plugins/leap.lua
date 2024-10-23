return {
    'ggandor/leap.nvim',
    lazy = false,
    dependencies = { 'tpope/vim-repeat' },
    config = function()
        require('leap').opts.equivalence_classes = { ' \t\r\n', '([{', ')]}', '\'"`' }
        vim.api.nvim_set_hl(0, 'LeapBackdrop', { fg = '#777777' })

        vim.keymap.set({ 'n', 'x' }, 's', '<Plug>(leap)')
        vim.keymap.set('n', 'S', '<Plug>(leap-from-window)')
        vim.keymap.set('n', 's', require('leap.remote').action)
        vim.keymap.set('o', 'z', '<Plug>(leap-forward)')
        vim.keymap.set('o', 'Z', '<Plug>(leap-backward)')
    end,
}
