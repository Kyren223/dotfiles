local java_packages_order = {
    'codes%.kyren',
    'org%.bukkit',
    { 'io%.papermc', 100 },
    'org%.jspecify',
    { 'org%.jetbrains', 50 },
    { 'net%.minecraft', 10 },
}

local function process_weights(list)
    local result = {}
    local current_weight = 0

    -- Process in reverse: from bottom to top
    for i = #list, 1, -1 do
        local entry = list[i]
        local pattern, weight

        -- Extract pattern and potential explicit weight
        if type(entry) == 'table' then
            pattern = entry[1]
            weight = entry[2]
        else
            pattern = entry
            weight = nil
        end

        -- Determine the weight to assign
        local final_weight
        if weight then
            if weight >= current_weight then
                final_weight = weight
                current_weight = weight + 1 -- Update counter for next iteration
            else
                local message = string.format(
                    'Weight %d for %s is smaller than previous, using current counter %d',
                    weight,
                    pattern,
                    current_weight
                )
                vim.defer_fn(function()
                    vim.notify(message, vim.log.levels.WARN)
                end, 5 * 1000)
                final_weight = weight
                current_weight = current_weight + 1 -- Increment counter normally
            end
        else
            final_weight = current_weight
            current_weight = current_weight + 1
        end

        result[pattern] = final_weight
    end

    return result
end

local java_package_weights = process_weights(java_packages_order)

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

            local function get_action_weight(title)
                for pattern, weight in pairs(java_package_weights) do
                    if title:match(pattern) then
                        return weight
                    end
                end
                return 0 -- Neutral weight for untracked packages
            end

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
                        completion = {
                            -- Stops jdtls from injecting variable placeholders when autocompleting
                            guessMethodArguments = 'off',

                            favoriteStaticMembers = {
                                'codes.kyren.kapi.utility.Assert.*',
                            },

                            filteredTypes = {
                                'edu.umd.cs.findbugs.*',
                                'javax.annotation.*',
                                'org.checkerframework.*',
                                'org.eclipse.sisu.*',
                                -- 'org.jetbrains.annotations.*',
                                'org.sonatype.inject.*',
                                'java.awt.*',
                                'com.sun.*',
                                'sun.*',
                                'jdk.*',
                            },
                        },
                        jdt = {
                            ls = {
                                kotlinSupport = {
                                    enabled = true,
                                },
                            },
                        },
                    },
                },

                on_attach = function(client, bufnr)
                    if client._code_action_sorted then
                        return
                    end
                    client._code_action_sorted = true

                    -- Hook into the absolute lowest-level RPC pipe.
                    -- This catches 100% of traffic, bypassing any plugin API overrides.
                    local orig_rpc_request = client.rpc.request

                    client.rpc.request = function(method, params, handler, ...)
                        if method == 'textDocument/codeAction' then
                            local wrapped_handler = function(err, result, ctx, config)
                                if not err and result and type(result) == 'table' then
                                    -- Sort the raw array (Respected by native vim.ui.select)
                                    table.sort(result, function(a, b)
                                        local title_a = a.title or ''
                                        local title_b = b.title or ''
                                        local weight_a = get_action_weight(title_a)
                                        local weight_b = get_action_weight(title_b)

                                        if weight_a ~= weight_b then
                                            return weight_a > weight_b
                                        end
                                        return title_a < title_b
                                    end)
                                end

                                if handler then
                                    return handler(err, result, ctx, config)
                                end
                            end

                            return orig_rpc_request(method, params, wrapped_handler, ...)
                        end

                        return orig_rpc_request(method, params, handler, ...)
                    end
                end,
            }

            require('jdtls').start_or_attach(opts)
        end

        setup_jdtls()

        vim.api.nvim_create_autocmd('FileType', {
            pattern = 'java',
            callback = setup_jdtls,
        })
    end,
    java_package_weights = java_package_weights,
}
