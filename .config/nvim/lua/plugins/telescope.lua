return {
    { 'nvim-telescope/telescope-fzf-native.nvim' },
    { 'nvim-telescope/telescope-ui-select.nvim' },
    {
        'nvim-telescope/telescope.nvim',
        tag = '0.1.5',
        dependencies = { 'nvim-lua/plenary.nvim' },
        config = function()
            local builtin = require('telescope.builtin')

            vim.keymap.set('n', '<leader>h', builtin.help_tags, { desc = '[H]elp' })
            vim.keymap.set('n', '<leader>m', builtin.man_pages, { desc = '[M]an Pages' })
            vim.keymap.set('n', '<leader>th', builtin.colorscheme, { desc = 'List [Th]eme' })
            vim.keymap.set('n', '<leader>ob', builtin.buffers, { desc = '[O]pen [B]uffers' })

            vim.keymap.set('n', '<leader>fs', builtin.find_files, { desc = '[F]ile [S]ystem' })
            vim.keymap.set('n', '<leader>fw', builtin.grep_string, { desc = '[F]ind current [W]ord' })
            vim.keymap.set('n', '<leader>lv', builtin.live_grep, { desc = '[L]ive [G]rep' })
            vim.keymap.set('n', '<leader>f.', builtin.oldfiles, { desc = '[F]ind Recent Files ("." for old)' })

            vim.keymap.set('n', 'gd', builtin.lsp_definitions, { desc = '[G]oto [D]efinition' })
            vim.keymap.set('n', 'gu', builtin.lsp_references, { desc = '[G]oto [U]sages' })
            vim.keymap.set('n', 'gi', builtin.lsp_implementations, { desc = '[G]oto [I]mplementations' })
            vim.keymap.set('n', 'gt', builtin.lsp_type_definitions, { desc = '[G]oto [T]ype Definitions' })
            vim.keymap.set('n', 'gw', builtin.diagnostics, { desc = '[G]oto [W]arnings' })

            vim.keymap.set('n', '<leader>ds', builtin.lsp_document_symbols, { desc = '[D]ocument [S]symbols' })
            vim.keymap.set('n', '<leader>ps', builtin.lsp_workspace_symbols, { desc = '[P]roject [S]ymbols' })

            -- TODO: Look into the following
            -- builtin.git_commits
            -- builtin.git_branches
            -- builtin.git_status
            -- builtin.git_stash

            local telescope = require('telescope')
            telescope.setup({
                defaults = {
                    mappings = {
                        i = {
                            -- map actions.which_key to <C-h> (default: <C-/>)
                            -- actions.which_key shows the mappings for your picker,
                            -- e.g. git_{create, delete, ...}_branch for the git_branches picker
                            ['<C-h>'] = 'which_key',
                            ['<C-s>'] = 'cycle_previewers_next',
                            ['<C-a>'] = 'cycle_previewers_prev',
                        },
                    },
                },
                pickers = {
                    find_files = { follow = true },
                    grep_string = { additional_args = '--follow' },
                    live_grep = { additional_args = '--follow' },
                },
                extensions = {
                    ui_select = {
                        require('telescope.themes').get_dropdown({}),
                    },
                    fzf = {
                        fuzzy = true, -- false will only do exact matching
                        override_generic_sorter = true, -- override the generic sorter
                        override_file_sorter = true, -- override the file sorter
                        case_mode = 'smart_case', -- or "ignore_case" or "respect_case"
                        -- the default case_mode is "smart_case"
                    },
                },
            })

            telescope.load_extension('ui-select')
            telescope.load_extension('fzf')
        end,
    },
}
