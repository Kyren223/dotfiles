-- https://github.com/chdalski/rlsp/tree/main/rlsp-yaml

return {
    name = 'rlsp-yaml',
    cmd = { 'rlsp-yaml' },
    filetypes = { 'yaml', 'yml' },
    root_markers = { '.git' },
    workspace_required = false,
    init_options = {
        customTags = { '!include', '!ref' },
        keyOrdering = false,
        kubernetesVersion = 'master',
        schemaStore = true,
        formatValidation = true,
        schemas = {
            ['https://json.schemastore.org/github-workflow'] = '.github/workflows/*.yml',
        },
        formatPrintWidth = 80,
        formatSingleQuote = false,
        formatPreserveQuotes = false,
        httpProxy = 'http://proxy.corp:8080',
    },
}
