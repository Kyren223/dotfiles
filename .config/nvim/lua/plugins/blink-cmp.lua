return {
    enabled = true,
    'saghen/blink.cmp',
    event = 'InsertEnter',
    version = '1.*',
    dependencies = {
        { 'Kaiser-Yang/blink-cmp-git', dependencies = { 'nvim-lua/plenary.nvim' } },
        { 'L3MON4D3/LuaSnip', version = 'v2.*' },
    },
    ---@module 'blink.cmp'
    ---@type blink.cmp.Config
    opts = {
        snippets = { preset = 'luasnip' },
        keymap = {
            preset = 'enter',
            ['<C-e>'] = {},
            ['<C-c>'] = { 'hide', 'fallback' },

            ['<C-b>'] = {},
            ['<C-f>'] = {},
            ['<C-u>'] = { 'scroll_documentation_up', 'fallback' },
            ['<C-d>'] = { 'scroll_documentation_down', 'fallback' },
            ['<cr>'] = {
                function(cmp)
                    local item = cmp.get_selected_item()

                    -- NOTE(kyren): a bunch of annoying hacky stuff that basically takes a thing
                    -- like "foo.unw|" and turns it into "foo.unwrap|" by adding only the "rap"
                    -- part, then expands this with luasnip to the full completion.
                    -- Because I have auto_insert set to false it means blink doesn't insert the
                    -- actual .unwrap and even when selecting it, it just exapnds it without
                    -- inserting it into the actual buffer, so the solution for me was to just
                    -- add it, then manually expand it by hijacking this function.
                    if item and item.label == '.unwrap' then
                        -- I think it must be schedule so it doesn't happen immediately but on the
                        -- next "tick", so blink doesn't explain
                        vim.schedule(function()
                            local ctx = cmp.get_context()
                            if not ctx or not ctx.bounds then
                                return cmp.accept()
                            end
                            local partial = ctx.get_keyword() or ''
                            local full = cmp.get_selected_item().label
                            local rest = full:sub(#partial + 1 + 1)

                            local row = ctx.bounds.line_number - 1
                            local col = ctx.bounds.start_col + ctx.bounds.length

                            local line = vim.api.nvim_buf_get_lines(ctx.bufnr, row, row + 1, false)[1]
                            local cursor_at_eol = col > #line

                            vim.api.nvim_put({ rest }, 'c', cursor_at_eol, true)
                            require('luasnip').expand()
                        end)
                        return true
                    end

                    return cmp.accept()
                end,
                'fallback',
            },
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
            list = {
                selection = {
                    preselect = true,
                    -- auto_insert = false,
                    auto_insert = function(ctx)
                        -- vim.notify()
                        return ctx.get_keyword() == 'unwrap'
                    end,
                },
            },

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
                },

                lsp = {
                    name = 'lsp',
                    module = 'blink.cmp.sources.lsp',
                    transform_items = function(ctx, items)
                        if vim.bo[ctx.bufnr].filetype == 'java' then
                            local java_package_weights = require('plugins.nvim-jdtls').java_package_weights

                            for _, item in ipairs(items) do
                                -- jdtls puts the fully qualified package path inside 'detail'
                                local detail = item.detail or ''
                                if detail ~= '' then
                                    for pattern, weight in pairs(java_package_weights) do
                                        pattern = '^' .. pattern
                                        if detail:match(pattern) then
                                            item.score_offset = weight
                                            break -- Match found, move to the next item
                                        end
                                    end
                                end
                            end
                        end

                        return items
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

    -- TODO: pressing back (deleting), should re-show completion menu
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
