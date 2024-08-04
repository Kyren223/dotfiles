return {
    'stevearc/overseer.nvim',
    -- NOTE: without telescope the UI is not custom, so making sure telescope is loaded first
    dependencies = { 'nvim-telescope/telescope.nvim' },
    event = 'VeryLazy',
    keys = {
        { '<leader>or', '<cmd>OverseerRun<cr>', desc = '[O]verseer [R]un' },
        { '<leader>ot', '<cmd>OverseerToggle<cr>', desc = '[O]verseer [T]oggle' },
    },
    opts = {
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
    },
}
