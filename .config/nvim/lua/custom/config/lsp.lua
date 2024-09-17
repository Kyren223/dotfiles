local lspconfig = require('lspconfig')
local capabilities = require('cmp_nvim_lsp').default_capabilities()

local servers = require('custom.config.language-servers')
for name, config in pairs(servers) do
    if config == false then
        goto continue
    end
    if config == true then
        ---@diagnostic disable-next-line: cast-local-type
        config = {}
    end

    -- NOTE: there must be a better way to do it, but it will do for now
    if name == 'markdown_oxide' then
        ---@diagnostic disable-next-line: cast-local-type
        config = vim.tbl_deep_extend('force', {}, {
            capabilities = vim.tbl_deep_extend('force', capabilities, {
                workspace = {
                    didChangeWatchedFiles = {
                        dynamicRegistration = true,
                    },
                },
            }),
        }, config)
    else
        ---@diagnostic disable-next-line: cast-local-type
        config = vim.tbl_deep_extend('force', {}, {
            capabilities = capabilities,
        }, config)
    end

    lspconfig[name].setup(config)
    ::continue::
end

vim.api.nvim_create_autocmd('LspAttach', {
    callback = function(args)
        local bufnr = args.buf
        local client = assert(vim.lsp.get_client_by_id(args.data.client_id), 'must have valid client')

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

        -- Register buffer local LSP keymaps
        require('custom.config.lsp-keymaps').setup(bufnr)
    end,
})
