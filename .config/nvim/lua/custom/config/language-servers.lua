-- NOTE: a table or true to enable, false to disable
return {
    lua_ls = {
        settings = {
            diagnostics = { globals = { 'vim' } },
            telemetry = { enabled = false },
            hint = { enable = true },
            workspace = {
                library = {
                    [vim.fn.expand('$VIMRUNTIME/lua')] = true,
                    [vim.fn.stdpath('config') .. '/lua'] = true,
                },
            },
        },
    }, -- lua
    clangd = {
        cmd = { 'clangd', '--clang-tidy' },
        root_dir = function(fname)
            return require('lspconfig/util').root_pattern(
                '.clang-tidy',
                '.clang-format',
                'compile_commands.json',
                '.git'
            )(fname) or vim.fn.getcwd()
        end,
    }, -- c/cpp
    neocmake = {
        root_dir = function(fname)
            return require('lspconfig/util').root_pattern(
                'CMakePresets.json',
                'CTestConfig.cmake',
                'build',
                'cmake',
                '.git' -- NOTE: git is last due to monorepos (so it tries to use build/cmake first)
            )(fname)
        end,
    },
    pyright = {
        settings = {
            python = {
                pythonPath = '~/python/venv/bin/python',
            },
        },
    }, -- python
    bashls = true, -- bash
    taplo = true, -- toml
    lemminx = true, -- xml
    yamlls = true, -- yaml
    jsonls = true, -- json
    html = true, -- html
    cssls = true, -- css
    tsserver = true, -- javascript/typescript
}