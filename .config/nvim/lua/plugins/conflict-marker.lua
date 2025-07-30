return {
    'tronikelis/conflict-marker.nvim',
    opts = {
        on_attach = function(conflict)
            local MID = '^=======$'

            vim.keymap.set('n', '<leader>M', function()
                vim.cmd('?' .. MID)
            end, { buffer = conflict.bufnr })

            vim.keymap.set('n', '<leader>m', function()
                vim.cmd('/' .. MID)
            end, { buffer = conflict.bufnr })
        end,
    },
    event = { 'BufReadPre', 'BufNewFile' },
}
