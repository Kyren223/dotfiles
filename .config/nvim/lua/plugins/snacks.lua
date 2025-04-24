return {
    'folke/snacks.nvim',
    priority = 1000,
    lazy = false,
    ---@type snacks.Config
    opts = {
        gitbrowse = {},
        image = {},
        indent = {
            scope = { enabled = false },
        },
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
            '<leader>go',
            function()
                Snacks.gitbrowse.open()
            end,
            desc = '[G]it [O]pen',
        },
        {
            '<leader>gc',
            function()
                Snacks.gitbrowse.open({
                    open = function(url)
                        vim.fn.setreg('+', url)
                    end,
                })
            end,
            desc = '[G]it [O]pen',
        },

        {
            '<leader>si',
            function()
                Snacks.image.hover()
            end,
            desc = '[S]how [I]mage',
        },

        {
            '<leader>nd',
            function()
                Snacks.notifier.hide()
            end,
            desc = '[N]otification [D]ismiss All',
        },
        {
            '<leader>nh',
            function()
                Snacks.notifier.show_history()
            end,
            desc = '[N]otification [H]istory',
        },
    },
}
