return {
    'okuuva/auto-save.nvim',
    cmd = 'ASToggle',
    event = { 'InsertLeave', 'TextChanged' },
    opts = {
        execution_message = { enabled = false },
        condition = function(buf)
            return vim.fn.getbufvar(buf, '&buftype') == ''
        end,
    },
}
