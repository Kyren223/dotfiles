return {
    {
        'williamboman/mason.nvim',
        lazy = false,
        config = function()
            require('mason').setup()
        end,
    },
    {
        'williamboman/mason-lspconfig.nvim',
        lazy = false,
        config = function()
            require('mason-lspconfig').setup({
                ensure_installed = {
                    'lua_ls',
                    'clangd',
                    'gradle_ls',
                    'jdtls',
                    'kotlin_language_server',
                    'pyright',
                    'rust_analyzer',
                    'taplo',
                    'bashls',
                    'lemminx',
                    'yamlls',
                },
            })
        end,
    },
    {
        'neovim/nvim-lspconfig',
        lazy = false,
        config = function()
            local lspconfig = require('lspconfig')
            lspconfig.lua_ls.setup({})
            lspconfig.clangd.setup({})
            lspconfig.gradle_ls.setup({})
            lspconfig.jdtls.setup({})
            lspconfig.kotlin_language_server.setup({})
            lspconfig.pyright.setup({})
            lspconfig.rust_analyzer.setup({})
            lspconfig.taplo.setup({})
            lspconfig.bashls.setup({})
            lspconfig.lemminx.setup({})
            lspconfig.yamlls.setup({})
        end,
    },
}
