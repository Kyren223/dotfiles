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
function Jump_to_file_location(win, path, lnum, col, focus)
    if win then
        vim.api.nvim_win_call(win, function()
            vim.cmd('edit ' .. path)
            vim.api.nvim_win_set_cursor(0, { tonumber(lnum), tonumber(col) - 1 })
        end)
        if focus then
            vim.api.nvim_set_current_win(win)
        end
    else
        vim.cmd('edit ' .. path)
        vim.api.nvim_win_set_cursor(0, { tonumber(lnum), tonumber(col) - 1 })
    end
end

function Jump_to_file_location_at_cursor(focus)
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

    Jump_to_file_location(main_win, path, lnum, col, focus)
end

vim.api.nvim_create_autocmd('TermOpen', {
    callback = function(args)
        vim.api.nvim_buf_set_keymap(
            args.buf,
            'n',
            'gd',
            '<cmd>lua Jump_to_file_location_at_cursor(true)<CR>',
            { noremap = true, silent = true }
        )
        vim.api.nvim_buf_set_keymap(
            args.buf,
            'n',
            'go',
            '<cmd>lua Jump_to_file_location_at_cursor(false)<CR>',
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
    -- if pos[x] == 0 then
    --     is_build = function(pos)
    --         return pos ~= 0
    --     end
    -- else
    --     is_build = function(pos)
    --         return pos == 0
    --     end
    -- end

    -- NOTE: for new monitor setup, temporary
    if pos[x] < 160 then
        is_build = function(pos_x)
            return pos_x > 160
        end
    else
        is_build = function(pos_x)
            return pos_x == 0
        end
    end
    -- vim.notify('Current window: ' .. vim.inspect(current) .. ' ' .. vim.inspect(pos), vim.log.levels.INFO)

    local windows = vim.tbl_filter(filter, vim.api.nvim_list_wins())
    -- vim.notify('Valid windows: ' .. vim.inspect(windows), vim.log.levels.INFO)

    local old_build_win = -1
    local new_build_win = -1
    for _, win in ipairs(windows) do
        local pos = vim.api.nvim_win_get_position(win)
        -- vim.notify('Window id: ' .. vim.inspect(win) .. ' Window pos: ' .. vim.inspect(pos), vim.log.levels.INFO)
        -- vim.notify(
        --     'is build: ' .. vim.inspect(is_build(pos[1])) .. ' y == 0: ' .. vim.inspect(pos[2] == 0),
        --     vim.log.levels.INFO
        -- )
        if vim.api.nvim_win_get_buf(win) == BuildTerminalBuf then
            old_build_win = win
        end
        if is_build(pos[x]) and pos[y] == 0 then
            new_build_win = win
            -- vim.notify('SET BUILD_WIN: ' .. vim.inspect(build_win), vim.log.levels.INFO)
        end
    end
    if old_build_win == new_build_win then
        old_build_win = -1
    end

    if new_build_win == -1 then
        vim.cmd('botright vsplit')
        -- vim.cmd('vertical resize ' .. math.floor(vim.o.columns * 0.395))
        -- vim.cmd('vertical resize ' .. math.floor(vim.o.columns * 0.46))
        new_build_win = vim.api.nvim_get_current_win()
        -- vim.notify('SET BUILD_WIN: ' .. vim.inspect(build_win), vim.log.levels.INFO)
    end

    if not filter(new_build_win) then
        return
    end
    -- local build_pos = vim.api.nvim_win_get_position(build_win)
    -- vim.notify(
    --     'Build ID: ' .. vim.inspect(build_win) .. ' Build pos: ' .. vim.inspect(build_pos),
    --     vim.log.levels.INFO
    -- )

    vim.api.nvim_set_current_win(new_build_win)

    local build_buf = vim.api.nvim_win_get_buf(new_build_win)
    if vim.api.nvim_win_get_buf(current) == BuildTerminalBuf then
        -- NOTE(kyren): switch buffers
        vim.api.nvim_win_set_buf(current, build_buf)
    end

    local old_terminal = BuildTerminalBuf
    BuildTerminalBuf = vim.api.nvim_create_buf(false, true)
    vim.bo[BuildTerminalBuf].filetype = 'build_terminal'
    vim.api.nvim_buf_call(BuildTerminalBuf, function()
        -- vim.fn.termopen(command, vim.empty_dict())
        -- local job_id = vim.fn.termopen(vim.o.shell)
        local job_id = vim.fn.jobstart(vim.o.shell, { term = true })
        if job_id > 0 then
            vim.fn.chansend(job_id, command)
        end
    end)

    local previous_buffer = vim.api.nvim_win_get_buf(new_build_win)
    vim.api.nvim_win_set_buf(new_build_win, BuildTerminalBuf)
    if old_build_win ~= -1 then
        vim.api.nvim_win_set_buf(old_build_win, previous_buffer)
    end

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
-- NOTE: Jump to next error based on compile()
----------------------------------------------------------------------------

function JumpToDiagnostic(direction, is_error, is_warning)
    vim.defer_fn(function()
        vim.cmd('w')
    end, 10)

    vim.defer_fn(function()
        -- vim.notify("Running JumpToError after delay", "warn")

        if BuildTerminalBuf == nil or not vim.api.nvim_buf_is_valid(BuildTerminalBuf) then
            -- vim.notify("BuildTerminalBuf not ready", "warn")
            return
        end

        local warning_parsers = {
            function(line)
                -- Clang: ABS:LINE:COL: warning: ...
                local file, lnum = line:match('^(.-):(%d+):%d+:%s+warning:')
                if file and lnum then
                    return { file = file, line = tonumber(lnum) }
                end
            end,
        }

        local error_parsers = {
            function(line)
                -- Clang: ABS:LINE:COL: error: ...
                local file, lnum = line:match('^(.-):(%d+):%d+:%s+error:')
                if file and lnum then
                    return { file = file, line = tonumber(lnum) }
                end
            end,

            function(line)
                -- MSVC: PATH(LINE): error ...
                -- Z:\home\kyren\projects\krypton\src\krypton\libkrypton.c(22): error C2220: ...
                -- Z:\home\kyren\projects\krypton\src\krypton\libkrypton.c(22): warning C4018: ...
                local file, lnum, kind = line:match('^(.-)%((%d+)%)%:%s*(%a+)')
                if file and lnum and kind then
                    kind = kind:lower()

                    -- Convert Z:\home\... to /home/...
                    -- Only if it matches the expected WSL mount pattern
                    local wsl_path = file:gsub('^Z:\\', '/'):gsub('\\', '/')

                    return {
                        file = wsl_path,
                        line = tonumber(lnum),
                        kind = kind,
                    }
                end
                return nil
            end,
        }

        local lines = vim.api.nvim_buf_get_lines(BuildTerminalBuf, 0, -1, false)
        -- vim.notify('Build buffer line count: ' .. #lines, 'warn')

        local diagnostics = {}
        for _, line in ipairs(lines) do
            if is_warning then
                for _, f in ipairs(warning_parsers) do
                    local warning = f(line)
                    if warning then
                        table.insert(diagnostics, warning)
                        break
                    end
                end
            end

            if is_error then
                for _, f in ipairs(error_parsers) do
                    local error = f(line)
                    if error then
                        table.insert(diagnostics, error)
                        break
                    end
                end
            end
        end

        -- vim.notify('Diagnostics count: ' .. #diagnostics, 'warn')
        if #diagnostics == 0 then
            return
        end

        local win = 0
        local current_file = vim.api.nvim_buf_get_name(win)
        local filtered = {}
        for _, e in ipairs(diagnostics) do
            if e.file == current_file then
                table.insert(filtered, e)
            end
        end

        -- vim.notify("Filtered errors: " .. #filtered, "warn")
        if #filtered == 0 then
            return
        end

        table.sort(filtered, function(a, b)
            return a.line < b.line
        end)

        local cursor_line = vim.api.nvim_win_get_cursor(win)[1]

        if direction == 1 then
            for _, e in ipairs(filtered) do
                if e.line > cursor_line then
                    vim.api.nvim_win_set_cursor(win, { e.line, 0 })
                    return
                end
            end
            vim.api.nvim_win_set_cursor(win, { filtered[1].line, 0 })
        else
            for i = #filtered, 1, -1 do
                if filtered[i].line < cursor_line then
                    vim.api.nvim_win_set_cursor(win, { filtered[i].line, 0 })
                    return
                end
            end
            vim.api.nvim_win_set_cursor(win, { filtered[#filtered].line, 0 })
        end
    end, 0) -- in milliseconds

    vim.defer_fn(function()
        if vim.g.project_compile_cmd then
            Compile_project(vim.g.project_compile_cmd)
        else
            vim.notify('vim.g.project_compile_cmd missing', 'warn')
        end
    end, 100) -- in milliseconds
end

function JumpToNextError()
    return JumpToDiagnostic(1, true, false)
end

function JumpToPrevError()
    return JumpToDiagnostic(-1, true, false)
end

function JumpToNextWarning()
    return JumpToDiagnostic(1, true, true)
end

function JumpToPrevWarning()
    return JumpToDiagnostic(-1, true, true)
end

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

vim.api.nvim_create_autocmd({ 'VimEnter', 'BufWritePost' }, {
    callback = function()
        vim.schedule(function()
            vim.wait(100)
            Run_nvim_lua()
        end)
    end,
})

----------------------------------------------------------------------------
-- NOTE: utility to create a new "k memory"
----------------------------------------------------------------------------
local function create_and_or_open_memory()
    vim.ui.input({ prompt = 'Enter title: ' }, function(title)
        if not title or title == '' then
            return
        end

        local sanitized_title = title:gsub('%s+', '-')
        local cmd = { 'k', 'memory', sanitized_title, '--output-path', '--edit=false', '--no-rebuild-self' }
        local output_lines = {}
        vim.notify('Memory command: ' .. vim.inspect(cmd))

        vim.fn.jobstart(cmd, {
            stdout_buffered = true,
            stderr_buffered = true,

            on_stdout = function(_, data)
                if data then
                    for _, line in ipairs(data) do
                        if line ~= '' then
                            table.insert(output_lines, line)
                        end
                    end
                end
            end,

            on_stderr = function(_, data)
                if data then
                    for _, line in ipairs(data) do
                        if line ~= '' then
                            table.insert(output_lines, line)
                        end
                    end
                end
            end,

            on_exit = function(_, exit_code)
                if exit_code == 0 then
                    local target_file = output_lines[#output_lines]
                    vim.notify(vim.inspect(output_lines))

                    if target_file and target_file ~= '' then
                        -- Trim any trailing carriage returns or spaces
                        target_file = target_file:gsub('%s+$', '')

                        vim.schedule(function()
                            vim.cmd('edit ' .. vim.fn.fnameescape(target_file))
                        end)
                    else
                        vim.notify('Error: CLI succeeded but stdout was empty!', vim.log.levels.ERROR)
                    end
                else
                    vim.api.nvim_err_writeln("Error: 'k memory' failed with exit code " .. exit_code)
                end
            end,
        })
    end)
end

-- 5. Create the Neovim user command (:MyCliCreate)
vim.api.nvim_create_user_command('KMemory', create_and_or_open_memory, {})

----------------------------------------------------------------------------
-- NOTE:
----------------------------------------------------------------------------
