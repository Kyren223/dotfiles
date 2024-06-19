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
            local lspconfig = require("lspconfig")
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

            vim.keymap.set('n', 'gh', vim.lsp.buf.hover, { desc = "[G]oto [H]over" })
            vim.keymap.set('n', 'gd', vim.lsp.buf.definition, { desc = "[G]oto [D]efinition" })
            vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, { desc = "[C]ode [A]ction" })
            vim.keymap.set('n', '<M-Enter>', vim.lsp.buf.code_action, { desc = "Code Actions" })
        end
    }
}
