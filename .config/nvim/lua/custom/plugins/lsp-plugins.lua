return {
    {
        'nvimtools/none-ls.nvim',
        config = function()
            local null_ls = require('null-ls')
            null_ls.setup({
                sources = {
                    null_ls.builtins.formatting.stylua,
                },
            })
        end,
    },
    -- NOTE: [Good alternative](https://github.com/rachartier/tiny-inline-diagnostic.nvim)
    -- although, this plugin is amazing, so I wouldn't switch it most likely
    {
        'https://git.sr.ht/~whynothugo/lsp_lines.nvim',
        event = 'BufEnter',
        config = function()
            require('lsp_lines').setup()
            vim.keymap.set('n', '<Leader>dt', require('lsp_lines').toggle, { desc = '[D]iagnostics [T]oggle inline' })
        end,
    },
    {
        -- FIXME: fork the repo and fix the following issues
        -- Make both insert and normal be toggelable rather than insert always showing and normal toggleable
        'ray-x/lsp_signature.nvim',
        event = 'VeryLazy',
        opts = {
            bind = true, -- This is mandatory, otherwise border config won't get registered.
            handler_opts = { border = 'single' },
            doc_lines = 0,
            hint_enable = false,
        },
    },
    {
        'folke/lazydev.nvim',
        ft = 'lua',
        opts = { library = { { path = 'luvit-meta/library', words = { 'vim%.uv' } } } },
    },
    {
        'nvimdev/lspsaga.nvim',
        dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' },
        event = 'LspAttach',
        opts = {
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
            -- TODO: Change <C-k> in rename to smthing else
            -- bcz I am using <C-k> for moving between windows
            -- Maybe <C-c> for abort, <cr> for confirm
        },
    },

    -- AUtoformatting
    -- 'stevear/conform.nvim',

    -- Schema info
    -- 'b0o/SchemaStore.nvim',
}
