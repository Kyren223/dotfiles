return {
    {
        -- 'kyren223/carbonight.nvim',
        dir = '~/projects/carbonight.nvim',
        lazy = false,
        priority = 1000,
        config = function()
            vim.cmd.colorscheme('carbonight')
        end,
    },
    'folke/tokyonight.nvim',
}
