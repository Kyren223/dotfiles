return {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons', 'linrongbin16/lsp-progress.nvim' },
    event = 'VeryLazy',
    config = function()
        require('custom.configs.lualine')
    end,
}
