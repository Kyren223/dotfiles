return {
    {
        'folke/tokyonight.nvim',
        lazy = false,
        priority = 1000,
        config = function()
            vim.cmd.colorscheme('tokyonight-night')
            require('colorschemes.dapui').set()
        end,
    },
    'rktjmp/lush.nvim',
    'catppuccin/nvim',
    'marko-cerovac/material.nvim',
    'rebelot/kanagawa.nvim',
    'projekt0n/github-nvim-theme',
    'EdenEast/nightfox.nvim',
    'rose-pine/neovim',
    'rafi/awesome-vim-colorschemes',
    'datsfilipe/min-theme.nvim',
    'nechaev/darkstorm.nvim',
    'briones-gabriel/darcula-solid.nvim',
    'okaihe/okai',
    'uloco/bluloco.nvim',
    'doums/darcula',
    'pineapplegiant/spaceduck',
}
