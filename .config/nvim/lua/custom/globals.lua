function Notify(title, message, level)
    local notify = require('notify')
    notify(message, level, { title = title })
end

function ToggleWrap()
    if vim.wo.wrap then
        vim.wo.wrap = false
        Notify('Wrap disabled', 'info')
    else
        vim.wo.wrap = true
        vim.wo.number = false
        Notify('Wrap enabled', 'info')
    end
end

function ToggleInlayHints()
    local is_enabled = vim.lsp.inlay_hint.is_enabled({})
    vim.lsp.inlay_hint.enable(not is_enabled)
    if is_enabled then
        Notify('Inlay Hints disabled', 'info')
    else
        Notify('Inlay Hints enabled', 'info')
    end
end
