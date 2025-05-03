-- https://github.com/redhat-developer/yaml-language-server

return {
    cmd = { 'yaml-language-server', '--stdio' },
    filetypes = { 'yaml', 'yaml.docker-compose', 'yaml.gitlab' },
    root_markers = { '.git' },
    settings = {
        redhat = { telemetry = { enabled = false } },
    },
    -- Have to add this for yamlls to understand that we support line folding
    capabilities = {
        textDocument = {
            foldingRange = {
                dynamicRegistration = false,
                lineFoldingOnly = true,
            },
        },
    },
}
