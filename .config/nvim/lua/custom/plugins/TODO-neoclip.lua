return {
    'AckslD/nvim-neoclip.lua',
    dependencies = {
        { 'kkharji/sqlite.lua',           module = 'sqlite' },
        { 'nvim-telescope/telescope.nvim' },
    },
    config = function()
        require('neoclip').setup({
            enable_persistent_history = true,
            keys = {
                telescope = {
                    i = {
                        paste = '<C-y>',
                        paste_behind = '<C-S-Y>',
                    },
                },
            }
        })
        -- NOTE: Using `plus` to set the plus register to the selected value
        vim.keymap.set('n', '<leader>nc', ':Telescope neoclip plus<cr>', { desc = '[N]eo[c]lip History' })
    end,
}
