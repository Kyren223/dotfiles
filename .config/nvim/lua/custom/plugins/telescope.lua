return {
    'nvim-telescope/telescope.nvim',
    tag = '0.1.5',
    dependencies = {
        'nvim-lua/plenary.nvim',
        -- { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
        -- 'nvim-telescope/telescope-ui-select.nvim',
    },
    cmd = 'Telescope',
    config = function()
        require('custom.config.telescope')
    end,
    keys = {
        '<leader>fs',
        '<leader>fa',
        '<leader>fh',
        '<leader>fm',
        '<leader>lv',
        '<leader>f.',
        '<leader>th',
    },
}
