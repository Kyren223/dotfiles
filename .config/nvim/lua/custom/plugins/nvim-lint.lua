return {
    'mfussenegger/nvim-lint',
    lazy = false,
    config = function()
        local lint = require('lint')
        lint.linters_by_ft = {
            c = { 'clangtidy' },
            cpp = { 'clangtidy' },
            go = { 'golangci-lint' },
            python = { 'flake8' },
            json = { 'jsonlint' },
            bash = { 'shellcheck' },
        }

        vim.api.nvim_create_autocmd({ 'BufEnter', 'BufWritePost', 'InsertLeave', 'TextChanged', 'TextChangedI' }, {
            group = vim.api.nvim_create_augroup('nvim-lint', { clear = true }),
            callback = function()
                require('lint').try_lint()
            end,
        })
    end,
}
