return {
    'folke/todo-comments.nvim',
    dependencies = { 'nvim-lua/plenary.nvim' },
    event = 'VeryLazy',
    keys = {
        {
            '<leader>st',
            function()
                Snacks.picker.todo_comments({
                    layout = 'telescope',
                    follow = true,
                    hidden = true,
                    keywords = { 'TODO', 'WIP', 'FIX', 'FIXME', 'OPTIMIZE', 'SECURE' },
                })
            end,
            desc = '[S]earch [T]odos',
        },
        {
            '<leader>sn',
            function()
                Snacks.picker.todo_comments({
                    layout = 'telescope',
                    follow = true,
                    hidden = true,
                    keywords = {
                        'NOTE',
                        'INFO',
                        'DOCS',
                        'TEST',
                        'WARN',
                        'WARNING',
                        'SECURITY',
                        'HACK',
                        'IMPORTANT',
                        'PERF',
                        'STUDY',
                        'UNSAFE',
                        'SAFETY',
                        'ERROR',
                    },
                })
            end,
            desc = '[S]earch [N]otes',
        },
    },
    opts = {
        signs = false,
        keywords = {
            -- These are "todos"
            TODO = { icon = ' ', color = 'todo', alt = { 'WIP' } },
            FIX = { icon = ' ', color = 'error', alt = { 'FIXME', 'ERROR' } },
            OPTMZE = { icon = ' ', color = 'perf', alt = { 'OPTIMIZE' } },
            SECURE = { icon = '󰣮 ', color = 'warning' },
            -- These are "notes"
            NOTE = { icon = ' ', color = 'note', alt = { 'INFO', 'DOCS' } },
            TEST = { icon = '󰙨 ', color = 'note' },
            WARN = { icon = ' ', color = 'warning', alt = { 'WARNING', 'SECURITY' } },
            HACK = { icon = ' ', color = 'warning' },
            IMPORTANT = { icon = ' ', color = 'warning' },
            PERF = { icon = ' ', color = 'perf' },
            STUDY = { icon = ' ', color = 'perf' },
            UNSAFE = { icon = '󰍛 ', color = 'error', alt = { 'SAFETY' } },
        },
        highlight = {
            before = '', -- "fg" or "bg" or empty
            keyword = '', -- "wide" or empty
            after = '', -- "fg" or empty
            pattern = { [[.*<((KEYWORDS)%(\(.{-1,}\))?):]] }, -- vim regex
            comments_only = false,
        },
        colors = {
            todo = { '@comment.todo' },
            note = { '@comment.todo' },
            warning = { '@comment.warning' },
            error = { '@comment.error' },
            perf = { '@comment.perf' },
        },
        search = {
            command = 'rg',
            args = {
                '--color=never',
                '--no-heading',
                '--with-filename',
                '--line-number',
                '--column',
                '--hidden', -- show todos in hidden directories and files
                '--follow', -- follow symlinks
            },
            pattern = [[\b(KEYWORDS)\s*(\([^\)]*\))?\s*:]],
        },
    },
}
