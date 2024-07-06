return {
    'nvimdev/lspsaga.nvim',
    dependencies = {
        'nvim-treesitter/nvim-treesitter',
        'nvim-tree/nvim-web-devicons',
    },
    config = function()
        require('lspsaga').setup({
            lightbulb = {
                enable = false,
                sign = false,
                virtual_text = true,
            },
            implement = {
                sign = false,
                virtual_text = true,
            },
            floaterm = {
                height = 0.7,
                width = 0.7,
            },
            outline = {
                layout = 'float',
            },
        })
        local diagnostic = require('lspsaga.diagnostic')

        vim.keymap.set('n', 'K', ':Lspsaga hover_doc<cr>', { desc = 'Display Docs' })
        vim.keymap.set('n', 'R', ':Lspsaga rename<cr>', { desc = '[R]ename' })

        vim.keymap.set('n', '<leader>os', '<cmd>Lspsaga outline<cr>', { desc = '[T]erminal' })

        vim.keymap.set({ 'n', 'i' }, '<M-Enter>', '<cmd>Lspsaga code_action<cr><Esc>', { desc = 'Code Actions' })
        vim.keymap.set('n', '<leader>ca', ':Lspsaga code_action<cr><Esc>', { desc = '[C]ode [A]ctions' })

        vim.keymap.set('n', 'ge', function()
            diagnostic:goto_next({ severity = vim.diagnostic.severity.WARN })
        end, { desc = '[G]oto [E]rror' })
        vim.keymap.set('n', 'gE', function()
            diagnostic:goto_prev({ severity = vim.diagnostic.severity.WARN })
        end, { desc = '[G]oto [E]rror (prev)' })
        vim.keymap.set(
            'n',
            '<leader>dw',
            '<cmd>Lspsaga show_workspace_diagnostics ++normal<cr>',
            { desc = '[D]iagnostics for [W]orkspace' }
        )

        vim.keymap.set({ 'n', 't' }, '<A-t>', '<cmd>Lspsaga term_toggle<cr>', { desc = '[T]erminal' })
    end,
}
