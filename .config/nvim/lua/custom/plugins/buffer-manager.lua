return {
    'j-morano/buffer_manager.nvim',
    dependencies = { 'nvim-lua/plenary.nvim' },
    keys = {
        {
            '<leader>e',
            function()
                require('buffer_manager.ui').toggle_quick_menu()
            end,
        },
    },
}
