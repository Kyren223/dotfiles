return {
    'ThePrimeagen/harpoon',
    branch = 'harpoon2',
    dependencies = { 'nvim-lua/plenary.nvim' },
    keys = { '<C-e>', '<leader>a', '<C-F1>', '<C-F2>', '<C-F3>', '<C-F4>', '<C-F5>' },
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
            local select = function()
                harpoon:list():select(i)
            end
            vim.keymap.set('n', string.format('<C-F%d>', i), select)
        end
    end,
}
