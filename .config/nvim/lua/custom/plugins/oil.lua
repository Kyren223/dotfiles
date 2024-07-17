return {
    'stevearc/oil.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
        local oil = require('oil')
        oil.setup({
            default_file_explorer = true,
            skip_confirm_for_simple_edits = true,
            keymaps = {
                ['gs'] = false,
                ['<C-h>'] = false,
                ['<C-l>'] = false,
                ['<C-k>'] = false,
                ['<C-j>'] = false,
                ['<M-h>'] = 'actions.select_split',
                ['<M-v>'] = 'actions.select_vsplit',
                ['<C-r>'] = 'actions.refresh',
                ['<C-q>'] = 'actions.close',
                ['gS'] = 'actions.change_sort',
            },
            view_options = {
                show_hidden = true,
                natural_order = true,
            },
        })
        vim.keymap.set('n', '<leader>ob', '<cmd>Oil<cr>', { desc = '[O]il [B]uffer' })
        vim.keymap.set('n', '<leader>of', oil.toggle_float, { desc = '[O]il [F]loat' })
    end,
}
