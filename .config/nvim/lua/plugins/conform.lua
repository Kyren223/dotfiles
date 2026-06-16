return {
    'stevearc/conform.nvim',
    event = 'VeryLazy',
    cmd = { 'ConformInfo' },
    keys = {
        { '<leader>ft', '<cmd>FormatToggle<cr>', desc = '[F]ormat [T]oggle Globally' },
        { '<leader>fT', '<cmd>FormatToggle!<cr>', desc = '[F]ormat [T]oggle Locally' },
        { '<leader>ff', '<cmd>Format<cr>', desc = '[F]ormat [F]ile' },
    },
    ---@module "conform"
    ---@type conform.setupOpts
    opts = {
        formatters_by_ft = {
            -- asm = { 'asmfmt' },
            -- nasm = { 'asmfmt' },
            ['lua'] = { 'stylua' },
            ['go'] = { 'gofumpt', 'goimports-reviser' },
            ['markdown'] = { 'prettierd' },
            ['yaml'] = { 'prettierd' },
            ['json'] = { 'jq' },
            ['jsonc'] = { 'jq' },
            ['html'] = { 'prettierd' },
            ['css'] = { 'prettierd' },
            ['javascript'] = { 'prettierd' },
            ['typescript'] = { 'prettierd' },
            -- ['c'] = { 'clang-format' },
            -- ['python'] = { 'isort', 'black' },
            -- ['rust'] = { 'rustfmt' },
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
