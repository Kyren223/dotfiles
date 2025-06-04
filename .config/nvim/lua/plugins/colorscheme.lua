return {
    {
        -- 'kyren223/carbonight.nvim',
        dir = '~/projects/carbonight.nvim',
        lazy = false,
        priority = 1000,
        config = function()
            local dir = vim.fn.fnamemodify(vim.fn.getcwd(), ':t')
            if dir == 'kyren' then
                vim.cmd.colorscheme('carbonight-tokyo')
            elseif dir == 'grimoire' then
                vim.cmd.colorscheme('tokyonight-storm')
            else
                vim.cmd.colorscheme('carbonight')
            end
        end,
    },
    'folke/tokyonight.nvim',
}
