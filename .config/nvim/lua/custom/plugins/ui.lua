return {
    {
        'uga-rosa/ccc.nvim',
        lazy = false,
        config = function()
            require('ccc').setup({
                highlighter = {
                    auto_enable = true,
                },
            })
            vim.keymap.set('n', '<leader>cp', '<cmd>CccPick<cr>', { desc = '[C]olor [P]icker' })
            vim.keymap.set('n', '<leader>ct', '<cmd>CccHighlighterToggle<cr>', { desc = '[C]olor [T]oggle' })
        end,
    },
    {
        -- TODO: Make sure it uses a diff color
        -- the color rn is too similar to visual mode
        'RRethy/vim-illuminate',
        config = function()
            vim.keymap.set('n', '<leader>it', '<cmd>IlluminateToggle<cr>', { desc = '[I]lluminate [Tloggle]' })
        end,
    },
    {
        'lukas-reineke/indent-blankline.nvim',
        main = 'ibl',
        config = function()
            require('ibl').setup({
                scope = {
                    show_start = false,
                    show_end = false,
                },
            })
        end,
    },
    -- {
    --     'kosayoda/nvim-lightbulb',
    --     config = function()
    --         require('nvim-lightbulb').setup({
    --             autocmd = {
    --                 enabled = true,
    --                 updatetime = 50,
    --             },
    --             action_kinds = { 'quickfix', 'refactor.rewrite' },
    --             sign = { enabled = false },
    --             virtual_text = { enabled = true },
    --             float = { enabled = false },
    --             ignore = {
    --                 ft = { 'neo-tree' },
    --                 actions_without_kind = true,
    --             },
    --         })
    --     end,
    -- },
}
