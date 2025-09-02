-- https://clangd.llvm.org/installation.html
---
--- - **NOTE:** Clang >= 11 is recommended! See [#23](https://github.com/neovim/nvim-lspconfig/issues/23).
--- - If `compile_commands.json` lives in a build directory, you should
---   symlink it to the root of your source tree.
---   ```
---   ln -s /path/to/myproject/build/compile_commands.json /path/to/myproject/
---   ```
--- - clangd relies on a [JSON compilation database](https://clang.llvm.org/docs/JSONCompilationDatabase.html)
---   specified as compile_commands.json, see https://clangd.llvm.org/installation#compile_commandsjson

-- https://clangd.llvm.org/extensions.html#switch-between-sourceheader
local function switch_source_header(bufnr)
    local method_name = 'textDocument/switchSourceHeader'
    local client = vim.lsp.get_clients({ bufnr = bufnr, name = 'clangd' })[1]
    if not client then
        return vim.notify(
            ('method %s is not supported by any servers active on the current buffer'):format(method_name)
        )
    end
    local params = vim.lsp.util.make_text_document_params(bufnr)
    client.request(method_name, params, function(err, result)
        if err then
            error(tostring(err))
        end
        if not result then
            vim.notify('corresponding file cannot be determined')
            return
        end
        vim.cmd.edit(vim.uri_to_fname(result))
    end, bufnr)
end

local function symbol_info()
    local bufnr = vim.api.nvim_get_current_buf()
    local clangd_client = vim.lsp.get_clients({ bufnr = bufnr, name = 'clangd' })[1]
    if not clangd_client or not clangd_client.supports_method('textDocument/symbolInfo') then
        return vim.notify('Clangd client not found', vim.log.levels.ERROR)
    end
    local win = vim.api.nvim_get_current_win()
    local params = vim.lsp.util.make_position_params(win, clangd_client.offset_encoding)
    clangd_client.request('textDocument/symbolInfo', params, function(err, res)
        if err or #res == 0 then
            -- Clangd always returns an error, there is not reason to parse it
            return
        end
        local container = string.format('container: %s', res[1].containerName) ---@type string
        local name = string.format('name: %s', res[1].name) ---@type string
        vim.lsp.util.open_floating_preview({ name, container }, '', {
            height = 2,
            width = math.max(string.len(name), string.len(container)),
            focusable = false,
            focus = false,
            border = 'single',
            title = 'Symbol Info',
        })
    end, bufnr)
end

local function compile_project(command)
    return function()
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
end

vim.api.nvim_create_user_command('CompileClose', function()
    if BuildTerminalBuf ~= nil and vim.api.nvim_buf_is_valid(BuildTerminalBuf) then
        vim.api.nvim_buf_delete(BuildTerminalBuf, { force = true })
    end
end, {})

vim.keymap.set({ 'i', 'n', 'v' }, '<C-q>', '<cmd>CompileClose<cr><cmd>wqa<cr>')

return {
    cmd = {
        'clangd',
        '--background-index',
        '--clang-tidy',
        '--header-insertion=never',
        '--completion-style=detailed',
        '--function-arg-placeholders=false',
        '--fallback-style=none',
    },
    filetypes = { 'c', 'cpp', 'objc', 'objcpp', 'cuda', 'proto' },
    root_markers = {
        '.clangd',
        '.clang-tidy',
        '.clang-format',
        'compile_commands.json',
        'compile_flags.txt',
        'configure.ac', -- AutoTools
        '.git',
    },
    init_options = {
        completeUnimported = true,
        clangdFileStatus = true,
    },
    capabilities = {
        textDocument = {
            completion = {
                editsNearCursor = true,
            },
        },
        offsetEncoding = { 'utf-8', 'utf-16' },
    },
    on_attach = function()
        vim.api.nvim_buf_create_user_command(0, 'ClangdSwitchSourceHeader', function()
            switch_source_header(0)
        end, { desc = 'Switch between source/header' })

        vim.api.nvim_buf_create_user_command(0, 'ClangdShowSymbolInfo', function()
            symbol_info()
        end, { desc = 'Show symbol info' })

        local compile = compile_project('clear && ./build.sh krypton\n')
        local test = compile_project('clear && ./build.sh test\n')

        vim.keymap.set('n', '<A-m>', compile, { desc = '[H]eader and Source Switcher' })
        vim.keymap.set('n', '<A-r>', compile, { desc = '[H]eader and Source Switcher' })
        vim.keymap.set('n', '<A-c>', compile, { desc = '[H]eader and Source Switcher' })
        vim.keymap.set('n', '<A-t>', test, { desc = '[H]eader and Source Switcher' })
        vim.keymap.set('n', '<leader>h', '<cmd>ClangdSwitchSourceHeader<cr>', { desc = '[H]eader and Source Switcher' })
        vim.keymap.set('n', 'H', '<cmd>ClangdSwitchSourceHeader<cr>', { desc = '[H]eader and Source Switcher' })
    end,
}
