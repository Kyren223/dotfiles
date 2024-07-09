-- NORMAL: lorem ipsum
-- TODO: lorem ipsum
-- FIX: lorem ipsum
-- OPTIMIZE: lorem ipsum
-- WARN: lorem ipsum
-- PERF: lorem ipsum
-- HACK: lorem ipsum
-- NOTE: lorem ipsum
-- TEST: lorem ipsum
-- UNSAFE: lorem ipsum
return {
    'folke/todo-comments.nvim',
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
        require('todo-comments').setup({
            signs = true, -- show icons in the signs column
            sign_priority = 8, -- sign priority

            keywords = {
                -- NOTE: These are "todos"
                TODO = { icon = ' ', color = 'info', alt = { 'todo' } },
                FIX = { icon = ' ', color = 'error', alt = { 'FIXME', 'BUG', 'ISSUE' } },
                OPTIMIZE = { icon = ' ', color = 'performance' },
                -- NOTE: These are "notes"
                WARN = { icon = ' ', color = 'warning', alt = { 'WARNING' } },
                PERF = { icon = ' ', color = 'performance', alt = { 'PERFORMANCE' } },
                HACK = { icon = ' ', color = 'warning', alt = { 'SMELL', 'CODE SMELL', 'BAD', 'BAD PRACTICE' } },
                NOTE = { icon = ' ', color = 'hint', alt = { 'INFO' } },
                TEST = { icon = '󰙨 ', color = 'test', alt = { 'TESTING', 'PASSED', 'FAILED' } },
                UNSAFE = { icon = '󰍛 ', color = 'error', alt = { 'SAFETY' } },
            },

            gui_style = {
                fg = 'NONE',
                bg = 'BOLD',
            },

            merge_keywords = true, -- when true, custom keywords will be merged with the defaults

            -- highlighting of the line containing the todo comment
            -- * before: highlights before the keyword (typically comment characters)
            -- * keyword: highlights of the keyword
            -- * after: highlights after the keyword (todo text)
            highlight = {
                multiline = true,
                multiline_pattern = '^.', -- lua pattern to match the next multiline from the start of the matched keyword
                multiline_context = 10, -- extra lines that will be re-evaluated when changing a line
                before = '', -- "fg" or "bg" or empty
                keyword = 'wide', -- "fg", "bg", "wide", "wide_bg", "wide_fg" or empty. (wide and wide_bg is the same as bg, but will also highlight surrounding characters, wide_fg acts accordingly but with fg)
                after = 'fg', -- "fg" or "bg" or empty
                pattern = {
                    [[.*<(KEYWORDS)\s*:]],
                    -- [[.*<(KEYWORDS)\s*]],
                    -- [[.*<(KEYWORDS)\s*!()]],
                }, -- pattern or table of patterns, used for highlighting (vim regex)
                comments_only = false,
                max_line_len = 400,
                exclude = {}, -- list of excluded filetypes
            },

            -- list of named colors where we try to extract the gui fg from the
            -- list of highlight groups or use the hex color if hl not found as a fallback
            colors = {
                default = { 'Identifier', '#7C3AED' },
                error = { 'DiagnosticError', 'ErrorMsg', '#DC2626' },
                warning = { 'DiagnosticWarn', 'WarningMsg', '#FBBF24' },
                info = { 'DiagnosticInfo', '#2563EB' },
                hint = { '#10B981' },
                test = { 'Identifier', '#FF00FF' },
                performance = { '#7C3AED' },
            },

            search = {
                command = 'rg',
                args = {
                    '--color=never',
                    '--no-heading',
                    '--with-filename',
                    '--line-number',
                    '--column',
                    -- "--hidden", -- show todos in hidden directories and files
                    '--follow', -- follow symlinks
                },

                -- regex that will be used to match keywords.
                -- don't replace the (KEYWORDS) placeholder
                pattern = [[\b(KEYWORDS):]],
                -- pattern = [[\b(KEYWORDS)\b]],
            },
        })
        vim.keymap.set('n', '<leader>st', '<cmd>TodoTelescope keywords=TODO,FIX<cr>', { desc = '[S]earch [T]odos' })
        vim.keymap.set('n', '<leader>lt', '<cmd>TodoTrouble<cr>', { desc = '[L]ist [T]odos' })
    end,
}
