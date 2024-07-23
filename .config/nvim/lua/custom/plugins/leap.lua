return {
    'ggandor/leap.nvim',
    dependencies = { 'tpope/vim-repeat' },
    keys = {
        { 's', '<Plug>(leap)', mode = { 'n', 'x', 'o' } },
        { 'S', '<Plug>(leap-from-window)' },
        {
            'gs',
            function()
                require('leap.remote').action()
            end,
        },
    },
    config = function()
        require('leap').opts.equivalence_classes = { ' \t\r\n', '([{', ')]}', '\'"`' }
        vim.api.nvim_set_hl(0, 'LeapBackdrop', { fg = '#777777' })
    end,
}
