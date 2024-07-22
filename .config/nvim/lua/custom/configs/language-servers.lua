-- NOTE: A list of language servers (and potentially their config)
-- Accepts either true to enable, false to disable or a table with settings
return {
    lua_ls = {
        settings = {
            diagnostics = {
                globals = { 'vim' },
            },
            workspace = {
                library = {
                    [vim.fn.expand('$VIMRUNTIME/lua')] = true,
                    [vim.fn.stdpath('config') .. '/lua'] = true,
                },
            },
        },
    },                             -- lua
    clangd = true,                 -- C/C++
    gradle_ls = true,              -- java package manager
    jdtls = true,                  -- java eclipse lsp
    kotlin_language_server = true, -- kotlin
    pyright = true,                -- python
    rust_analyzer = true,          -- rust
    bashls = true,                 -- bash
    taplo = true,                  -- toml
    lemminx = true,                -- xml
    yamlls = true,                 -- yaml
    jsonls = true,                 -- json
}
