return {
    'NeogitOrg/neogit',
    dependencies = {
        'nvim-lua/plenary.nvim',
        'nvim-telescope/telescope.nvim',
        'sindrets/diffview.nvim',
        'tpope/vim-fugitive',
        'lewis6991/gitsigns.nvim',
        'pwntester/octo.nvim',
    },
    config = function()
        require('custom.git')
    end,
}
