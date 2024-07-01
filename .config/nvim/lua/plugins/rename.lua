return {
    'smjonas/inc-rename.nvim',
    config = function()
        require('inc_rename').setup({})

        local test = 5
        print(test)

        vim.keymap.set('n', 'R', ':IncRename ')
        vim.keymap.set('n', 'rr', function()
            return ':IncRename ' .. vim.fn.expand('<cword>')
        end, { expr = true })
    end,
}
