return {
    'folke/noice.nvim',
    event = 'VeryLazy',
    opts = {
        -- notify = { enabled = false },
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
                -- NOTE: for some reason this makes the signature help prettier?
                -- not sure why noice does this, but might aswell use it
                enabled = true,
                auto_open = { enabled = false },
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
        messages = {
            enabled = true, -- enables the Noice messages UI
            view = 'notify', -- default view for messages
            view_error = 'messages', -- view for errors
            view_warn = 'notify', -- view for warnings
            view_history = 'messages', -- view for :messages
            view_search = false, -- view for search count messages. Set to `false` to disable
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
                -- NOTE: filters errors from the command line
                filter = {
                    event = 'msg_show',
                    error = true,
                    cmdline = true,
                },
                opts = { skip = true },
            },
            {
                -- NOTE: filters "fewer/more lines" messages
                filter = {
                    event = 'msg_show',
                    kind = '',
                    find = 'lines',
                },
                opts = { skip = true },
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
        'rcarriga/nvim-notify',
    },
}
