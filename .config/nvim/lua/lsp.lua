return {
    asm_lsp = true,
    basedpyright = true, -- python
    bashls = true,
    clangd = true,
    gopls = true,
    jsonls = true,
    lemminx = true, -- xml
    lua_ls = true,
    markdown_oxide = true,
    nil_ls = true, -- nix
    taplo = true, -- toml
    yamlls = true,
    zls = true, -- zig

    -- astro = true,
    -- css_variables = true,
    -- cssls = true,
    -- ts_ls = true, -- typescript and yavashit
    -- tailwindcss = true,
    -- html = true,
    -- mdx_analyzer = true,

    -- kotlin_language_server = true,
    -- kotlin_lsp = false,

    -- TODO(kyren): delete these?
    -- gh_actions_ls = true,
    -- neocmake = true,
    -- marksman = false, -- markdown

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
