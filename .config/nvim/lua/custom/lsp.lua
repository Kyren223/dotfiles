-- NOTE: A list of language servers (and potentially their config)
-- Accepts either true to enable, false to disable or a table with settings
local servers = {
    lua_ls = true, -- lua
    clangd = true, -- C/C++
    gradle_ls = true, -- java package manager
    jdtls = true, -- java eclipse lsp
    kotlin_language_server = true, -- kotlin
    pyright = true, -- python
    rust_analyzer = true, -- rust
    bashls = true, -- bash
    taplo = true, -- toml
    lemminx = true, -- xml
    yamlls = true, -- yaml
    jsonls = true, -- json
}

-- NOTE: Not language servers but still make sure mason installs them
local ensure_installed = {
    stylua = true, -- lua formatting
}

local capabilities = nil
if pcall(require, 'cmp_nvim_lsp') then
    capabilities = require('cmp_nvim_lsp').default_capabilities()
end

local servers_to_install = vim.tbl_filter(function(key)
    local server = servers[key]
    if type(server) == 'table' then
        return true
    else
        return server
    end
end, vim.tbl_keys(servers))

require('mason').setup()
vim.list_extend(ensure_installed, servers_to_install)
require('mason-lspconfig').setup({ ensure_installed = servers_to_install })

local lspconfig = require('lspconfig')
for name, config in pairs(servers) do
    if config == true then
        ---@diagnostic disable-next-line: cast-local-type
        config = {}
    end
    config = vim.tbl_deep_extend('force', {}, {
        capabilities = capabilities,
    }, config)

    lspconfig[name].setup(config)
end

vim.api.nvim_create_autocmd('LspAttach', {
    callback = function(args)
        local bufnr = args.buf
        local client = assert(vim.lsp.get_client_by_id(args.data.client_id), 'must have valid client')

        -- TODO: Check if I need this line
        -- vim.opt_local.omnifunc = "v:lua.vim.lsp.omnifunc"

        local settings = servers[client.name]
        if type(settings) ~= 'table' then
            ---@diagnostic disable-next-line: cast-local-type
            settings = {}
        end

        -- Override server capabilities
        if settings.server_capabilities then
            for k, v in pairs(settings.server_capabilities) do
                if v == vim.NIL then
                    v = nil
                end
                client.server_capabilities[k] = v
            end
        end
    end,
})

-- TODO: Understand what this is
-- -- Autoformatting Setup
-- require('conform').setup({
--     formatters_by_ft = {
--         lua = { 'stylua' },
--     },
-- })
--
-- vim.api.nvim_create_autocmd('BufWritePre', {
--     callback = function(args)
--         require('conform').format({
--             bufnr = args.buf,
--             lsp_fallback = true,
--             quiet = true,
--         })
--     end,
-- })
--
-- require('lsp_lines').setup()
-- vim.diagnostic.config({ virtual_text = false })

print('Sourced lsp.lua')
