return {
    'folke/snacks.nvim',
    priority = 1000,
    lazy = false,
    ---@type snacks.Config
    opts = {
        image = {},
        ---@class snacks.notifier.Config
        notifier = {
            ---@type snacks.notifier.style
            style = 'compact',
            filter = function(notif)
                local filtered_messages = { 'No information available', 'No code actions available' }
                for _, msg in ipairs(filtered_messages) do
                    if notif.msg == msg then
                        return false
                    end
                end
                return true
            end,
        },
    },
    keys = {
        {
            '<leader>si',
            function()
                Snacks.image.hover()
            end,
        },
        {
            '<leader>nd',
            function()
                Snacks.notifier.hide()
            end,
            desc = '[N]otifications [D]ismiss All',
        },
        {
            '<leader>nh',
            function()
                Snacks.notifier.show_history()
            end,
            desc = '[N]otifications [D]ismiss All',
        },
    },
}
