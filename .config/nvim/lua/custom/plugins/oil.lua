return {
    'stevearc/oil.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
        local oil = require('oil')
        oil.setup({
            keymaps = {
                ['<C-h>'] = false,
                ['<C-l>'] = false,
                ['<C-k>'] = false,
                ['<C-j>'] = false,
                ['<M-h>'] = 'actions.select_split',
            },
            view_options = {
                show_hidden = true,
            },
        })
        vim.keymap.set('n', '<leader>ob', '<cmd>Oil<cr>', { desc = '[O]il [B]uffer' })
        vim.keymap.set('n', '<leader>of', oil.toggle_float, { desc = '[O]il [F]loat' })
    end,
}
