-- https://github.com/redhat-developer/yaml-language-server

return {
    cmd = { 'yaml-language-server', '--stdio' },
    filetypes = { 'yaml', 'yaml.docker-compose', 'yaml.gitlab' },
    root_markers = { '.git' },
    settings = {
        redhat = {
            telemetry = {
                enabled = false,
            },
        },
    },
}
