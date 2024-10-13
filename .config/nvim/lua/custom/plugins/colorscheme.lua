return {
    {
        'folke/tokyonight.nvim',
        lazy = false,
        priority = 1000,
        config = function()
            -- vim.cmd.colorscheme('tokyonight-night')
            -- require('colorschemes.dapui').set()
            -- vim.cmd.colorscheme('carbonight-tokyo')
            vim.cmd.colorscheme('carbonight')
        end,
    },
    { dir = '~/projects/carbonight' },
}
