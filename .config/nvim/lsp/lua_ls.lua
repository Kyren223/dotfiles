-- https://github.com/luals/lua-language-server

return {
    cmd = {
        'lua-language-server',
        '--logpath=' .. vim.fn.expand('~/.cache/nvim/lua-language-server/log'),
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
}
