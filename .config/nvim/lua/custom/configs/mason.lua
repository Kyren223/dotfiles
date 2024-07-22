-- NOTE: Not language servers but still make sure mason installs them
local ensure_installed = {
    stylua = true, -- lua formatting
}
local servers = require('custom.configs.language-servers')

require('mason').setup({
    ui = {
        icons = {
            package_installed = '✓',
            package_pending = '➜',
            package_uninstalled = '✗',
        },
    },
})

local servers_to_install = vim.tbl_filter(function(key)
    local server = servers[key]
    if type(server) == 'table' then
        return true
    else
        return server
    end
end, vim.tbl_keys(servers))

vim.list_extend(ensure_installed, servers_to_install)
require('mason-lspconfig').setup({ ensure_installed = servers_to_install })

require('mason-tool-installer').setup({
    ensure_installed = {
        'stylua', -- lua formatter
    },
})
