return {
    'pwntester/octo.nvim',
    cmd = 'Octo',
    keys = {
        { '<leader>gi', '<cmd>Octo issue search<cr>', desc = '[G]ithub [I]ssues (local)' },
        { '<leader>pr', '<cmd>Octo pr search<cr>', desc = 'Github [PR]s (local)' },
        { '<leader>gI', '<cmd>Octo search is:issue is:open author:@me<cr>', desc = '[G]ithub [I]ssues (global)' },
        { '<leader>pR', '<cmd>Octo search is:pr author:@me<cr>', desc = 'Github [PR]s (global)' },
    },
    config = function()
        require('octo').setup({ suppress_missing_scope = { projects_v2 = true } })

        vim.treesitter.language.register('markdown', 'octo')
        vim.api.nvim_create_autocmd('FileType', {
            pattern = 'octo',
            callback = function()
                -- Autocomplete for @ (user mention) and # (issue)
                vim.keymap.set('i', '@', '@<C-x><C-o>', { silent = true, buffer = true })
                vim.keymap.set('i', '#', '#<C-x><C-o>', { silent = true, buffer = true })
            end,
        })
    end,
}
