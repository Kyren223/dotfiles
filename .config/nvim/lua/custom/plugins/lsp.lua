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

            -- FIXME: Starts with a black blackground
            -- Desired behaviour is same color as background or transparent
            -- Progress ui
            { 'j-hui/fidget.nvim', opts = {} },

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
