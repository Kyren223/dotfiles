return {
    'lukas-reineke/indent-blankline.nvim',
    main = 'ibl',
    event = 'VeryLazy',
    opts = {
        indent = { tab_char = '▎' },
        scope = {
            show_start = false,
            show_end = false,
        },
    },
}
