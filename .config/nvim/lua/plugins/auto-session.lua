return {
    'rmagatti/auto-session',
    lazy = false,
    opts = {
        suppressed_dirs = { '~/', '/' },
        session_lens = { load_on_setup = false },
        bypass_save_filetypes = { 'snacks_dashboard', 'terminal' },
        close_filetypes_on_save = { 'checkhealth', 'build_terminal' },
        pre_save_cmds = {
            function()
                for _, buf in ipairs(vim.api.nvim_list_bufs()) do
                    if vim.bo[buf].buftype == 'terminal' then
                        vim.api.nvim_buf_delete(buf, { force = true })
                    end
                    if vim.bo[buf].filetype == 'build_terminal' then
                        vim.api.nvim_buf_delete(buf, { force = true })
                    end
                end
            end,
        },
    },
}
