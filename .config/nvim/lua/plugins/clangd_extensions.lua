return {
    'p00f/clangd_extensions.nvim',
    dependencies = { 'microsoft/vscode-codicons' }, -- NOTE: for the ast icons
    cmd = {
        'ClangdSwitchSourceHeader',
        'ClangdSetInlayHints',
        'ClangdDisableInlayHints',
        'ClangdToggleInlayHints',
        'ClangdAST',
        'ClangdSymbolInfo',
        'ClangdTypeHierarchy',
        'ClangdMemoryUsage',
    },
    opts = {
        inlay_hints = {
            inline = false,
        },
        ast = {
            role_icons = {
                type = '',
                declaration = '',
                expression = '',
                specifier = '',
                statement = '',
                ['template argument'] = '',
            },
            kind_icons = {
                Compound = '',
                Recovery = '',
                TranslationUnit = '',
                PackExpansion = '',
                TemplateTypeParm = '',
                TemplateTemplateParm = '',
                TemplateParamObject = '',
            },
        },
    },
}
