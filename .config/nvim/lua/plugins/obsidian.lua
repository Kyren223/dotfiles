return {
    'epwalsh/obsidian.nvim',
    version = '*',
    lazy = true,
    ft = 'markdown',
    dependencies = { 'nvim-lua/plenary.nvim', 'hrsh7th/nvim-cmp' },
    opts = {
        workspaces = {
            {
                name = 'personal',
                path = '/mnt/c/users/owner/Projects/ObsidianSync',
            },
        },
    },
}
