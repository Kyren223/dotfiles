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

local orig_convert = vim.lsp.util.convert_input_to_markdown_lines
vim.lsp.util.convert_input_to_markdown_lines = function(input, contents)
    local lines = orig_convert(input, contents)
    if not lines then
        return lines
    end

    if vim.bo.filetype == 'java' then
        -- vim.notify('boop')
        -- vim.notify('lines before: ' .. vim.inspect(lines))
        -- vim.notify('lines after: ' .. vim.inspect(lines))

        for i, line in ipairs(lines) do
            --  Nuke the Markdown link syntax completely to solve the gap issue.
            -- Converts "[foo](https://...)" directly into "foo"
            line = line:gsub('%[([^%]]+)%]%([^%)]+%)', '%1')

            --  Clean up Java/Javadoc specific formatting if we are in a Java file
            line = line:gsub('<p>', ''):gsub('</p>', '')
            line = line:gsub('<br%s*/?>', '')
            line = line:gsub('@param%s+', '* **Param:** ')
            line = line:gsub('@return%s+', '* **Returns:** ')
            line = line:gsub('@throws%s+', '* **Throws:** ')
            line = line:gsub('%%{@link%s+([^}]+)%%}', '`%1`')

            if line:sub(1, 2) ~= '  ' and line ~= '' and line ~= '---' then
                line = '  ' .. line
            end

            lines[i] = line
        end

        if #lines >= 4 and lines[4] ~= '---' then
            -- vim.notify('yas line' .. #lines .. vim.inspect(lines[4] ~= '---') .. ' "' .. lines[4] .. '"')
            table.insert(lines, 4, '---')
        elseif #lines >= 4 then
            -- vim.notify('nay' .. #lines .. vim.inspect(lines[4] ~= '---') .. ' "' .. lines[4] .. '"')
        end

        table.insert(lines, ' ')
    end

    -- vim.notify('bomp')
    return lines
end

-- vim.defer_fn(function()
--     local orig_convert = vim.lsp.util.convert_input_to_markdown_lines
--     vim.lsp.util.convert_input_to_markdown_lines = function(input, contents)
--         local lines = orig_convert(input, contents)
--
--         -- local en_space = ' ' -- not a regular space
--         local en_space = 'X' -- not a regular space
--         if lines and #lines > 2 then
--             if lines[2]:find(en_space) then
--                 return lines
--             end
--
--             lines[2] = en_space .. lines[2]
--         end
--
--         if vim.bo.filetype == 'java' then
--             vim.notify('boop')
--             -- vim.notify('lines before: ' .. vim.inspect(lines))
--             -- vim.notify('lines after: ' .. vim.inspect(lines))
--
--             for i, line in ipairs(lines) do
--                 --  Nuke the Markdown link syntax completely to solve the gap issue.
--                 -- Converts "[foo](https://...)" directly into "foo"
--                 line = line:gsub('%[([^%]]+)%]%([^%)]+%)', '%1')
--                 vim.notify('beep')
--
--                 --  Clean up Java/Javadoc specific formatting if we are in a Java file
--                 line = line:gsub('<p>', ''):gsub('</p>', '')
--                 line = line:gsub('<br%s*/?>', '')
--                 line = line:gsub('@param%s+', '* **Param:** ')
--                 line = line:gsub('@return%s+', '* **Returns:** ')
--                 line = line:gsub('@throws%s+', '* **Throws:** ')
--                 line = line:gsub('%%{@link%s+([^}]+)%%}', '`%1`')
--
--                 -- if i > 3 then
--                 --     line = '  ' .. line .. '  '
--                 -- end
--
--                 lines[i] = line
--                 vim.notify('bap')
--             end
--
--             -- table.insert(lines, 4, '---')
--         end
--
--         vim.notify('bomp')
--         return lines
--     end
-- end, 2000)

local function is_java_project()
    -- Searches upward from the current buffer for common Java project markers
    local java_root = vim.fs.root(0, { 'pom.xml', 'build.gradle', 'settings.gradle', '.project', 'gradlew' })
    return java_root ~= nil
end

pcall(vim.treesitter.language.register, 'markdown', 'lsphover')
vim.api.nvim_create_autocmd('FileType', {
    group = vim.api.nvim_create_augroup('LspHoverSyntaxLink', { clear = true }),
    pattern = 'lsphover',
    callback = function()
        vim.cmd('runtime! syntax/markdown.vim')
        vim.cmd('runtime! ftplugin/markdown.vim')
    end,
})
vim.api.nvim_create_autocmd('FileType', {
    group = vim.api.nvim_create_augroup('LspHoverCustom', { clear = true }),
    pattern = 'markdown', -- Fires exactly when a buffer becomes 'markdown'
    callback = function(args)
        local win = vim.fn.bufwinid(args.buf)

        -- Ensure it's a valid floating window
        if win > -1 and vim.api.nvim_win_get_config(win).relative ~= '' then
            if is_java_project() then
                -- vim.notify('java')
                vim.wo[win].conceallevel = 3
                vim.wo[win].concealcursor = 'nvic'
            else
                -- vim.notify('not java')
                vim.wo[win].concealcursor = ''
                vim.wo[win].conceallevel = 2
            end
            vim.wo[win].linebreak = true
            vim.bo[args.buf].filetype = 'lsphover'
        end
    end,
})

----------------------------------------------------------------------
-- NOTE(kyren): below is for trying to make it work with noice.nvim --
----------------------------------------------------------------------

-- -- Helper function to perform your exact regex formatting
-- local function clean_hover_text(text, ft)
--     if type(text) ~= 'string' then
--         return text
--     end
--
--     -- 1. Nuke Markdown links: "[foo](https://...)" -> "foo"
--     text = text:gsub('%[([^%]]+)%]%([^%)]+%)', '%1')
--
--     -- 2. Clean Java/Javadoc specific formatting safely
--     if ft == 'java' then
--         text = text:gsub('<p>', ''):gsub('</p>', '')
--         text = text:gsub('<br%s*/?>', '')
--         text = text:gsub('@param%s+', '* **Param:** ')
--         text = text:gsub('@return%s+', '* **Returns:** ')
--         text = text:gsub('@throws%s+', '* **Throws:** ')
--         text = text:gsub('%%{@link%s+([^}]+)%%}', '`%1`')
--     end
--     return text
-- end
--
-- -- Core interceptor logic
-- local function intercept_hover_for_client(client)
--     -- Prevent double-wrapping the same client
--     if not client or client._hover_intercepted then
--         return
--     end
--     client._hover_intercepted = true
--
--     local orig_request = client.request
--
--     client.request = function(method, params, handler, bufnr)
--         if method == 'textDocument/hover' then
--             -- CRITICAL FIX: If Noice or Neovim passes a `nil` handler, they expect the system
--             -- to use the global fallback. We must resolve it exactly like Neovim does natively.
--             local resolved_handler = handler or client.handlers[method] or vim.lsp.handlers[method]
--
--             if resolved_handler then
--                 local orig_handler = resolved_handler
--
--                 -- Wrap the resolved handler to mutate the text payload before it reaches Noice
--                 handler = function(err, result, ctx, config)
--                     if result and result.contents then
--                         local buf = bufnr or (ctx and ctx.bufnr) or vim.api.nvim_get_current_buf()
--                         local ft = vim.api.nvim_get_option_value('filetype', { buf = buf })
--
--                         local contents = result.contents
--                         if type(contents) == 'table' and contents.value then
--                             contents.value = clean_hover_text(contents.value, ft)
--                         elseif type(contents) == 'string' then
--                             result.contents = clean_hover_text(contents, ft)
--                         elseif type(contents) == 'table' then
--                             for i, item in ipairs(contents) do
--                                 if type(item) == 'string' then
--                                     contents[i] = clean_hover_text(item, ft)
--                                 elseif type(item) == 'table' and item.value then
--                                     item.value = clean_hover_text(item.value, ft)
--                                 end
--                             end
--                         end
--                     end
--
--                     -- Pass the sanitized text down the pipeline
--                     return orig_handler(err, result, ctx, config)
--                 end
--             end
--         end
--
--         return orig_request(method, params, handler, bufnr)
--     end
-- end
--
-- --- 1. Catch clients that are ALREADY attached (Fixes the race condition)
-- local get_clients = vim.lsp.get_clients or vim.lsp.get_active_clients
-- for _, client in ipairs(get_clients()) do
--     intercept_hover_for_client(client)
-- end
--
-- --- 2. Catch any future clients that attach later
-- vim.api.nvim_create_autocmd('LspAttach', {
--     desc = 'Intercept raw LSP hover responses to format before Noice reads them',
--     callback = function(args)
--         local client = vim.lsp.get_client_by_id(args.data.client_id)
--         intercept_hover_for_client(client)
--     end,
-- })
