return {
    'MeanderingProgrammer/render-markdown.nvim',
    event = { 'BufReadPre', 'BufNewFile' },
    keys = {
        -- { '<leader>mt', '<<cmd>RenderMarkdown toggle<cr>'}
    },
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
