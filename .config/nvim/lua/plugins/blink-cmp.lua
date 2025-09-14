return {
    enabled = false,
    'saghen/blink.cmp',
    event = 'InsertEnter',
    version = '1.*',
    dependencies = {
        { 'Kaiser-Yang/blink-cmp-git', dependencies = { 'nvim-lua/plenary.nvim' } },
    },
    ---@module 'blink.cmp'
    ---@type blink.cmp.Config
    opts = {
        keymap = {
            preset = 'enter',
            ['<C-e>'] = {},
            ['<C-c>'] = { 'hide', 'fallback' },

            ['<C-b>'] = {},
            ['<C-f>'] = {},
            ['<C-u>'] = { 'scroll_documentation_up', 'fallback' },
            ['<C-d>'] = { 'scroll_documentation_down', 'fallback' },
        },

        completion = {
            -- Show documentation when selecting a completion item
            documentation = {
                auto_show = true, -- TODO: turn this to off? once carbonight is ready
                auto_show_delay_ms = 0,
                window = { border = 'single' },
            },

            keyword = { range = 'full' },

            -- Preselect first one, don't complete until confirmation
            list = { selection = { preselect = true, auto_insert = false } },

            menu = {
                draw = {
                    -- TODO: really cool but ugly AF now
                    -- need to add support for this in carbonight first
                    -- We don't need label_description now because label and label_description are already
                    -- combined together in label by colorful-menu.nvim.
                    -- columns = { { 'kind_icon' }, { 'label', gap = 1 } },
                    -- components = {
                    --     label = {
                    --         text = function(ctx)
                    --             return require('colorful-menu').blink_components_text(ctx)
                    --         end,
                    --         highlight = function(ctx)
                    --             return require('colorful-menu').blink_components_highlight(ctx)
                    --         end,
                    --     },
                    -- },
                },
            },
        },

        signature = {
            enabled = true,
            window = {
                border = 'single',
                show_documentation = false,
            },
        },

        fuzzy = { implementation = 'prefer_rust_with_warning' },

        sources = {
            default = { 'lsp', 'path', 'snippets', 'lazydev', 'git' },

            providers = {
                lazydev = {
                    name = 'LazyDev',
                    module = 'lazydev.integrations.blink',
                    score_offset = 100, -- show at a higher priority than lsp
                },
                git = {
                    module = 'blink-cmp-git',
                    name = 'Git',
                    opts = {
                        commit = { triggers = { '~' } },
                    },
                },

                snippets = {
                    -- score_offset = 200, -- make snippets highest priority
                    transform_items = function(_, items)
                        return vim.tbl_filter(function(item)
                            -- vim.print(item)
                            if item.kind ~= require('blink.cmp.types').CompletionItemKind.Snippet then
                                return true
                            end

                            local name = item.description
                            -- vim.print(name)
                            local parts = vim.split(name, ' ', { trimempty = false })
                            local namespace = #parts > 1 and parts[1] or nil
                            -- vim.print(namespace)
                            if not namespace then
                                return true
                            end

                            -- vim.print(vim.fn.getcwd())
                            local path = vim.split(vim.fn.getcwd(), '/')
                            local dir = path[#path]
                            -- vim.print(dir)

                            return dir == namespace
                        end, items)
                    end,
                },
            },
        },

        appearance = {
            -- TODO: change icons to make more sense to me
            kind_icons = {
                Text = '', --   󰉿
                Method = '󰊕',
                Function = '󰊕',
                Constructor = '󰒓',
                --   Constructor   = " ",

                Field = '󰜢',
                Variable = '󰆦',
                Property = '󰖷',

                Class = '󱡠',
                --   Class         = " ",
                Interface = '󱡠',
                Struct = '󱡠',
                Module = '󰅩',

                Unit = '󰪚',
                Value = '󰦨',
                Enum = '󰦨',
                EnumMember = '󰦨',

                Keyword = '󰻾',
                Constant = '󰏿',

                Snippet = '',
                --   Snippet       = "󱄽 ",
                Color = '󰏘',
                --   Color         = " ",
                File = '󰈔',
                --   File          = " ",
                Reference = '󰬲',
                Folder = '󰉋',
                Event = '󱐋',
                Operator = '󰪚',
                TypeParameter = '󰬛',
            },
        },
    },
    opts_extend = { 'sources.default' },

    -- TODO: pressing backk (deleting), should re-show completion menu
    -- TODO: ghost text only for LLMs?
}

-- From LazyVim
--   Array         = " ",
--   Boolean       = "󰨙 ",
--   Codeium       = "󰘦 ",
--   Control       = " ",
--   Collapsed     = " ",
--   Copilot       = " ",
--   Enum          = " ",
--   EnumMember    = " ",
--   Event         = " ",
--   Field         = " ",
--   Folder        = " ",
--   Function      = "󰊕 ",
--   Interface     = " ",
--   Key           = " ",
--   Keyword       = " ",
--   Method        = "󰊕 ",
--   Module        = " ",
--   Namespace     = "󰦮 ",
--   Null          = " ",
--   Number        = "󰎠 ",
--   Object        = " ",
--   Operator      = " ",
--   Package       = " ",
--   Property      = " ",
--   Reference     = " ",
--   String        = " ",
--   Struct        = "󰆼 ",
--   Supermaven    = " ",
--   TabNine       = "󰏚 ",
--   Text          = " ",
--   TypeParameter = " ",
--   Unit          = " ",
--   Value         = " ",
--   Variable      = "󰀫 ",
