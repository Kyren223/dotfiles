-- Setup null-ls
local null_ls = require('null-ls')
null_ls.setup({
    sources = {
        null_ls.builtins.formatting.stylua,
    },
})

-- Setup lsp signature
-- FIXME: fork the repo and fix the following issues
-- Remove documentation, show just the signature (in insert AND normal)
-- Make both insert and normal be toggelable rather than insert always showing and normal toggleable
require('lsp_signature').setup({
    bind = true, -- This is mandatory, otherwise border config won't get registered.
    handler_opts = { border = 'single' },
    doc_lines = 0,
    hint_enable = false,
})

-- NOTE: A list of language servers (and potentially their config)
-- Accepts either true to enable, false to disable or a table with settings
local servers = {
    lua_ls = true,                 -- lua
    clangd = true,                 -- C/C++
    gradle_ls = true,              -- java package manager
    jdtls = true,                  -- java eclipse lsp
    kotlin_language_server = true, -- kotlin
    pyright = true,                -- python
    rust_analyzer = true,          -- rust
    bashls = true,                 -- bash
    taplo = true,                  -- toml
    lemminx = true,                -- xml
    yamlls = true,                 -- yaml
    jsonls = true,                 -- json
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

require('lsp_lines').setup()
vim.diagnostic.config({ virtual_text = false })
vim.keymap.set('', '<Leader>dt', require('lsp_lines').toggle, { desc = '[D]iagnostics [T]oggle inline' })

-- LSP Keybindings
local builtin = require('telescope.builtin')
vim.keymap.set('n', 'gd', builtin.lsp_definitions, { desc = '[G]oto [D]efinition' })
vim.keymap.set('n', 'gu', builtin.lsp_references, { desc = '[G]oto [U]sages' })
vim.keymap.set('n', 'gi', builtin.lsp_implementations, { desc = '[G]oto [I]mplementations' })
-- vim.keymap.set('n', 'gt', builtin.lsp_type_definitions, { desc = '[G]oto [T]ype Definitions' })
vim.keymap.set('n', 'gw', builtin.diagnostics, { desc = '[G]oto [W]arnings' })
vim.keymap.set('n', '<leader>ds', builtin.lsp_document_symbols, { desc = '[D]ocument [S]symbols' })
vim.keymap.set('n', '<leader>ps', builtin.lsp_workspace_symbols, { desc = '[P]roject [S]ymbols' })
vim.keymap.set({ 'n', 'i' }, '<C-p>', vim.lsp.buf.signature_help, { desc = 'List [P]arameters' })
