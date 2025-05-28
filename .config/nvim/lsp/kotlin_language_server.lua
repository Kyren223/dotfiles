-- https://github.com/fwcd/kotlin-language-server

return {
    cmd = { 'kotlin-language-server' },
    filetypes = { 'kotlin' },
    init_options = {},
    root_markers = {
        'settings.gradle',
        'settings.gradle.kts',
        'build.xml',
        'pom.xml',
        'build.gradle',
        'build.gradle.kts',
    },
}
