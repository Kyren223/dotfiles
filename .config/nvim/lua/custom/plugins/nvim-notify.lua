return {
    'rcarriga/nvim-notify',
    event = 'VeryLazy',
    keys = {
        {
            '<leader>nd',
            function()
                require('notify').dismiss({ silent = true, pending = true })
            end,
            desc = '[N]otify [D]ismiss All',
        },
    },
    opts = function()
        -- Filter messages
        local filtered_messages = { 'No information available', 'No code actions available' }
        ---@diagnostic disable-next-line: duplicate-set-field
        vim.notify = function(message, level, opts)
            opts = opts or {}
            for _, msg in ipairs(filtered_messages) do
                if message == msg then
                    return
                end
            end
            return require('notify')(message, level, opts)
        end
        return {
            fps = 60,
            render = 'default',
            timeout = 500,
            topDown = true,
        }
    end,
}
