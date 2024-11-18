return {
    'stevearc/conform.nvim',
    event = { 'BufWritePre' },
    cmd = { 'ConformInfo' },
    keys = {
        { '<leader>ft', '<cmd>FormatToggle<cr>', desc = '[F]ormat [T]oggle Globally' },
        { '<leader>fT', '<cmd>FormatToggle!<cr>', desc = '[F]ormat [T]oggle Locally' },
        { '<leader>ff', '<cmd>Format<cr>', desc = '[F]ormat [F]ile' },
        { '<leader>f', '<cmd>Format<cr><esc>', desc = '[F]ormat', mode = 'v' },
    },
    ---@module "conform"
    ---@type conform.setupOpts
    opts = {
        formatters_by_ft = {
            -- ['lua'] = { 'stylua' },
            -- ['c'] = { 'clang-format' },
            -- ['python'] = { 'isort', 'black' },
            -- ['rust'] = { 'rustfmt' },
            -- ['go'] = { 'gofumpt', 'goimports-reviser' },
            -- ['markdown'] = { 'prettierd', 'prettier', stop_after_first = true },
            -- ['yaml'] = { 'prettierd' },
            -- ['json'] = { 'jq' },
            -- ['html'] = { 'prettierd', 'prettier', stop_after_first = true },
            -- ['css'] = { 'prettierd', 'prettier', stop_after_first = true },
            -- ['javascript'] = { 'prettierd', 'prettier', stop_after_first = true },
            -- ['typescript'] = { 'prettierd', 'prettier', stop_after_first = true },
        },
        format_on_save = function(bufnr)
            -- Disable with a global or buffer local variable
            if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
                return
            end
            return { timeout_ms = 500, lsp_fallback = true }
        end,
        notify_on_error = true,
        lsp_fallback = true,
    },
}
