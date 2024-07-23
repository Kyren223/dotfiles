return {
    -- NOTE: Make sure the order is as follows:
    -- Mason loads -> Mason lspconfig loads -> Lspconfig loads
    'neovim/nvim-lspconfig',
    event = { 'BufReadPre', 'BufNewFile' },
    dependencies = {
        'hrsh7th/cmp-nvim-lsp',
        { 'antosha417/nvim-lsp-file-operations', conifg = true },
        {
            'williamboman/mason-lspconfig.nvim',
            dependencies = {
                { 'williamboman/mason.nvim', cmd = 'Mason' },
                'WhoIsSethDaniel/mason-tool-installer.nvim',
            },
            build = ':MasonUpdate',
            config = function()
                require('custom.config.mason')
            end,
        },
    },
    config = function()
        require('custom.config.lsp')
    end,
}
