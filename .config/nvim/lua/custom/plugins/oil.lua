return {
    'stevearc/oil.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    keys = {
        { '<leader>ob', '<cmd>Oil<cr>',                             desc = '[O]il [B]uffer' },
        { '<leader>of', '<cmd>lua require("oil").toggle_float<cr>', desc = '[O]il [F]loat' },
    },
    opts = {
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
    },
    cmd = 'Oil',
    event = function()
        if vim.fn.isdirectory(vim.fn.expand('%')) == 1 then
            return 'VimEnter'
        end
    end,
}
