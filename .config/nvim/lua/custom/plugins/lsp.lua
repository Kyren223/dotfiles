return {
    {
        'neovim/nvim-lspconfig',
        lazy = false,
        dependencies = {
            'williamboman/mason.nvim',
            'williamboman/mason-lspconfig.nvim',

            {
                'folke/lazydev.nvim',
                ft = 'lua',
                opts = { library = { { path = 'luvit-meta/library', words = { 'vim%.uv' } } } },
            },

            { 'j-hui/fidget.nvim', opts = { notification = { window = { winblend = 0 } } } },

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
