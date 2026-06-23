return {
    'mfussenegger/nvim-jdtls',
    ft = { 'java' },
    dependencies = { 'Saghen/blink.cmp' },
    config = function()
        local setup_jdtls = function()
            local current_buf = vim.api.nvim_buf_get_name(0)
            local root_file = vim.fs.find({
                '.git',
                'build.gradle',
                'build.gradle.kts',
                'build.xml',
                'pom.xml',
                'settings.gradle',
                'settings.gradle.kts',
            }, { upward = true, path = current_buf })[1]

            local root_dir = root_file and vim.fs.dirname(root_file) or vim.fn.getcwd()
            local project_name = vim.fn.fnamemodify(root_dir, ':p:h:t')
            local workspace_dir = vim.fn.expand('~/.cache/jdtls-workspace/') .. project_name

            -- Safely mix standard blink capabilities with internal jdtls mappings
            local lsp_capabilities = require('blink.cmp').get_lsp_capabilities()

            local opts = {
                cmd = { 'jdtls', '-data', workspace_dir },
                root_dir = root_dir,
                capabilities = lsp_capabilities,

                -- Extended capabilities must live here, NOT in the root capabilities key
                init_options = {
                    extendedClientCapabilities = require('jdtls').extendedClientCapabilities,
                },

                settings = {
                    java = {
                        signatureHelp = { enabled = true },
                        compile = {
                            nullAnalysis = {
                                mode = 'enabled',
                                nullable = { 'org.jspecify.annotations.Nullable' },
                                nonnull = { 'org.jspecify.annotations.NonNull' },
                                nonnullbydefault = { 'org.jspecify.annotations.NullMarked' },
                            },
                        },
                        format = {
                            enabled = true,
                            settings = {
                                url = '/home/kyren/.config/nvim/eclipse-formatter.xml',
                                profile = 'Custom_Style',
                            },
                        },
                        errors = {
                            incompleteClasspath = 'warning',
                        },
                    },
                },
            }

            require('jdtls').start_or_attach(opts)
        end

        setup_jdtls()

        vim.api.nvim_create_autocmd('FileType', {
            pattern = 'java',
            callback = setup_jdtls,
        })
    end,
}
