local telescope = require('telescope')
telescope.setup({
    pickers = {
        find_files = { follow = true },
        grep_string = { additional_args = '--follow' },
        live_grep = { additional_args = '--follow' },
    },
    extensions = {
        fzf = {
            fuzzy = true, -- false will only do exact matching
            override_generic_sorter = true, -- override the generic sorter
            override_file_sorter = true, -- override the file sorter
            case_mode = 'smart_case', -- default "smart_case" or "ignore_case" or "respect_case"
        },
        ['ui-select'] = {
            require('telescope.themes').get_dropdown({}),
        },
    },
})

pcall(telescope.load_extension('ui-select'))
pcall(telescope.load_extension('fzf'))

local builtin = require('telescope.builtin')

vim.keymap.set('n', '<leader>fs', builtin.find_files, { desc = '[F]ile [S]ystem' })
vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = '[F]ind [H]elp' })
vim.keymap.set('n', '<leader>fm', builtin.man_pages, { desc = '[F]ind [M]an Pages' })
-- vim.keymap.set('n', '<leader>fw', builtin.grep_string, { desc = '[F]ind current [W]ord' })
vim.keymap.set('n', '<leader>lv', builtin.live_grep, { desc = '[L]ive [G]rep' })
vim.keymap.set('n', '<leader>f.', builtin.oldfiles, { desc = '[F]ind Recent Files' })
vim.keymap.set('n', '<leader>th', builtin.colorscheme, { desc = 'List [Th]eme' })
-- vim.keymap.set('n', '<leader>ob', builtin.buffers, { desc = '[O]pen [B]uffers' })

vim.keymap.set('n', 'gd', builtin.lsp_definitions, { desc = '[G]oto [D]efinition' })
vim.keymap.set('n', 'gu', builtin.lsp_references, { desc = '[G]oto [U]sages' })
vim.keymap.set('n', 'gi', builtin.lsp_implementations, { desc = '[G]oto [I]mplementations' })
-- vim.keymap.set('n', 'gt', builtin.lsp_type_definitions, { desc = '[G]oto [T]ype Definitions' })
vim.keymap.set('n', 'gw', builtin.diagnostics, { desc = '[G]oto [W]arnings' })

vim.keymap.set('n', '<leader>ds', builtin.lsp_document_symbols, { desc = '[D]ocument [S]symbols' })
vim.keymap.set('n', '<leader>ps', builtin.lsp_workspace_symbols, { desc = '[P]roject [S]ymbols' })

vim.keymap.set('n', '<leader>sb', builtin.git_branches, { desc = '[S]earch [B]ranches' })
vim.keymap.set('n', '<leader>sc', builtin.git_commits, { desc = '[S]earch [C]ommits' })

-- TODO: Look into the following
-- builtin.git_commits
-- builtin.git_branches
-- builtin.git_status
-- builtin.git_stash
