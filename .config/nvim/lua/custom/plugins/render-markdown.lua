return {
    'MeanderingProgrammer/render-markdown.nvim',
    event = { 'BufReadPre', 'BufNewFile' },
    opts = {
        render_modes = true,
        sign = { enabled = false },
        bullet = { icons = { '', '◆' } },
        checkbox = {
            unchecked = { icon = ' ' },
            checked = { icon = ' ' },
        },
    },
}
