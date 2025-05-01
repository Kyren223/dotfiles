-- https://github.com/vunguyentuan/vscode-css-variables/tree/master/packages/css-variables-language-server

return {
    cmd = { 'css-variables-language-server', '--stdio' },
    filetypes = { 'css', 'scss', 'less', 'astro' },
    root_markers = { 'package.json', '.git' },
    settings = {
        cssVariables = {
            blacklistFolders = {
                '**/.cache',
                '**/.DS_Store',
                '**/.git',
                '**/.hg',
                '**/.next',
                '**/.svn',
                '**/bower_components',
                '**/CVS',
                '**/dist',
                '**/node_modules',
                '**/tests',
                '**/tmp',
            },
            lookupFiles = { '**/*.less', '**/*.scss', '**/*.sass', '**/*.css' },
        },
    },
}
