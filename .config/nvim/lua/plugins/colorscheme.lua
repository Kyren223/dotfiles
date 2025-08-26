return {
    {
        -- 'kyren223/carbonight.nvim',
        dir = '~/projects/carbonight.nvim',
        lazy = false,
        priority = 1000,
        config = function()
            local dir = vim.fn.fnamemodify(vim.fn.getcwd(), ':t')
            if dir == 'kyren' then
                vim.g.theme = 'carbonight-tokyo'
            elseif dir == 'grimoire' then
                vim.g.theme = 'tokyonight-storm'
            else
                vim.g.theme = 'carbonight'
            end
            vim.cmd.colorscheme(vim.g.theme)
        end,
    },
    'folke/tokyonight.nvim',
}
