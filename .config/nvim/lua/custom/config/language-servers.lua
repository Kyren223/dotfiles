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
        mason = false,
        cmd = {
            'clangd',
            '--background-index',
            '--clang-tidy',
            '--header-insertion=iwyu',
            '--completion-style=detailed',
            '--function-arg-placeholders',
            '--fallback-style=llvm',
        },
        root_dir = function(filename)
            return require('lspconfig/util').root_pattern(
                '.clang-tidy',
                '.clang-format',
                'compile_commands.json',
                '.git'
            )(filename) or vim.fn.getcwd()
        end,
        init_options = {
            usePlaceholders = true,
            completeUnimported = true,
            clangdFileStatus = true,
        },
    }, -- c/cpp
    neocmake = {
        root_dir = function(filename)
            return require('lspconfig/util').root_pattern(
                'CMakePresets.json',
                'CTestConfig.cmake',
                'build',
                'cmake',
                '.git' -- NOTE: git is last due to monorepos (so it tries to use build/cmake first)
            )(filename) or vim.fn.getcwd()
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
    ts_ls = true, -- javascript/typescript
    astro = true, -- astro framework
    mdx_analyzer = true, -- markdown with JS I think
    -- marksman = true, -- Markdown LSP
    -- markdown_oxide = true, -- Markdown LSP but better
    gopls = {
        cmd = { 'gopls' },
        filetypes = { 'go', 'gomod', 'gowork', 'gotmpl' },
        root_dir = function(filename)
            return require('lspconfig/util').root_pattern('go.work', 'go.mod', '.git')(filename)
        end,
        settings = {
            gopls = {
                gofumpt = true,
                codelenses = {
                    gc_details = false,
                    generate = true,
                    regenerate_cgo = true,
                    run_govulncheck = true,
                    test = true,
                    tidy = true,
                    upgrade_dependency = true,
                    vendor = true,
                },
                hints = {
                    assignVariableTypes = false,
                    compositeLiteralFields = false,
                    compositeLiteralTypes = true,
                    constantValues = true,
                    functionTypeParameters = false,
                    parameterNames = false,
                    rangeVariableTypes = true,
                },
                analyses = {
                    fieldalignment = true,
                    nilness = true,
                    unusedparams = true,
                    unusedwrite = true,
                    useany = true,
                },
                usePlaceholders = false,
                completeUnimported = true,
                staticcheck = true,
                directoryFilters = { '-.git', '-.vscode', '-.idea', '-.vscode-test', '-node_modules' },
                semanticTokens = true,
            },
        },
    }, -- Go LSP
    jdtls = true, -- java
    -- sqlls = true,
    -- sqls = {
    --     on_attach = function(client, bufnr)
    --         require('sqls').on_attach(client, bufnr)
    --     end,
    --     settings = {
    --         sqls = {
    --             connections = {
    --                 {
    --                     driver = 'sqlite3',
    --                     dataSourceName = '/home/kyren/projects/eko/server.db',
    --                 },
    --             },
    --         },
    --     },
    -- },
    zls = {
        mason = false,
        cmd = { 'zls' },
        settings = {
            zls = {
                enable_build_on_save = true,
                build_on_save_args = {},
                enable_argument_placeholders = false,
                warn_style = true,

                inlay_hints_show_variable_type_hints = true,
                inlay_hints_show_struct_literal_field_type = true,
                inlay_hints_show_parameter_name = true,
                inlay_hints_show_builtin = true,
                inlay_hints_hide_redundant_param_names = true,
                inlay_hints_hide_redundant_param_names_last_token = true,
            },
        },
    }, -- zig
    -- nixd = {
    --     mason = false,
    --     cmd = { 'nixd' },
    --     settings = {
    --         nixd = {
    --             nixpkgs = { expr = 'import <nixpkgs> { }' },
    --             -- options = {
    --             --     nixos = {
    --             --         expr = '(builtins.getFlake \\"/home/kyren/dotfiles/flake.nix").nixosConfigurations.laptop-nixos.options',
    --             --     },
    --             --     home_manager = {
    --             --         expr = '(builtins.getFlake \\"/home/kyren/dotfiles/flake.nix").homeConfigurations.laptop-nixos.options',
    --             --     },
    --             -- },
    --         },
    --     },
    -- },
    asm_lsp = {
        mason = false,
        cmd = { 'asm-lsp' },
    },
}
