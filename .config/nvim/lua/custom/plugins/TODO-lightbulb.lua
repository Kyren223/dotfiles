return {
    'kosayoda/nvim-lightbulb',
    config = function()
        require('nvim-lightbulb').setup({
            autocmd = {
                enabled = true,
                updatetime = 50,
            },
            action_kinds = { 'quickfix', 'refactor.rewrite' },
            sign = { enabled = false },
            virtual_text = { enabled = true },
            float = { enabled = true },
            ignore = {
                ft = { 'neo-tree' },
                actions_without_kind = true,
            },
        })
        local test = ""
    end,
}
