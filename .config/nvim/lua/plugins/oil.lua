return {
    'stevearc/oil.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    opts = {},
    config = function ()
        require("oil").setup()
        vim.keymap.set('n', '<leader>of', ':Oil --float<cr>', { desc = '[O]il [F]ilesystem' })
    end
}
