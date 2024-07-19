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

require('lspsaga').setup({
    lightbulb = {
        enable = false,
        sign = false,
        virtual_text = true,
    },
    implement = {
        sign = false,
        virtual_text = true,
    },
    floaterm = {
        height = 0.7,
        width = 0.7,
    },
    outline = {
        layout = 'float',
    },
    -- TODO: Change <C-k> in rename to smthing else
    -- bcz I am using <C-k> for moving between windows
    -- Maybe <C-c> for abort, <cr> for confirm
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

require('lsp_lines').setup()
vim.diagnostic.config({ virtual_text = false })
vim.keymap.set('', '<Leader>dt', require('lsp_lines').toggle, { desc = '[D]iagnostics [T]oggle inline' })

local lspsaga_diagnostic = require('lspsaga.diagnostic')
local builtin = require('telescope.builtin')
local severity = vim.diagnostic.severity
local show_workspace_diagnostics = '<cmd>Lspsaga show_workspace_diagnostics ++normal<cr>'
local function next_diagnostic(diagnostic_severity)
    return function()
        lspsaga_diagnostic:goto_next({ severity = diagnostic_severity })
    end
end
local function prev_diagnostic(diagnostic_severity)
    return function()
        lspsaga_diagnostic:goto_prev({ severity = diagnostic_severity })
    end
end
local function cursor_diagnostics()
    vim.diagnostic.open_float({
        scope = 'cursor',
        border = 'single',
    })
end

-- LSP Keybindings
vim.keymap.set('n', 'gd', builtin.lsp_definitions, { desc = '[G]oto [D]efinition' })
vim.keymap.set('n', 'gu', builtin.lsp_references, { desc = '[G]oto [U]sages' })
vim.keymap.set('n', 'gi', builtin.lsp_implementations, { desc = '[G]oto [I]mplementations' })
-- vim.keymap.set('n', 'gt', builtin.lsp_type_definitions, { desc = '[G]oto [T]ype Definitions' })
-- vim.keymap.set('n', 'gw', builtin.diagnostics, { desc = '[G]oto [W]arnings' })
vim.keymap.set('n', '<leader>ds', builtin.lsp_document_symbols, { desc = '[D]ocument [S]symbols' })
vim.keymap.set('n', '<leader>ps', builtin.lsp_workspace_symbols, { desc = '[P]roject [S]ymbols' })
vim.keymap.set({ 'n', 'i' }, '<C-p>', vim.lsp.buf.signature_help, { desc = 'List [P]arameters' })
vim.keymap.set('n', 'K', '<cmd>Lspsaga hover_doc<cr>', { desc = 'Documentation' })
vim.keymap.set('n', 'R', '<cmd>Lspsaga rename<cr>', { desc = '[R]ename' })
-- vim.keymap.set('n', '<leader>os', '<cmd>Lspsaga outline<cr>', { desc = '[T]erminal' })
vim.keymap.set({ 'n', 'i' }, '<M-Enter>', '<cmd>Lspsaga code_action<cr>', { desc = 'Code Actions' })
vim.keymap.set('n', '<leader>ca', '<cmd>Lspsaga code_action<cr><Esc>', { desc = '[C]ode [A]ctions' })
vim.keymap.set('n', 'ge', next_diagnostic(severity.ERROR), { desc = '[G]oto [E]rror' })
vim.keymap.set('n', 'gE', prev_diagnostic(severity.ERROR), { desc = '[G]oto [E]rror (prev)' })
vim.keymap.set('n', 'gw', next_diagnostic(severity.ERROR), { desc = '[G]oto [W]arning' })
vim.keymap.set('n', 'gW', prev_diagnostic(severity.ERROR), { desc = '[G]oto [W]arning (prev)' })
vim.keymap.set('n', '<leader>dw', show_workspace_diagnostics, { desc = '[D]iagnostics for [W]orkspace' })
vim.keymap.set('n', '<leader>D', cursor_diagnostics, { desc = '[D]iagnostics under cursor' })

vim.keymap.set({ 'n', 't' }, '<A-t>', '<cmd>Lspsaga term_toggle<cr>', { desc = '[T]erminal' })
