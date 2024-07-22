return {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons', 'linrongbin16/lsp-progress.nvim' },
    event = 'BufWinEnter',
    config = function()
        require('custom.configs.statusline')
    end,
}
