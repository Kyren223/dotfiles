-- vim.api.nvim_create_autocmd('FileType', {
--     pattern = { 'markdown', 'noice' },
--     callback = function()
--         vim.opt_local.conceallevel = 2
--         vim.opt_local.concealcursor = 'nc'
--     end,
-- })
--
-- vim.api.nvim_create_autocmd('FileType', {
--     pattern = { 'noice', 'markdown' },
--     callback = function(args)
--         -- Target only floating windows
--         if vim.api.nvim_win_get_config(0).relative == '' then
--             return
--         end
--
--         -- Bind 'gd' specifically inside the hover popup buffer
--         vim.keymap.set('n', 'gd', function()
--             -- Grab word under cursor in the popup
--             local cword = vim.fn.expand('<cword>')
--             local win_ids = vim.api.nvim_list_wins()
--
--             -- Find the main file window underneath the float
--             for _, win in ipairs(win_ids) do
--                 if vim.api.nvim_win_get_config(win).relative == '' then
--                     -- Jump back to main source code window
--                     vim.api.nvim_set_current_win(win)
--                     -- Execute search/definition lookup based on the word extracted from the doc
--                     vim.cmd('lua vim.lsp.buf.definition()')
--                     -- Alternatively, just use lookups if it's a plain keyword:
--                     vim.fn.search(cword)
--                     break
--                 end
--             end
--         end, { buffer = args.buf, silent = true, desc = 'Follow Definition from Hover' })
--     end,
-- })

-- local orig_convert = vim.lsp.util.convert_input_to_markdown_lines
-- vim.lsp.util.convert_input_to_markdown_lines = function(input, contents)
--     local lines = orig_convert(input, contents)
--
--     for i, line in ipairs(lines) do
--         -- 1. Nuke the Markdown link syntax completely to solve the gap issue.
--         -- Converts "[foo](https://...)" directly into "foo"
--         line = line:gsub('%[([^%]]+)%]%([^%)]+%)', '%1')
--
--         -- 2. Clean up Java/Javadoc specific formatting if we are in a Java file
--         if vim.bo.filetype == 'java' then
--             line = line:gsub('<p>', ''):gsub('</p>', '')
--             line = line:gsub('<br%s*/?>', '')
--             line = line:gsub('@param%s+', '* **Param:** ')
--             line = line:gsub('@return%s+', '* **Returns:** ')
--             line = line:gsub('@throws%s+', '* **Throws:** ')
--             line = line:gsub('%%{@link%s+([^}]+)%%}', '`%1`')
--         end
--
--         lines[i] = line
--     end
--
--     return lines
-- end

-- vim.defer_fn(function()
--     vim.notify('DID IT')
--
--     local orig_convert = vim.lsp.util.convert_input_to_markdown_lines
--     vim.lsp.util.convert_input_to_markdown_lines = function(input, contents)
--         local lines = orig_convert(input, contents)
--
--         for i, line in ipairs(lines) do
--             -- 1. Nuke the Markdown link syntax completely to solve the gap issue.
--             -- Converts "[foo](https://...)" directly into "foo"
--             line = line:gsub('%[([^%]]+)%]%([^%)]+%)', '%1')
--
--             -- 2. Clean up Java/Javadoc specific formatting if we are in a Java file
--             if vim.bo.filetype == 'java' then
--                 line = line:gsub('<p>', ''):gsub('</p>', '')
--                 line = line:gsub('<br%s*/?>', '')
--                 line = line:gsub('@param%s+', '* **Param:** ')
--                 line = line:gsub('@return%s+', '* **Returns:** ')
--                 line = line:gsub('@throws%s+', '* **Throws:** ')
--                 line = line:gsub('%%{@link%s+([^}]+)%%}', '`%1`')
--             end
--
--             lines[i] = line
--         end
--
--         return lines
--     end
-- end, 1000)

-- To handle window-local options like conceallevel and concealcursor,
-- we need to hook into the buffer creation event for the LSP floating window.
vim.api.nvim_create_autocmd('BufWinEnter', {
    group = vim.api.nvim_create_augroup('LspHoverCustom', { clear = true }),
    callback = function(args)
        -- Check if the buffer is an LSP floating doc window (filetype is typically 'markdown')
        if vim.bo[args.buf].filetype == 'markdown' then
            -- Get the current window ID for the buffer that just entered
            local win = vim.fn.bufwinid(args.buf)

            -- Ensure it's a floating window before applying local settings
            if win > -1 and vim.api.nvim_win_get_config(win).relative ~= '' then
                -- Set your preferred conceal options
                vim.wo[win].conceallevel = 2
                vim.wo[win].concealcursor = 'n'
                vim.wo[win].linebreak = true

                if not vim.b[args.buf].padded then
                    vim.b[args.buf].padded = true -- Guard flag against infinite loops
                    local lines = { 'foo' }
                    vim.api.nvim_buf_set_lines(args.buf, 0, -1, false, lines)

                    -- local lines = vim.api.nvim_buf_get_lines(args.buf, 0, -1, false)
                    -- for i, line in ipairs(lines) do
                    --     lines[i] = '  ' .. line .. '  ' -- 2 spaces left, 2 spaces right
                    -- end
                    -- vim.api.nvim_buf_set_lines(args.buf, 0, -1, false, lines)
                    --
                    -- -- 3. Expand the window width by 4 so the text doesn't wrap awkwardly
                    -- local config = vim.api.nvim_win_get_config(win)
                    -- config.width = config.width + 4
                    -- vim.api.nvim_win_set_config(win, config)
                end
            end
        end
    end,
})

-- Helper function to perform your exact regex formatting
local function clean_hover_text(text, ft)
    if type(text) ~= 'string' then
        return text
    end

    -- 1. Nuke Markdown links: "[foo](https://...)" -> "foo"
    text = text:gsub('%[([^%]]+)%]%([^%)]+%)', '%1')

    -- 2. Clean Java/Javadoc specific formatting safely
    if ft == 'java' then
        text = text:gsub('<p>', ''):gsub('</p>', '')
        text = text:gsub('<br%s*/?>', '')
        text = text:gsub('@param%s+', '* **Param:** ')
        text = text:gsub('@return%s+', '* **Returns:** ')
        text = text:gsub('@throws%s+', '* **Throws:** ')
        text = text:gsub('%%{@link%s+([^}]+)%%}', '`%1`')
    end
    return text
end

-- Core interceptor logic
local function intercept_hover_for_client(client)
    -- Prevent double-wrapping the same client
    if not client or client._hover_intercepted then
        return
    end
    client._hover_intercepted = true

    local orig_request = client.request

    client.request = function(method, params, handler, bufnr)
        if method == 'textDocument/hover' then
            -- CRITICAL FIX: If Noice or Neovim passes a `nil` handler, they expect the system
            -- to use the global fallback. We must resolve it exactly like Neovim does natively.
            local resolved_handler = handler or client.handlers[method] or vim.lsp.handlers[method]

            if resolved_handler then
                local orig_handler = resolved_handler

                -- Wrap the resolved handler to mutate the text payload before it reaches Noice
                handler = function(err, result, ctx, config)
                    if result and result.contents then
                        local buf = bufnr or (ctx and ctx.bufnr) or vim.api.nvim_get_current_buf()
                        local ft = vim.api.nvim_get_option_value('filetype', { buf = buf })

                        local contents = result.contents
                        if type(contents) == 'table' and contents.value then
                            contents.value = clean_hover_text(contents.value, ft)
                        elseif type(contents) == 'string' then
                            result.contents = clean_hover_text(contents, ft)
                        elseif type(contents) == 'table' then
                            for i, item in ipairs(contents) do
                                if type(item) == 'string' then
                                    contents[i] = clean_hover_text(item, ft)
                                elseif type(item) == 'table' and item.value then
                                    item.value = clean_hover_text(item.value, ft)
                                end
                            end
                        end
                    end

                    -- Pass the sanitized text down the pipeline
                    return orig_handler(err, result, ctx, config)
                end
            end
        end

        return orig_request(method, params, handler, bufnr)
    end
end

--- 1. Catch clients that are ALREADY attached (Fixes the race condition)
local get_clients = vim.lsp.get_clients or vim.lsp.get_active_clients
for _, client in ipairs(get_clients()) do
    intercept_hover_for_client(client)
end

--- 2. Catch any future clients that attach later
vim.api.nvim_create_autocmd('LspAttach', {
    desc = 'Intercept raw LSP hover responses to format before Noice reads them',
    callback = function(args)
        local client = vim.lsp.get_client_by_id(args.data.client_id)
        intercept_hover_for_client(client)
    end,
})
