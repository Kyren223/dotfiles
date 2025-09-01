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

local function find_build_buf()
    for _, buf in ipairs(vim.api.nvim_list_bufs()) do
        if vim.api.nvim_buf_is_valid(buf) and vim.api.nvim_get_option_value('buftype', { buf = buf }) == 'terminal' then
            local ok, val = pcall(vim.api.nvim_buf_get_var, buf, 'is_build_term')
            if ok and val then
                return buf
            end
        end
    end
    return -1
end

local function compile_project(command)
    return function()
        local orig_win = vim.api.nvim_get_current_win()
        local build_buf = find_build_buf()
        local build_win = -1

        if build_buf == -1 then
            vim.cmd('botright vsplit')
            -- vim.cmd('vertical resize ' .. math.floor(vim.o.columns * 0.395))
            vim.cmd('vertical resize ' .. math.floor(vim.o.columns * 0.46))
            build_win = vim.api.nvim_get_current_win()
            vim.cmd('terminal')
            build_buf = vim.api.nvim_get_current_buf()
            vim.api.nvim_buf_set_var(build_buf, 'is_build_term', true)
            vim.opt_local.bufhidden = 'delete'
        else
            vim.cmd('CompileClose')
            compile_project(command)()
            return
            -- build_win = vim.fn.bufwinid(build_buf)
            -- if build_win == -1 then
            --     vim.cmd('botright vsplit')
            --     build_win = vim.api.nvim_get_current_win()
            --     vim.api.nvim_win_set_buf(build_win, build_buf)
            -- end
        end

        vim.api.nvim_set_current_win(build_win)
        local chan = vim.api.nvim_buf_get_var(build_buf, 'terminal_job_id')
        vim.api.nvim_chan_send(chan, command)
        vim.api.nvim_set_current_win(orig_win)
    end
end

vim.api.nvim_create_user_command('CompileClose', function()
    local build_buf = find_build_buf()
    if build_buf ~= -1 then
        local chan = vim.api.nvim_buf_get_var(build_buf, 'terminal_job_id')
        vim.fn.jobstop(chan)
        vim.api.nvim_buf_delete(build_buf, { force = true })
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

        vim.keymap.set('n', '<A-m>', compile_project('clear && ./build.sh krypton\n'), { desc = '[H]eader and Source Switcher' })
        vim.keymap.set('n', '<A-r>', compile_project('clear && ./build.sh krypton\n'), { desc = '[H]eader and Source Switcher' })
        vim.keymap.set('n', '<A-c>', compile_project('clear && ./build.sh krypton\n'), { desc = '[H]eader and Source Switcher' })
        vim.keymap.set('n', '<A-t>', compile_project('clear && ./build.sh test\n'), { desc = '[H]eader and Source Switcher' })
        vim.keymap.set('n', '<leader>h', '<cmd>ClangdSwitchSourceHeader<cr>', { desc = '[H]eader and Source Switcher' })
    end,
}
