return {
    {
        'nvim-telescope/telescope.nvim',
        tag = '0.1.5',
        dependencies = { 'nvim-lua/plenary.nvim' },
        config = function()
            local builtin = require("telescope.builtin")

            local find_files = function ()
                builtin.find_files({ follow = true })
            end

            local grep = function (grep_func)
                return function() grep_func({ additional_args = { "--follow" } }) end
            end

            vim.keymap.set('n', '<leader>th', builtin.colorscheme, { desc = "List [Th]eme" })
            vim.keymap.set('n', '<leader>ff', find_files, { desc = '[F]ind [F]iles' })
            vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = '[F]ind [H]elp' })
            vim.keymap.set('n', '<leader>fk', builtin.keymaps, { desc = '[F]ind [K]eymaps' })
            vim.keymap.set('n', '<leader>fs', builtin.builtin, { desc = '[F]ind [S]elect Telescope' })
            -- vim.keymap.set('n', '<leader>fw', builtin.grep_string, { desc = '[F]ind current [W]ord' })
            -- vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = '[F]ind by [G]rep' })
            vim.keymap.set('n', '<leader>fw', grep(builtin.grep_string), { desc = '[F]ind current [W]ord' })
            vim.keymap.set('n', '<leader>fg', grep(builtin.live_grep), { desc = '[F]ind by [G]rep' })
            vim.keymap.set('n', '<leader>f.', builtin.oldfiles, { desc = '[F]ind Recent Files ("." for repeat)' })

            vim.keymap.set('n', 'gh', vim.lsp.buf.hover, { desc = "[G]oto [H]over" })
            vim.keymap.set('n', 'gd', builtin.lsp_definitions, { desc = "[G]oto [D]efinition" })
            vim.keymap.set('n', 'gu', builtin.lsp_references, { desc = "[G]oto [U]sages" })
            vim.keymap.set('n', '<leader>s', builtin.lsp_workspace_symbols, { desc = "Show [S]tructure" })
            vim.keymap.set('n', '<leader>ds', builtin.lsp_document_symbols, { desc = "Show [S]tructure" })
            vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, { desc = "[C]ode [A]ction" })
            vim.keymap.set('n', '<M-Enter>', vim.lsp.buf.code_action, { desc = "Code Actions" })
            vim.keymap.set('n', 'R', vim.lsp.buf.rename, { desc = "[R]ename" })
        end
    },
    {
        "nvim-telescope/telescope-ui-select.nvim",
        config = function()
            local telescope = require("telescope")
            telescope.setup({
                extensions = {
                    ["ui_select"] = {
                        require("telescope.themes").get_dropdown {}
                    }
                }
            })
            telescope.load_extension("ui-select")
        end
    }
}

