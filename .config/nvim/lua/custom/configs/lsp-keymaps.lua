local severity = vim.diagnostic.severity
local function next_diagnostic(diagnostic_severity)
    return function()
        require('lspsaga.diagnostic'):goto_next({ severity = diagnostic_severity })
    end
end
local function prev_diagnostic(diagnostic_severity)
    return function()
        require('lspsaga.diagnostic'):goto_prev({ severity = diagnostic_severity })
    end
end
local function cursor_diagnostics()
    vim.diagnostic.open_float({
        scope = 'cursor',
        border = 'single',
    })
end

local keymaps = {
    { 'n',          'gd',         '<cmd>Telescope lsp_definitions<cr>',       { desc = '[G]oto [D]efinition' } },
    { 'n',          'gu',         '<cmd>Telescope lsp_references<cr>',        { desc = '[G]oto [U]sages' } },
    { 'n',          'gi',         '<cmd>Telescope lsp_implementations<cr>',   { desc = '[G]oto [I]mplementations' } },
    { 'n',          'gt',         '<cmd>Telescope lsp_type_definitions<cr>',  { desc = '[G]oto [T]ype Definitions' } },
    { 'n',          '<leader>ds', '<cmd>Telescope lsp_document_symbols<cr>',  { desc = '[D]ocument [S]symbols' } },
    { 'n',          '<leader>ps', '<cmd>Telescope lsp_workspace_symbols<cr>', { desc = '[P]roject [S]ymbols' } },
    { { 'n', 'i' }, '<C-p>',      vim.lsp.buf.signature_help,                 { desc = 'Show [P]arameters' } },
    { 'n',          'K',          '<cmd>Lspsaga hover_doc<cr>',               { desc = 'Documentation' } },
    { 'n',          'R',          '<cmd>Lspsaga rename<cr>',                  { desc = '[R]ename' } },
    { { 'n', 'i' }, '<M-Enter>',  '<cmd>Lspsaga code_action<cr>',             { desc = 'Code Actions' } },
    { 'n',          '<leader>ca', '<cmd>Lspsaga code_action<cr><Esc>',        { desc = '[C]ode [A]ctions' } },
    { 'n',          'ge',         next_diagnostic(severity.ERROR),            { desc = '[G]oto [E]rror' } },
    { 'n',          'gE',         prev_diagnostic(severity.ERROR),            { desc = '[G]oto [E]rror (prev)' } },
    { 'n',          'gw',         next_diagnostic(severity.ERROR),            { desc = '[G]oto [W]arning' } },
    { 'n',          'gW',         prev_diagnostic(severity.ERROR),            { desc = '[G]oto [W]arning (prev)' } },
    { 'n',          '<leader>D',  cursor_diagnostics,                         { desc = '[D]iagnostics under cursor' } },
}

local M = {}

--- Registers LSP keymaps for the given buffer
---@param bufnr number: the id of the buffer
M.setup = function(bufnr)
    for _, keymap in ipairs(keymaps) do
        local mode = keymap[1]
        local lhs = keymap[2]
        local rhs = keymap[3]
        local opts = keymap[4]

        if not opts then
            opts = {}
        end

        opts.buffer = bufnr
        vim.keymap.set(mode, lhs, rhs, opts)
    end
end

return M
