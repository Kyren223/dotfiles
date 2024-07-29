return {
    'mfussenegger/nvim-jdtls',
    ft = { 'java' },
    dependencies = { 'mfussenegger/nvim-dap', 'williamboman/mason-lspconfig.nvim' },
    opts = function(_, opts)
        local jdtls = require('jdtls')
        local root_markers = { '.git', 'mvnw', 'gradlew', 'pom.xml', 'build.gradle', '.project' }
        local root_dir = require('jdtls.setup').find_root(root_markers)
        local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ':p:h:t')
        local workspace_dir = vim.fn.stdpath('data') .. '/site/java/workspace-root/' .. project_name
        os.execute('mkdir ' .. workspace_dir)

        local defaults = {
            cmd = {
                'java',
                '-Declipse.application=org.eclipse.jdt.ls.core.id1',
                '-Dosgi.bundles.defaultStartLevel=4',
                '-Declipse.product=org.eclipse.jdt.ls.core.product',
                '-Dlog.protocol=true',
                '-Dlog.level=ALL',
                '-javaagent:' .. vim.fn.expand('$MASON/share/jdtls/lombok.jar'),
                '-Xms1g',
                '--add-modules=ALL-SYSTEM',
                '--add-opens',
                'java.base/java.util=ALL-UNNAMED',
                '--add-opens',
                'java.base/java.lang=ALL-UNNAMED',
                '-jar',
                vim.fn.expand('$MASON/share/jdtls/plugins/org.eclipse.equinox.launcher.jar'),
                '-configuration',
                -- WARNING: Might need to change to config_linux or smthing
                vim.fn.expand('$MASON/share/jdtls/config'),
                '-data',
                workspace_dir,
            },
            root_dir = root_dir,
            settings = {
                java = {
                    -- WARNING: might need home = 'path'
                    -- WARNING: might need configuration.runtimes = {} of paths
                    eclipse = { downloadSources = true },
                    configuration = { updateBuildConfiguration = 'interactive' },
                    maven = { downloadSources = true },
                    implementationsCodeLens = { enabled = true },
                    referencesCodeLens = { enabled = true },
                    -- NOTE: maybe want to uncomment this
                    -- references = { includeDecompiledSources = true, },
                    -- signatureHelp = { enabled = true },
                    -- format = {
                    --     enabled = true,
                    --     -- Formatting works by default, but you can refer to a specific file/URL if you choose
                    --     -- settings = {
                    --     --   url = "https://github.com/google/styleguide/blob/gh-pages/intellij-java-google-style.xml",
                    --     --   profile = "GoogleStyle",
                    --     -- },
                    -- },
                },
                signatureHelp = { enabled = true },
                completion = {
                    favoriteStaticMembers = {
                        'org.hamcrest.MatcherAssert.assertThat',
                        'org.hamcrest.Matchers.*',
                        'org.hamcrest.CoreMatchers.*',
                        'org.junit.jupiter.api.Assertions.*',
                        'java.util.Objects.requireNonNull',
                        'java.util.Objects.requireNonNullElse',
                        'org.mockito.Mockito.*',
                    },
                    -- importOrder = {
                    --     'java',
                    --     'javax',
                    --     'com',
                    --     'org',
                    -- },
                },
                -- extendedClientCapabilities = jdtls.extendedClientCapabilities,
                sources = {
                    organizeImports = {
                        starThreshold = 9999,
                        staticStarThreshold = 9999,
                    },
                },
                -- codeGeneration = {
                --     toString = {
                --         template = '${object.className}{${member.name()}=${member.value}, ${otherMembers}}',
                --     },
                --     useBlocks = true,
                -- },
            },
            -- Needed for auto-completion with method signatures and placeholders
            capabilities = require('cmp_nvim_lsp').default_capabilities(),
            init_options = {
                bundles = {
                    vim.fn.expand('$MASON/share/java-debug-adapter/com.microsoft.java.debug.plugin.jar'),
                    -- unpack remaining bundles
                    (table.unpack or unpack)(vim.split(vim.fn.glob('$MASON/share/java-test/*.jar'), '\n', {})),
                },
            },
            -- flags = { allow_incremental_sync = true },
            handlers = {
                ['$/progress'] = function()
                    -- disable progress updates.
                end,
            },
            filetypes = { 'java' },
            on_attach = function(client, bufnr)
                jdtls.setup_dap({ hotcodereplace = 'auto' })
            end,
        }

        -- ensure that table is valid
        if not opts then
            opts = {}
        end

        -- extend the current table with the defaults keeping options in the user opts
        -- this allows users to pass opts through an opts table in community.lua
        opts = vim.tbl_deep_extend('keep', opts, defaults)

        -- send opts to config
        return opts
    end,
    config = function(_, opts)
        -- setup autocmd on filetype detect java
        vim.api.nvim_create_autocmd('Filetype', {
            pattern = 'java', -- autocmd to start jdtls
            callback = function()
                if opts.root_dir and opts.root_dir ~= '' then
                    require('jdtls').start_or_attach(opts)
                    -- require('jdtls.dap').setup_dap_main_class_configs()
                else
                    -- require('astronvim.utils').notify(
                    --     'jdtls: root_dir not found. Please specify a root marker',
                    --     vim.log.levels.ERROR
                    -- )
                end
            end,
        })

        -- -- create autocmd to load main class configs on LspAttach.
        -- -- This ensures that the LSP is fully attached.
        -- -- See https://github.com/mfussenegger/nvim-jdtls#nvim-dap-configuration
        -- vim.api.nvim_create_autocmd('LspAttach', {
        --     pattern = '*.java',
        --     callback = function(args)
        --         local client = vim.lsp.get_client_by_id(args.data.client_id)
        --         -- ensure that only the jdtls client is activated
        --         if client.name == 'jdtls' then
        --             require('jdtls.dap').setup_dap_main_class_configs()
        --         end
        --     end,
        -- })
    end,
}
