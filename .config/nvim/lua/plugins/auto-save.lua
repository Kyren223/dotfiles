return {
    'okuuva/auto-save.nvim',
    cmd = 'ASToggle',
    event = { 'InsertLeave', 'TextChanged' },
    opts = function()
        -- Disable autoformat between automatic saves
        vim.api.nvim_create_autocmd('User', {
            pattern = 'AutoSaveWritePre',
            group = vim.api.nvim_create_augroup('autosave-pre', { clear = true }),
            callback = function(opts)
                local bufnr = opts.data.saved_buffer
                vim.b[bufnr].disable_autoformat = true
            end,
        })

        vim.api.nvim_create_autocmd('User', {
            pattern = 'AutoSaveWritePost',
            group = vim.api.nvim_create_augroup('autosave-post', { clear = true }),
            callback = function(opts)
                local bufnr = opts.data.saved_buffer
                vim.b[bufnr].disable_autoformat = false
            end,
        })

        return {
            -- execution_message = { enabled = false }, removed
            condition = function(buf)
                -- TODO: oil issues might be bcz of autosaving?
                -- Maybe I should exclude Oil ft?
                -- Might be unrelated tho
                -- Oil error is "cannot save, action already in progress"

                -- Save only if the buffer is not a "special buffer"
                return vim.fn.getbufvar(buf, '&buftype') == ''
            end,
        }
    end,
}
