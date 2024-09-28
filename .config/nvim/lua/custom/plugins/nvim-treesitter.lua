return {
    {
        'nvim-treesitter/nvim-treesitter',
        build = ':TSUpdate',
        config = function()
            ---@type userdata
            ---@diagnostic disable-next-line: missing-fields
            require('nvim-treesitter.configs').setup({
                -- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
                auto_install = true,
                highlight = { enable = true },
                indent = { enable = true },
                rainbow = {
                    enable = true,
                    extended_mode = true,
                    max_file_lines = nil,
                },
            })
        end,
    },
    {
        'nvim-treesitter/nvim-treesitter-textobjects',
        event = 'VeryLazy',
        dependencies = { 'nvim-treesitter/nvim-treesitter' },
        config = function()
            ---@diagnostic disable-next-line: missing-fields
            require('nvim-treesitter.configs').setup({
                textobjects = {
                    select = {
                        enable = true,
                        lookahead = true, -- automatically jump forward to textobj, similar to targets.vim
                        keymaps = {
                            -- You can use the capture groups defined in textobjects.scm
                            ['af'] = { query = '@function.outer', desc = 'Select entire function' },
                            ['if'] = { query = '@function.inner', desc = 'Select function body' },
                            ['ac'] = { query = '@class.outer', desc = 'Select entire class' },
                            ['ic'] = { query = '@class.inner', desc = 'Select class body' },
                            -- ['as'] = { query = '@scope', query_group = 'locals', desc = 'Select language scope' },
                            ['ia'] = { query = '@assignment.rhs', desc = 'Select assignment rhs' },
                            ['ip'] = { query = '@parameter.inner', desc = 'Select parameter' },
                        },
                        selection_modes = {
                            ['@parameter.outer'] = 'v', -- charwise
                            ['@function.outer'] = 'V', -- linewise
                            ['@class.outer'] = '<c-v>', -- blockwise
                            ['@assignment.rhs'] = 'v', -- charwise
                        },
                    },
                    swap = {
                        enable = true,
                        swap_next = {
                            ['<leader>sa'] = { query = '@parameter.inner', desc = 'Swap Argument (next)' },
                        },
                        swap_previous = {
                            ['<leader>sA'] = { query = '@parameter.inner', desc = 'Swap Argument (prev)' },
                        },
                    },
                },
            })

            local ts_repeat_move = require('nvim-treesitter.textobjects.repeatable_move')
            -- Repeat movement with ; and ,
            vim.keymap.set({ 'n', 'x', 'o' }, ';', ts_repeat_move.repeat_last_move_next)
            vim.keymap.set({ 'n', 'x', 'o' }, ',', ts_repeat_move.repeat_last_move_previous)

            -- NOTE: You need this, otherwise the normal ; and , won't work for fFtT
            vim.keymap.set({ 'n', 'x', 'o' }, 'f', ts_repeat_move.builtin_f_expr, { expr = true })
            vim.keymap.set({ 'n', 'x', 'o' }, 'F', ts_repeat_move.builtin_F_expr, { expr = true })
            vim.keymap.set({ 'n', 'x', 'o' }, 't', ts_repeat_move.builtin_t_expr, { expr = true })
            vim.keymap.set({ 'n', 'x', 'o' }, 'T', ts_repeat_move.builtin_T_expr, { expr = true })
        end,
    },
    -- NOTE: Might conflict with treeobj but it adds IQ and AQ for any quotes which is cool
    -- The rest can probably be disabled, but I will try it out and only disable if it annoys me
    -- Also it does (/{ etc ignore whitespace but )/} don't, which is interesting ig
    { 'echasnovski/mini.ai', version = false, opts = {}, lazy = false },
}
