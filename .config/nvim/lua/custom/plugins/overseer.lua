return {
    'stevearc/overseer.nvim',
    -- NOTE: without telescope the UI is not custom, so making sure telescope is loaded first
    dependencies = { 'nvim-telescope/telescope.nvim' },
    event = 'VeryLazy',
    keys = function()
        local overseer = require('overseer')
        local RUN_TAG = overseer.TAG.RUN
        local BUILD_TAG = overseer.TAG.BUILD
        local TEST_TAG = overseer.TAG.TEST
        local function run_template(tag, show_prompt)
            return function()
                local prompt = show_prompt and 'always' or 'avoid'
                overseer.run_template({ tags = { tag }, first = true, prompt = prompt })
                -- overseer.open({ enter = false }) -- don't focus
            end
        end
        return {
            { '<leader>or', run_template(RUN_TAG, false), desc = '[O]verseer [R]un' },
            { '<leader>oR', run_template(RUN_TAG, true), desc = '[O]verseer [R]un (with params)' },

            { '<leader>ob', run_template(BUILD_TAG, false), desc = '[O]verseer [B]uild' },
            { '<leader>oB', run_template(BUILD_TAG, true), desc = '[O]verseer [B]uild (with params)' },

            { '<leader>ot', run_template(TEST_TAG, false), desc = '[O]verseer [T]est' },
            { '<leader>oT', run_template(TEST_TAG, true), desc = '[O]verseer [T]est (with params)' },

            { '<leader>ow', '<cmd>OverseerToggle!<cr>', desc = '[O]verseer [W]indow (toggle)' },
            { '<leader>oW', '<cmd>OverseerQuickAction open float<cr>', desc = '[O]verseer [W]indow (terminal float)' },
        }
    end,
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
