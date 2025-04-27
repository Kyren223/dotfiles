-- https://github.com/hrsh7th/vscode-langservers-extracted

return {
    cmd = { 'vscode-json-language-server', '--stdio' },
    filetypes = { 'json', 'jsonc' },
    init_options = {
        provideformatter = true,
    },
    root_markers = { '.git' },
}
