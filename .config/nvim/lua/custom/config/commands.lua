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
            Notify('Autoformat on save disabled globally')
        else
            Notify('Autoformat on save enabled globally')
        end
    else
        vim.b.disable_autoformat = not vim.b.disable_autoformat
        if vim.b.disable_autoformat then
            Notify('Autoformat on save disabled for this buffer')
        else
            Notify('Autoformat on save enabled for this buffer')
        end
    end
end, {
    desc = 'Toggle autoformat on save',
    bang = true,
})

local function filter_marksman_diagnostics(_, result, ctx, config)
    local client = vim.lsp.get_client_by_id(ctx.client_id)
    if client ~= nil and client.name == "marksman" then
        return
    end
    -- For other language servers, show diagnostics as normal
    vim.lsp.diagnostic.on_publish_diagnostics(_, result, ctx, config)
end

-- Set diagnostic handler for all language servers
vim.lsp.handlers["textDocument/publishDiagnostics"] = filter_marksman_diagnostics

