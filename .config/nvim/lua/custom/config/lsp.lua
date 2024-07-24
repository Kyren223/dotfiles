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
    ---@diagnostic disable-next-line: cast-local-type
    config = vim.tbl_deep_extend('force', {}, {
        capabilities = capabilities,
    }, config)

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

        -- Register LSP keymaps local to buffer
        require('custom.config.lsp-keymaps').setup(bufnr)
    end,
})

-- TODO: Decide if you want to use conform or not
--
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

vim.diagnostic.config({ virtual_text = false })
