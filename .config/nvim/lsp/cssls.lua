-- https://github.com/hrsh7th/vscode-langservers-extracted

return {
    cmd = { 'vscode-css-language-server', '--stdio' },
    filetypes = { 'css', 'scss', 'less', 'astro' },
    init_options = {
        provideFormatter = true,
    },
    root_markers = { 'package.json', '.git' },
    settings = {
        css = {
            validate = true,
        },
        less = {
            validate = true,
        },
        scss = {
            validate = true,
        },
    },
}
