-- https://github.com/Feel-ix-343/markdown-oxide

return {
    root_markers = { '.git', '.obsidian', '.moxide.toml' },
    filetypes = { 'markdown' },
    cmd = { 'markdown-oxide' },
    capabilities = {
        workspace = {
            didChangeWatchedFiles = {
                dynamicRegistration = true,
            },
        },
    },
}
