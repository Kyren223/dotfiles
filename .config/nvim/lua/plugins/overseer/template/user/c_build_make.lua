return {
    name = 'C build (make)',
    builder = function()
        -- Full path to current file (see :help expand())
        local file = vim.fn.expand('%:p')
        file = file:sub(1, -3)
        return {
            name = 'Make C file',
            cmd = { 'make' },
            args = { file },
            components = { { 'on_output_quickfix', open = true }, 'default' },
        }
    end,
    condition = {
        filetype = { 'c' },
    },
}
