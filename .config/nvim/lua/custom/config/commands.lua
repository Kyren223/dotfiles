vim.api.nvim_create_autocmd('TextYankPost', {
    desc = 'Highlight when yanking text',
    group = vim.api.nvim_create_augroup('highlight-yank', { clear = true }),
    callback = function()
        vim.highlight.on_yank()
    end,
})

vim.api.nvim_create_autocmd('BufEnter', {
    desc = 'Disable newlines on commented lines from continuing the comment',
    group = vim.api.nvim_create_augroup('disable-comments-continuation', { clear = true }),
    callback = function()
        -- vim.opt_local.formatoptions:remove('r') -- no comments on enter
        vim.opt_local.formatoptions:remove('o') -- no comments on `o` or `O`
    end,
})

vim.api.nvim_create_user_command('Format', function(args)
    local range = nil
    if args.count ~= -1 then
        local end_line = vim.api.nvim_buf_get_lines(0, args.line2 - 1, args.line2, true)[1]
        range = {
            start = { args.line1, 0 },
            ['end'] = { args.line2, end_line:len() },
        }
    end
    require('conform').format({ async = true, lsp_format = 'fallback', range = range })
end, { range = true })

vim.api.nvim_create_user_command('FormatToggle', function(args)
    local is_global = not args.bang
    if is_global then
        vim.g.disable_autoformat = not vim.g.disable_autoformat
        if vim.g.disable_autoformat then
            Snacks.notify.info('Autoformat on save disabled globally', { title = 'test' })
        else
            Snacks.notify.info('Autoformat on save enabled globally')
        end
    else
        vim.b.disable_autoformat = not vim.b.disable_autoformat
        if vim.b.disable_autoformat then
            Snacks.notify.info('Autoformat on save disabled for this buffer')
        else
            Snacks.notify.info('Autoformat on save enabled for this buffer')
        end
    end
end, {
    desc = 'Toggle autoformat on save',
    bang = true,
})

-- NOTE: highlight %v, %s etc in go string literals
vim.api.nvim_create_autocmd({ 'BufEnter', 'TextChanged', 'InsertLeave' }, {
    pattern = '*.go',
    callback = function()
        local query = vim.treesitter.query.parse('go', '(interpreted_string_literal) @string')
        local parser = vim.treesitter.get_parser(0, 'go')
        local tree = parser:parse()[1]
        local root = tree:root()
        local bufnr = vim.api.nvim_get_current_buf()

        for id, node in query:iter_captures(root, bufnr, 0, -1) do
            if query.captures[id] == 'string' then
                local start_row, start_col, end_row, end_col = node:range()

                -- Get the text of the string literal
                local text = vim.api.nvim_buf_get_text(bufnr, start_row, start_col, end_row, end_col, {})[1]

                -- Highlight only the parts matching `%[a-z]`
                for match_start, match_end in text:gmatch('()%%[a-z]()') do
                    vim.api.nvim_buf_add_highlight(
                        bufnr,
                        -1,
                        '@lsp.type.formatSpecifier.go', -- Higlight group
                        start_row,
                        start_col + match_start - 1,
                        start_col + match_end - 1
                    )
                end
            end
        end
    end,
})

-- NOTE: show unused zig variables as "DiagnosticUnnecessary" instead of error
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
