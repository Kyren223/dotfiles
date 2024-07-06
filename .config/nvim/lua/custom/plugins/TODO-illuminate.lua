return {
    'RRethy/vim-illuminate',
    config = function()
        vim.keymap.set('n', '<leader>it', ':IlluminateToggle<cr>', { desc = '[I]lluminate [Tloggle]' })
    end,
}
