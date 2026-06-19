-- https://github.com/luals/lua-language-server

return {
    cmd = {
        'lua-language-server',
        '--logpath=' .. vim.fn.expand('~/.cache/nvim/lua-language-server/log'),
        '--metapath=' .. vim.fn.expand('~/.cache/nvim/lua-language-server/meta'),
    },
    filetypes = { 'lua' },
    root_markers = {
        '.luarc.json',
        '.luarc.jsonc',
        '.luacheckrc',
        '.stylua.toml',
        'stylua.toml',
        'selene.toml',
        'selene.yml',
        '.git',
    },
    settings = {
        Lua = {
            runtime = {
                -- Tell the language server you're targetting Neovim's runtime environment
                version = 'LuaJIT',
                -- CRITICAL: Allows modern lua_ls to parse the dynamic third-party paths
                -- injected by lazydev without strict root containment rules.
                pathStrict = false,
            },
            workspace = {
                -- Stops the server from asking to configure your workspace environment reactively
                checkThirdParty = false,
            },
            telemetry = {
                enable = false,
            },
        },
    },
}
