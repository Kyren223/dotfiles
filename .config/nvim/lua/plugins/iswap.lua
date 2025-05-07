return {
    'mizlan/iswap.nvim',
    event = 'VeryLazy',
    keys = {
        { 'H', '<cmd>IMoveNodeWithLeft<cr>', silent = true },
        { 'L', '<cmd>IMoveNodeWithRight<cr>', silent = true },
    },
    opts = {
        -- Post-operation flashing highlight style,
        -- either 'simultaneous' or 'sequential', or false to disable
        -- default 'sequential'
        flash_style = false,

        -- Move cursor to the other element in ISwap*With commands
        move_cursor = true,
    },
}
