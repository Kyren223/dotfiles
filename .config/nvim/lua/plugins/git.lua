return {
    {
        'lewis6991/gitsigns.nvim',
        config = function()
            require('gitsigns').setup()
            vim.keymap.set('n', '<leader>gp', ':Gitsigns preview_hunk<cr>', { desc = '[G]it [P]review' })
            vim.keymap.set('n', '<leader>gb', ':Gitsigns toggle_current_line_blame<cr>', { desc = '[G]it [B]lame' })
        end,
    },
    { 'tpope/vim-fugitive' },
    { 'sindrets/diffview.nvim' },
    {
        'pwntester/octo.nvim',
        config = function()
            require('octo').setup()
            vim.treesitter.language.register('markdown', 'octo')

            vim.api.nvim_create_autocmd('FileType', {
                pattern = 'octo',
                callback = function()
                    vim.keymap.set('i', '@', '@<C-x><C-o>', { silent = true, buffer = true })
                    vim.keymap.set('i', '#', '#<C-x><C-o>', { silent = true, buffer = true })
                end,
            })
            vim.keymap.set('n', '<leader>gi', ':Octo issue search<cr>', { desc = '[G]thub [I]ssues' })
        end,
    },
}
