return {
    'ThePrimeagen/harpoon',
    branch = 'harpoon2',
    dependencies = { 'nvim-lua/plenary.nvim' },
    keys = {
        '<C-e>',
        '<leader>a',
        '<leader>1',
        '<leader>2',
        '<leader>3',
        '<leader>4',
        '<leader>5',
        '<leader>6',
        '<leader>7',
        '<leader>8',
        '<leader>9',
    },
    config = function()
        local harpoon = require('harpoon')
        harpoon:setup()

        vim.keymap.set('n', '<leader>a', function()
            harpoon:list():add()
        end)
        vim.keymap.set('n', '<C-e>', function()
            harpoon.ui:toggle_quick_menu(harpoon:list())
        end)

        for i = 1, 9 do
            vim.keymap.set('n', string.format('<leader>%d', i), function()
                harpoon:list():select(i)
            end)
        end
    end,
}
