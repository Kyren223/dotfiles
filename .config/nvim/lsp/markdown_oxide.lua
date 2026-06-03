-- https://github.com/Feel-ix-343/markdown-oxide

return {
    cmd = { 'markdown-oxide' },
    root_markers = { '.git', '.obsidian', '.moxide.toml' },
    filetypes = { 'markdown' },
    capabilities = {
        workspace = {
            didChangeWatchedFiles = {
                dynamicRegistration = true,
            },
        },
    },
}
