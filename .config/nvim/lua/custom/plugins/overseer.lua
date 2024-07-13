return {
    'stevearc/overseer.nvim',
    opts = {},
    config = function()
        require('overseer').setup({
            templates = { 'builtin', 'custom' },
            task_list = {
                min_height = 0.5,
                bindings = {
                    ['o'] = false,
                    ['<C-v>'] = false,
                    ['<C-s>'] = false,
                    ['<C-h>'] = false,
                    ['<C-j>'] = false,
                    ['<C-k>'] = false,
                    ['<C-l>'] = false,
                    ['<C-u>'] = 'ScrollOutputUp',
                    ['<C-d>'] = 'ScrollOutputDown',
                },
            },
        })
        vim.keymap.set('n', '<leader>or', '<cmd>OverseerRun<cr>', { desc = '[O]verseer [R]un' })
        vim.keymap.set('n', '<leader>ot', '<cmd>OverseerToggle<cr>', { desc = '[O]verseer [T]oggle' })
    end,
}
