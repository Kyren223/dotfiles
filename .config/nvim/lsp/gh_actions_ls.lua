-- https://github.com/lttb/gh-actions-language-server

return {
    capabilities = {
        workspace = {
            didChangeWorkspaceFolders = {
                dynamicRegistration = true,
            },
        },
    },
    cmd = { 'gh-actions-language-server', '--stdio' },
    filetypes = { 'yaml' },
    root_markers = { '.github/workflows', '.forgejo/workflows', '.gitea/workflows' },
    workspace_required = true,
}
