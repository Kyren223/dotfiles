return {
    'sindrets/diffview.nvim',
    cmd = { 'DiffviewOpen', 'DiffviewClose', 'DiffviewFileHistory' },
    keys = {
        { '<leader>gD', '<cmd>DiffviewOpen<cr>' },
        { '<leader>gl', '<cmd>DiffviewFileHistory<cr>' },
    },
    opts = function()
        local quit_keymap = { 'n', 'q', '<cmd>DiffviewClose<cr>', { desc = 'Quit the diffview' } }
        return {
            enhanced_diff_hl = true,
            default = { winbar_info = true },
            keymaps = {
                view = { quit_keymap },
                file_panel = { quit_keymap },
                file_history_panel = { quit_keymap },
            },
        }
    end,
}
