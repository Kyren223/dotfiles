return {
    'folke/noice.nvim',
    event = 'VeryLazy',
    opts = {
        notify = { enabled = false },
        lsp = {
            progress = { enabled = false },
            override = {
                -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
                -- override the default lsp markdown formatter with Noice
                -- ['vim.lsp.util.convert_input_to_markdown_lines'] = true,
                -- override the lsp markdown formatter with Noice
                -- ['vim.lsp.util.stylize_markdown'] = true,
            },
            hover = {
                ---@type NoiceViewOptions
                enabled = true,
                silent = false, -- set to true to not show a message if hover is not available
                view = nil, -- when nil, use defaults from documentation
                opts = {}, -- merged with defaults from documentation
            },
            signature = {
                enabled = true,
                auto_open = {
                    enabled = true,
                    trigger = true, -- Automatically show signature help when typing a trigger character from the LSP
                    luasnip = true, -- Will open signature help when jumping to Luasnip insert nodes
                    throttle = 50, -- Debounce lsp signature help request by 50ms
                },
                view = nil, -- when nil, use defaults from documentation
                ---@type NoiceViewOptions
                opts = {}, -- merged with defaults from documentation
            },
            message = {
                -- Messages shown by lsp servers
                enabled = true,
                view = 'notify',
                opts = {},
            },
            -- defaults for hover and signature help
            documentation = {
                view = 'hover',
                ---@type NoiceViewOptions
                opts = {
                    lang = 'markdown',
                    replace = true,
                    render = 'plain',
                    format = { '{message}' },
                    win_options = { concealcursor = 'n', conceallevel = 3 },
                },
            },
        },
        -- you can enable a preset for easier configuration
        cmdline = {
            enabled = true, -- enables the Noice cmdline UI
            view = 'cmdline_popup', -- view for rendering the cmdline. Change to `cmdline` to get a classic cmdline at the bottom
            -- view = 'cmdline', -- view for rendering the cmdline. Change to `cmdline` to get a classic cmdline at the bottom
            format = {
                cmdline = { pattern = '^:', icon = '', lang = 'vim' },
                search_down = { kind = 'search', pattern = '^/', icon = ' ', lang = 'regex' },
                search_up = { kind = 'search', pattern = '^%?', icon = ' ', lang = 'regex' },
                terminal = { pattern = '^:%s*!', icon = '$', lang = 'bash' },
                lua = { pattern = { '^:%s*lua%s+', '^:%s*lua%s*=%s*', '^:%s*=%s*' }, icon = '', lang = 'lua' },
                help = { pattern = '^:%s*he?l?p?%s+', icon = '' },
                input = { view = 'cmdline_input', icon = '󰥻 ' }, -- Used by input()
                -- lua = false, -- to disable a format, set to `false`
            },
            opts = {},
        },
        routes = {
            {
                filter = {
                    event = 'msg_show',
                    kind = 'search_count',
                },
                opts = { skip = true },
            },
            {
                filter = {
                    event = 'msg_show',
                    kind = '',
                    find = 'written',
                },
                opts = { skip = true },
            },
            {
                view = 'popup',
                filter = {
                    event = 'msg_show',
                    kind = '',
                    find = 'written',
                },
                -- opts = { skip = true },
            },
        },
        presets = {
            bottom_search = true, -- use a classic bottom cmdline for search
            long_message_to_split = true, -- long messages will be sent to a split
            inc_rename = false, -- enables an input dialog for inc-rename.nvim
            lsp_doc_border = true, -- add a border to hover docs and signature help
        },
    },
    dependencies = {
        'MunifTanjim/nui.nvim',
    },
}
