return {
    -- FIX: Only cleans 1 buffer at a time
    -- which means if u have more than max buffers, it'll never go below MAX buffers
    'ChuufMaster/buffer-vacuum',
    event = 'VeryLazy',
    opts = {
        max_buffers = 6,
    },
}
