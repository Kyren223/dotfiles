return {
    'mrcjkb/rustaceanvim',
    version = '^5',
    lazy = false, -- already lazy
    init = function()
        ---@type RustaceanOpts
        vim.g.rustaceanvim = {
            ---@type RustaceanToolsOpts
            tools = {
                float_win_config = {
                    border = 'rounded',
                },
            },
            ---@type RustaceanLspClientOpts
            server = {
                on_attach = function(_, bufnr)
                    local keymaps = {
                        { { 'n', 'i' }, '<M-Enter>', '<cmd>RustLsp codeAction<cr>', { desc = 'Code Action' } },
                    }

                    for _, keymap in ipairs(keymaps) do
                        local modes = keymap[1]
                        local lhs = keymap[2]
                        local rhs = keymap[3]
                        local opts = keymap[4]
                        opts.buffer = bufnr

                        vim.keymap.set(modes, lhs, rhs, opts)
                    end
                end,
                default_settings = {
                    ['rust-analyzer'] = {
                        semanticHighlighting = {
                            operator = { specialization = { enable = true } },
                            punctuation = { enable = true, specialization = { enable = true } },
                        },
                    },
                },
            },
            ---@type RustaceanDapOpts
            dap = {},
        }
    end,
}
