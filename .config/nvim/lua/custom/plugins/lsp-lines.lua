return {
    -- NOTE: [Good alternative](https://github.com/rachartier/tiny-inline-diagnostic.nvim)
    -- although, this plugin is amazing, so I wouldn't switch it most likely
    'https://git.sr.ht/~whynothugo/lsp_lines.nvim',
    event = 'BufEnter',
    config = function()
        require('lsp_lines').setup()
        vim.keymap.set('n', '<Leader>dt', require('lsp_lines').toggle, { desc = '[D]iagnostics [T]oggle inline' })
    end,
}
