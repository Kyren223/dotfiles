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
            build = ':MasonUpdate',
            config = function()
                local language_servers = require('custom.config.language-servers')
                local ensure_installed = vim.tbl_filter(function(key)
                    local server = language_servers[key]
                    if type(server) == 'table' then
                        if server.mason ~= nil then
                            return server.mason
                        end
                        return true
                    else
                        return server
                    end
                end, vim.tbl_keys(language_servers))
                require('mason-lspconfig').setup({ ensure_installed = ensure_installed, auto_install = true })
            end,
        },
    },
    config = function()
        require('custom.config.lsp')
    end,
}
