return {
    'stevearc/overseer.nvim',
    opts = {},
    config = function()
        require('overseer').setup({
            templates = { 'builtin', 'user.c_build_make' },
        })
        vim.keymap.set('n', '<leader>r', ':OverseerRun<cr>', { desc = '[R]un Task' })
    end,
}
