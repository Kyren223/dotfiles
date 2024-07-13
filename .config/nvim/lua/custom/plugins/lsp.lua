return {
    {
        'neovim/nvim-lspconfig',
        lazy = false,
        dependencies = {
            'williamboman/mason.nvim',
            'williamboman/mason-lspconfig.nvim',

            'nvimtools/none-ls.nvim',

            -- NOTE: [Good alternative](https://github.com/rachartier/tiny-inline-diagnostic.nvim)
            -- although, this plugin is amazing, so I wouldn't switch it most likely
            { 'https://git.sr.ht/~whynothugo/lsp_lines.nvim' },

            {
                'nvimdev/lspsaga.nvim',
                dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' },
            },
            {
                'folke/lazydev.nvim',
                ft = 'lua',
                opts = { library = { { path = 'luvit-meta/library', words = { 'vim%.uv' } } } },
            },
            {
                'ray-x/lsp_signature.nvim',
                event = 'VeryLazy',
            },

            -- AUtoformatting
            -- 'stevear/conform.nvim',

            -- Schema info
            -- 'b0o/SchemaStore.nvim',
        },
        config = function()
            require('custom.lsp')
        end,
    },
}
