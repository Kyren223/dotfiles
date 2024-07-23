local lualine = require('lualine')
local lsp_progress = require('lsp-progress')

local progress_filled = '█'
local progress_empty = '░'
local function progress_bar(percentage, width)
    -- Ensure i is an integer between 0 and width (inclusive)
    local i = math.max(0, math.min(math.floor(width * percentage), width))
    return string.rep(progress_filled, i) .. string.rep(progress_empty, width - i)
end

local progress_bar_width = 10
lsp_progress.setup({
    format = function(client_messages) -- global
        local sign = ' LSP'
        if #client_messages > 0 then
            return sign .. ' ' .. table.concat(client_messages, ' ')
        end
        if #require('lsp-progress.api').lsp_clients() > 0 then
            return sign
        end
        return ''
    end,
    client_format = function(_, _, series_messages) -- per lsp
        return #series_messages > 0 and table.concat(series_messages, ', ') or nil
    end,
    series_format = function(title, message, percentage, done) -- per progress
        local builder = {}
        local has_title = false
        local has_message = false
        if type(title) == 'string' and string.len(title) > 0 then
            table.insert(builder, title .. ':')
            has_title = true
        end
        if percentage then
            table.insert(builder, string.format('%.0f%%', percentage))
            table.insert(builder, 1, progress_bar(percentage / 100, progress_bar_width))
        end
        if type(message) == 'string' and string.len(message) > 0 then
            table.insert(builder, string.format('(%s)', message))
            has_message = true
        end
        if done and (has_title or has_message) then
            table.insert(builder, ' ')
        end
        return table.concat(builder, ' ')
    end,
})

lualine.setup({
    options = {
        globalstatus = true,
        theme = 'auto',
    },
    sections = {
        lualine_a = { { 'mode', icon = '' } },
        lualine_b = {
            require('auto-session.lib').current_session_name,
            { 'branch', icon = '' },
            {
                'diagnostics',
                symbols = {
                    error = '󰅙 ',
                    warn = '󰀦 ',
                    info = '󰋼 ',
                    hint = '󰌵 ',
                },
            },
        },
        lualine_c = {
            function()
                return lsp_progress.progress()
            end,
        },
        lualine_x = {
            'searchcount',
            'encoding',
            'fileformat',
            'filetype',
        },
        lualine_y = { 'progress' },
        lualine_z = { 'location' },
    },
    extensions = { 'oil', 'trouble' },
})

-- Refresh lualine when lsp progress is updated
vim.api.nvim_create_autocmd('User', {
    group = vim.api.nvim_create_augroup('lualine_augroup', { clear = true }),
    pattern = 'LspProgressStatusUpdated',
    callback = require('lualine').refresh,
})
