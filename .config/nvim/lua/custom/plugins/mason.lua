return {
    {
        'williamboman/mason.nvim',
        lazy = false,
        opts = {
            ui = {
                icons = {
                    package_installed = '✓',
                    package_pending = '➜',
                    package_uninstalled = '✗',
                },
            },
        },
    },
    {
        'WhoIsSethDaniel/mason-tool-installer.nvim',
        lazy = false,
        opts = {
            ensure_installed = {
                'stylua', -- lua formatting
                'clang-format', -- C/C++ formatter
                'codelldb', -- C/C++ debugger
                'cpplint', -- C/C++ linter
                'black', -- python formatter
                'isort', -- python formatter for imports
                'flake8', -- python linter
                'gofumpt', -- go formatter
                'golangci-lint', -- go linter
                'prettierd', -- multi-lang formatter
                'prettier', -- prettierd but slower, used as a fallback
                'jq', -- json formatter
                'jsonlint', -- json linter
                'shellcheck', -- bash linter
                'beautysh', -- shell formatter
            },
        },
    },
}
