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

        -- NOTE: most if not all of clangt-idy warnings are
        -- also reported by clangd, so this function filters clang-tidy warnings
        -- to avoid duplication of warnings
        local clangtidy_parser = lint.linters.clangtidy.parser
        lint.linters.clangtidy.parser = function(output, bufnr, linter_cwd)
            local diagnostics = clangtidy_parser(output, bufnr, linter_cwd)
            diagnostics = vim.tbl_filter(function(diagnostic)
                return diagnostic.severity ~= vim.diagnostic.severity.WARN
            end, diagnostics)
            return diagnostics
        end
    end,
}
