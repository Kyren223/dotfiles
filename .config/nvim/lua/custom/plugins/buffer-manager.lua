return {
    'j-morano/buffer_manager.nvim',
    dependencies = { 'nvim-lua/plenary.nvim' },
    keys = {
        {
            '<leader>bl',
            function()
                require('buffer_manager.ui').toggle_quick_menu()
            end,
            desc = '[B]uffer [L]ist',
        },
    },
}
