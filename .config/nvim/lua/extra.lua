local function augroup(name)
    return vim.api.nvim_create_augroup('kyren-' .. name, { clear = true })
end

----------------------------------------------------------------------------
-- NOTE: Highlight when yanking text
----------------------------------------------------------------------------
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

----------------------------------------------------------------------------
-- NOTE: Snacks snippet to notify LSP servers when renaming files in oil.nvim
----------------------------------------------------------------------------
vim.api.nvim_create_autocmd('User', {
    pattern = 'OilActionsPost',
    callback = function(event)
        if event.data.actions.type == 'move' then
            Snacks.rename.on_rename_file(event.data.actions.src_url, event.data.actions.dest_url)
        end
    end,
})

----------------------------------------------------------------------------
-- NOTE: Check if we need to reload the file when it changed
----------------------------------------------------------------------------
vim.api.nvim_create_autocmd({ 'FocusGained', 'TermClose', 'TermLeave' }, {
    group = augroup('checktime'),
    callback = function()
        if vim.o.buftype ~= 'nofile' then
            vim.cmd('checktime')
        end
    end,
})

----------------------------------------------------------------------------
-- NOTE: Close some filetypes with <q>
----------------------------------------------------------------------------
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

----------------------------------------------------------------------------
-- NOTE: Format and organize imports on file save
----------------------------------------------------------------------------
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

----------------------------------------------------------------------------
-- NOTE: show unused zig variables as "DiagnosticUnnecessary" instead of error
----------------------------------------------------------------------------
local orig_underline_show = vim.diagnostic.handlers.underline.show
local custom_ns = vim.api.nvim_create_namespace('custom_unused_ns')

vim.diagnostic.handlers.underline.show = function(namespace, bufnr, diagnostics, opts)
    local normal_diags = {}
    local custom_diags = {}
    for _, diag in ipairs(diagnostics) do
        if diag.message:find('unused', 1, true) then
            table.insert(custom_diags, diag)
        else
            table.insert(normal_diags, diag)
        end
    end
    if #normal_diags > 0 and orig_underline_show ~= nil then
        orig_underline_show(namespace, bufnr, normal_diags, opts)
    end
    for _, diag in ipairs(custom_diags) do
        vim.highlight.range(
            bufnr,
            custom_ns,
            'DiagnosticUnnecessary',
            { diag.lnum, diag.col },
            { diag.end_lnum, diag.end_col },
            { inclusive = false }
        )
    end
end

local orig_underline_hide = vim.diagnostic.handlers.underline.hide

vim.diagnostic.handlers.underline.hide = function(namespace, bufnr)
    if orig_underline_hide ~= nil then
        orig_underline_hide(namespace, bufnr)
    end
    vim.api.nvim_buf_clear_namespace(bufnr, custom_ns, 0, -1)
end

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

----------------------------------------------------------------------------
-- NOTE: Function to highlight TODO/NOTE patterns
----------------------------------------------------------------------------
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

----------------------------------------------------------------------------
-- NOTE: Jump to a file location from a "path:line:column" in terminal buffers
----------------------------------------------------------------------------
function Jump_to_file_location(focus)
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

----------------------------------------------------------------------------
-- NOTE: Compile a project by opening a terminal, inspired by Casey's workflow
----------------------------------------------------------------------------
function Compile_project(command)
    local x = 2
    local y = 1
    local filter = function(win)
        return vim.api.nvim_win_is_valid(win) and vim.api.nvim_win_get_config(win).relative == ''
    end

    local current = vim.api.nvim_get_current_win()
    if not filter(current) then
        return
    end
    local pos = vim.api.nvim_win_get_position(current)
    local is_build = nil
    if pos[x] == 0 then
        is_build = function(pos)
            return pos ~= 0
        end
    else
        is_build = function(pos)
            return pos == 0
        end
    end
    -- vim.notify('Current window: ' .. vim.inspect(current), vim.log.levels.INFO)

    local windows = vim.tbl_filter(filter, vim.api.nvim_list_wins())
    -- vim.notify('Valid windows: ' .. vim.inspect(windows), vim.log.levels.INFO)

    local build_win = -1
    for _, win in ipairs(windows) do
        local pos = vim.api.nvim_win_get_position(win)
        -- vim.notify('Window id: ' .. vim.inspect(win) .. ' Window pos: ' .. vim.inspect(pos), vim.log.levels.INFO)
        -- vim.notify(
        --     'is build: ' .. vim.inspect(is_build(pos[1])) .. ' y == 0: ' .. vim.inspect(pos[2] == 0),
        --     vim.log.levels.INFO
        -- )
        if is_build(pos[x]) and pos[y] == 0 then
            build_win = win
            -- vim.notify('SET BUILD_WIN: ' .. vim.inspect(build_win), vim.log.levels.INFO)
        end
    end

    if build_win == -1 then
        vim.cmd('botright vsplit')
        -- vim.cmd('vertical resize ' .. math.floor(vim.o.columns * 0.395))
        -- vim.cmd('vertical resize ' .. math.floor(vim.o.columns * 0.46))
        build_win = vim.api.nvim_get_current_win()
        -- vim.notify('SET BUILD_WIN: ' .. vim.inspect(build_win), vim.log.levels.INFO)
    end

    if not filter(build_win) then
        return
    end
    -- local build_pos = vim.api.nvim_win_get_position(build_win)
    -- vim.notify(
    --     'Build ID: ' .. vim.inspect(build_win) .. ' Build pos: ' .. vim.inspect(build_pos),
    --     vim.log.levels.INFO
    -- )

    vim.api.nvim_set_current_win(build_win)

    local build_buf = vim.api.nvim_win_get_buf(build_win)
    if vim.api.nvim_win_get_buf(current) == BuildTerminalBuf then
        -- NOTE(kyren): switch buffers
        vim.api.nvim_win_set_buf(current, build_buf)
    end

    local old_terminal = BuildTerminalBuf
    BuildTerminalBuf = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_buf_call(BuildTerminalBuf, function()
        vim.fn.termopen(command, vim.empty_dict())
    end)
    vim.api.nvim_win_set_buf(build_win, BuildTerminalBuf)

    if old_terminal then
        vim.api.nvim_buf_delete(old_terminal, { force = true })
    end

    vim.api.nvim_set_current_win(current)
end

vim.api.nvim_create_user_command('CompileClose', function()
    if BuildTerminalBuf ~= nil and vim.api.nvim_buf_is_valid(BuildTerminalBuf) then
        vim.api.nvim_buf_delete(BuildTerminalBuf, { force = true })
    end
end, {})

vim.keymap.set({ 'i', 'n', 'v' }, '<C-q>', '<cmd>CompileClose<cr><cmd>wqa<cr>')

----------------------------------------------------------------------------
-- NOTE: Run arbitrary code (if trusted) when opening a project
----------------------------------------------------------------------------

local init_trusted_paths = {
    '/home/kyren/projects/krypton',
}

function Run_nvim_lua()
    -- NOTE(kyren): I use cwd instead of partial path for better security
    local cwd = vim.fn.getcwd()

    if vim.tbl_contains(init_trusted_paths, cwd) then
        local init_path = cwd .. '/.nvim.lua'
        if vim.fn.filereadable(init_path) == 1 then
            vim.cmd('source ' .. init_path)
        end
    end
end

vim.api.nvim_create_autocmd({ 'VimEnter' }, {
    callback = function()
        vim.schedule(function()
            vim.wait(100)
            Run_nvim_lua()
        end)
    end,
})

----------------------------------------------------------------------------
-- NOTE:
----------------------------------------------------------------------------
