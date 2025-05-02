-- show unused zig variables as "DiagnosticUnnecessary" instead of error
local orig_underline_show = vim.diagnostic.handlers.underline.show
local custom_ns = vim.api.nvim_create_namespace('custom_unused_ns')

vim.diagnostic.handlers.underline.show = function(namespace, bufnr, diagnostics, opts)
    local normal_diags = {}
    local custom_diags = {}
    for _, diag in ipairs(diagnostics) do
        if diag.message:find('unused', 1, true) then
            table.insert(custom_diags, diag)
        else
            table.insert(normal_diags, diag)
        end
    end
    if #normal_diags > 0 and orig_underline_show ~= nil then
        orig_underline_show(namespace, bufnr, normal_diags, opts)
    end
    for _, diag in ipairs(custom_diags) do
        vim.highlight.range(
            bufnr,
            custom_ns,
            'DiagnosticUnnecessary',
            { diag.lnum, diag.col },
            { diag.end_lnum, diag.end_col },
            { inclusive = false }
        )
    end
end

local orig_underline_hide = vim.diagnostic.handlers.underline.hide

vim.diagnostic.handlers.underline.hide = function(namespace, bufnr)
    if orig_underline_hide ~= nil then
        orig_underline_hide(namespace, bufnr)
    end
    vim.api.nvim_buf_clear_namespace(bufnr, custom_ns, 0, -1)
end
