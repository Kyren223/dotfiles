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

vim.api.nvim_create_user_command('LspInfo', function()
    vim.cmd('checkhealth vim.lsp')
end, {})

vim.api.nvim_create_user_command('LspLog', function()
    vim.cmd('tabedit ' .. vim.lsp.get_log_path())
end, {})
