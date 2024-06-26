return {
    {
        "williamboman/mason.nvim",
        config = function()
            require("mason").setup()
        end
    },

    {
        "williamboman/mason-lspconfig.nvim",
        config = function()
            require("mason-lspconfig").setup({
                ensure_installed = {
                    "lua_ls",
                    "clangd",
                    "gradle_ls",
                    "jdtls",
                    "kotlin_language_server",
                    "pyright",
                    "rust_analyzer",
                    "taplo",
                    "bashls",
                    "lemminx",
                    "yamlls"
                }
            })
        end
    },

    {
        "neovim/nvim-lspconfig",
        config = function()
            local capabilities = require("cmp_nvim_lsp").default_capabilities()

            local lspconfig = require("lspconfig")
            lspconfig.lua_ls.setup({
                capabilities = capabilities
            })

            lspconfig.clangd.setup({
                capabilities = capabilities
            })
            lspconfig.gradle_ls.setup({
                capabilities = capabilities
            })
            lspconfig.jdtls.setup({
                capabilities = capabilities
            })
            lspconfig.kotlin_language_server.setup({
                capabilities = capabilities
            })
            lspconfig.pyright.setup({
                capabilities = capabilities
            })
            lspconfig.rust_analyzer.setup({
                capabilities = capabilities
            })
            lspconfig.taplo.setup({
                capabilities = capabilities
            })
            lspconfig.bashls.setup({
                capabilities = capabilities
            })
            lspconfig.lemminx.setup({
                capabilities = capabilities
            })
            lspconfig.yamlls.setup({
                capabilities = capabilities
            })

            vim.keymap.set('n', 'gh', vim.lsp.buf.hover, { desc = "[G]oto [H]over" })
            vim.keymap.set('n', 'gd', vim.lsp.buf.definition, { desc = "[G]oto [D]efinition" })
            vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, { desc = "[C]ode [A]ction" })
            vim.keymap.set('n', '<M-Enter>', vim.lsp.buf.code_action, { desc = "Code Actions" })
        end
    }
}
