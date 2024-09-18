return {
    'MeanderingProgrammer/render-markdown.nvim',
    event = { 'BufReadPre', 'BufNewFile' },
    opts = {
        render_modes = true,
        sign = { enabled = false },
        bullet = { icons = { '', '◆' } },
        checkbox = {
            -- unchecked = { icon = '󰄱 ' },
            -- checked = { icon = '󰄲 ' },
            unchecked = { icon = '󰄰 ' },
            checked = { icon = '󰄳 ' },
            custom = { todo = { rendered = '◯ ' } },
        },
    },
    dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' },
}
