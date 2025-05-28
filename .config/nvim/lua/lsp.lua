return {
    asm_lsp = true,
    astro = true,
    basedpyright = true, -- python
    bashls = true,
    clangd = true,
    css_variables = true,
    cssls = true,
    gh_actions_ls = true,
    gopls = true,
    html = true,
    jsonls = true,
    kotlin_language_server = true,
    kotlin_lsp = false,
    lemminx = true, -- xml
    lua_ls = true,
    markdown_oxide = true,
    marksman = false, -- markdown
    mdx_analyzer = true,
    neocmake = true,
    nil_ls = true, -- nix
    tailwindcss = true,
    taplo = true, -- toml
    ts_ls = true, -- typescript and yavashit
    yamlls = true,
    zls = true, -- zig

    global = {
        capabilities = {
            workspace = {
                fileOperations = {
                    didRename = true,
                    willRename = true,
                },
            },
        },
    },
}
