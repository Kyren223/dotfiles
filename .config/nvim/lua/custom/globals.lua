function Notify(message, title, level)
    if not title then
        if not level then
            title = 'info'
        else
            title = level
        end
    end
    vim.notify(message, level, { title = ' ' .. title })
end

function ToggleWrap()
    if vim.wo.wrap then
        vim.wo.wrap = false
        Notify('Wrap disabled')
    else
        vim.wo.wrap = true
        vim.wo.number = false
        Notify('Wrap enabled')
    end
end

function ToggleInlayHints()
    local is_enabled = vim.lsp.inlay_hint.is_enabled({})
    vim.lsp.inlay_hint.enable(not is_enabled)
    if is_enabled then
        Notify('Inlay Hints disabled')
    else
        Notify('Inlay Hints enabled')
    end
end
