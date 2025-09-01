local function augroup(name)
    return vim.api.nvim_create_augroup('kyren-' .. name, { clear = true })
end

-- Highlight when yanking text
vim.api.nvim_create_autocmd('TextYankPost', {
    group = augroup('highlight-yank'),
    callback = function()
        vim.highlight.on_yank()
    end,
})

vim.api.nvim_create_autocmd('BufEnter', {
    desc = 'Disable newlines on commented lines from continuing the comment',
    group = augroup('disable-comments-continuation'),
    callback = function()
        -- vim.opt_local.formatoptions:remove('r') -- no comments on enter
        vim.opt_local.formatoptions:remove('o') -- no comments on `o` or `O`
    end,
})

-- NOTE: highlight %v, %s etc in go string literals
vim.api.nvim_create_autocmd({ 'BufEnter', 'TextChanged', 'InsertLeave' }, {
    pattern = '*.go',
    callback = function()
        local query = vim.treesitter.query.parse('go', '(interpreted_string_literal) @string')
        local parser = vim.treesitter.get_parser(0, 'go')
        if not parser then
            return
        end
        local tree = parser:parse()[1]
        local root = tree:root()
        local bufnr = vim.api.nvim_get_current_buf()

        for id, node in query:iter_captures(root, bufnr, 0, -1) do
            if query.captures[id] == 'string' then
                local start_row, start_col, end_row, end_col = node:range()

                -- Get the text of the string literal
                local text = vim.api.nvim_buf_get_text(bufnr, start_row, start_col, end_row, end_col, {})[1]

                -- Highlight only the parts matching `%[a-z]`
                for match_start, match_end in text:gmatch('()%%[a-z]()') do
                    vim.api.nvim_buf_add_highlight(
                        bufnr,
                        -1,
                        '@lsp.type.formatSpecifier.go', -- Higlight group
                        start_row,
                        start_col + match_start - 1,
                        start_col + match_end - 1
                    )
                end
            end
        end
    end,
})

-- NOTE: Snacks snippet to notify LSP servers when renaming files in oil.nvim
vim.api.nvim_create_autocmd('User', {
    pattern = 'OilActionsPost',
    callback = function(event)
        if event.data.actions.type == 'move' then
            Snacks.rename.on_rename_file(event.data.actions.src_url, event.data.actions.dest_url)
        end
    end,
})

-- Check if we need to reload the file when it changed
vim.api.nvim_create_autocmd({ 'FocusGained', 'TermClose', 'TermLeave' }, {
    group = augroup('checktime'),
    callback = function()
        if vim.o.buftype ~= 'nofile' then
            vim.cmd('checktime')
        end
    end,
})

-- close some filetypes with <q>
vim.api.nvim_create_autocmd('FileType', {
    group = augroup('close_with_q'),
    pattern = {
        'PlenaryTestPopup',
        'checkhealth',
        'dbout',
        'gitsigns-blame',
        'grug-far',
        'help',
        'lspinfo',
        'neotest-output',
        'neotest-output-panel',
        'neotest-summary',
        'notify',
        'qf',
        'startuptime',
        'tsplayground',
    },
    callback = function(event)
        vim.bo[event.buf].buflisted = false
        vim.schedule(function()
            vim.keymap.set('n', 'q', function()
                vim.cmd('close')
                pcall(vim.api.nvim_buf_delete, event.buf, { force = true })
            end, {
                buffer = event.buf,
                silent = true,
                desc = 'Quit buffer',
            })
        end)
    end,
})

-- Format and organize imports on file save
vim.api.nvim_create_autocmd('BufWritePre', {
    group = augroup('java-auto-format'),
    pattern = '*.java',
    callback = function(event)
        if vim.g.disable_autoformat or vim.b[event.buf].disable_autoformat then
            return
        end

        require('jdtls').organize_imports()
        vim.lsp.buf.format({ async = false })
    end,
})

-- NOTE: template for C/C++ files
vim.api.nvim_create_autocmd({ 'BufNewFile', 'BufEnter' }, {
    pattern = { '*.c', '*.h', '*.cpp' },
    callback = function()
        local buf = vim.api.nvim_get_current_buf()
        local line_count = vim.api.nvim_buf_line_count(buf)
        local is_empty = line_count == 1 and vim.api.nvim_buf_get_lines(buf, 0, 1, false)[1] == ''
        if not is_empty then
            return
        end

        local ext = vim.fn.expand('%:e')
        local cwd = vim.fn.getcwd()
        local project_name = vim.fn.fnamemodify(cwd, ':t')
        local copyright = nil
        local lines = nil

        if project_name == 'krypton' then
            copyright = {
                '// Copyright (c) Kyren223',
                '// Licensed under the MIT license (https://opensource.org/license/mit/)',
                '',
            }

            local c_template = {
                '#include "base.h"',
                '',
            }

            lines = {
                c = c_template,
                h = {
                    '#ifndef ' .. string.upper(vim.fn.expand('%:t:r')) .. '_H',
                    '#define ' .. string.upper(vim.fn.expand('%:t:r')) .. '_H',
                    '',
                    '#include "generated/' .. vim.fn.expand('%:t:r') .. '.meta.h"',
                    '',
                    '#endif',
                },
                cpp = c_template,
            }
        end

        if not lines then
            return
        end
        local content = lines[ext]

        if copyright then
            content = vim.list_extend(copyright, content)
        end

        vim.api.nvim_buf_set_lines(0, 0, -1, false, content)
    end,
})

-- NOTE: Function to highlight TODO/NOTE patterns
local ns = vim.api.nvim_create_namespace('todo_highlight')
local groups = {
    todo = {
        keywords = { 'TODO', 'WIP' },
        hl = '@comment.todo.comment',
    },
    warning = {
        keywords = { 'WARN', 'WARNING', 'HACK', 'SECURITY', 'SECURE', 'IMPORTANT' },
        hl = '@comment.warning.comment',
    },
    error = {
        keywords = { 'FIX', 'FIXME', 'ERROR', 'UNSAFE', 'SAFETY' },
        hl = '@comment.error.comment',
    },
    perf = {
        keywords = { 'PERF', 'OPTIMIZE', 'STUDY' },
        hl = '@comment.perf.comment',
    },
    note = {
        keywords = { 'NOTE', 'INFO', 'DOCS', 'TEST' },
        hl = '@comment.note.comment',
    },
}
local scopes = {
    bracket = '@punctuation.bracket.comment',
    constant = '@constant.comment',
    delimiter = '@punctuation.delimiter.comment',
}

function RenderTodoHighlights(bufnr)
    vim.api.nvim_buf_clear_namespace(bufnr, ns, 0, -1)
    local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)

    for i, line in ipairs(lines) do
        for _, cfg in pairs(groups) do
            for _, kw in ipairs(cfg.keywords) do
                for s, e in line:gmatch('()' .. kw .. '()') do
                    -- 1) highlight keyword
                    vim.api.nvim_buf_add_highlight(bufnr, ns, cfg.hl, i - 1, s - 1, e - 1)

                    local next_char = line:sub(e, e)

                    -- 2) highlight (...) if it directly follows keyword
                    if next_char == '(' then
                        local ps = e
                        local pe = nil
                        for j = e + 1, math.min(#line, e + 100) do
                            if line:sub(j, j) == ')' then
                                pe = j
                                break
                            end
                        end

                        if pe then
                            vim.api.nvim_buf_add_highlight(bufnr, ns, scopes.bracket, i - 1, ps - 1, ps)
                            vim.api.nvim_buf_add_highlight(bufnr, ns, scopes.bracket, i - 1, pe - 1, pe)
                            if pe - ps > 1 then
                                vim.api.nvim_buf_add_highlight(bufnr, ns, scopes.constant, i - 1, ps, pe - 1)
                            end

                            e = pe
                        end
                    end

                    -- -- 3) highlight ":" if directly after keyword or after parens
                    local colon_pos = nil
                    if line:sub(e, e) == ':' then
                        colon_pos = e
                    end

                    if colon_pos then
                        vim.api.nvim_buf_add_highlight(bufnr, ns, scopes.delimiter, i - 1, colon_pos - 1, colon_pos)
                    end
                end
            end
        end
    end
end

vim.api.nvim_create_autocmd({ 'VimEnter', 'BufRead', 'BufWinEnter', 'BufWritePost', 'TextChanged', 'TextChangedI' }, {
    nested = true,
    callback = function(args)
        local bufnr = args.buf
        RenderTodoHighlights(bufnr)
    end,
})

function Jump_to_error(focus)
    local line = vim.api.nvim_get_current_line()
    local path, lnum, col = line:match('([^:]+):(%d+):(%d+):')
    if not (path and lnum) then
        vim.cmd('normal! gd')
        return
    end

    local main_win = nil
    for _, win in ipairs(vim.api.nvim_list_wins()) do
        local buf = vim.api.nvim_win_get_buf(win)
        if vim.api.nvim_buf_get_option(buf, 'buftype') ~= 'terminal' then
            main_win = win
            break
        end
    end

    if main_win then
        vim.api.nvim_win_call(main_win, function()
            vim.cmd('edit ' .. path)
            vim.api.nvim_win_set_cursor(0, { tonumber(lnum), tonumber(col) - 1 })
        end)
        if focus then
            vim.api.nvim_set_current_win(main_win)
        end
    else
        vim.cmd('edit ' .. path)
        vim.api.nvim_win_set_cursor(0, { tonumber(lnum), tonumber(col) - 1 })
    end
end

vim.api.nvim_create_autocmd('TermOpen', {
    callback = function(args)
        vim.api.nvim_buf_set_keymap(
            args.buf,
            'n',
            'gd',
            '<cmd>lua Jump_to_error(true)<CR>',
            { noremap = true, silent = true }
        )
        vim.api.nvim_buf_set_keymap(
            args.buf,
            'n',
            'go',
            '<cmd>lua Jump_to_error(false)<CR>',
            { noremap = true, silent = true }
        )
    end,
})
