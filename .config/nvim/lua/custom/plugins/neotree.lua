return {
    'nvim-neo-tree/neo-tree.nvim',
    branch = 'v3.x',
    dependencies = {
        'nvim-lua/plenary.nvim',
        'nvim-tree/nvim-web-devicons',
        'MunifTanjim/nui.nvim',
    },
    opts = {
        open_files_do_not_replace_types = { 'terminal', 'Trouble', 'qf', 'edgy' },
    },
    config = function()
        vim.keymap.set('n', '<leader>nt', '<cmd>Neotree toggle reveal left<cr>', { desc = '[N]eotree [T]oggle' })
    end,
}
