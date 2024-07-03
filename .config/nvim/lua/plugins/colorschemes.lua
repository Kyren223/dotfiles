return {
    { 'rktjmp/lush.nvim',                   lazy = false, priority = 1001 },
    { 'catppuccin/nvim',                    lazy = false, priority = 1000 },
    { 'folke/tokyonight.nvim',              lazy = false, priority = 1000 },
    { 'marko-cerovac/material.nvim',        lazy = false, priority = 1000 },
    { 'rebelot/kanagawa.nvim',              lazy = false, priority = 1000 },
    { 'projekt0n/github-nvim-theme',        lazy = false, priority = 1000 },
    { 'EdenEast/nightfox.nvim',             lazy = false, priority = 1000 },
    { 'rose-pine/neovim',                   lazy = false, priority = 1000 },
    { 'rafi/awesome-vim-colorschemes',      lazy = false, priority = 1000 },
    { 'datsfilipe/min-theme.nvim',          lazy = false, priority = 1000 },
    { 'nechaev/darkstorm.nvim',             lazy = false, priority = 1000 },
    { 'briones-gabriel/darcula-solid.nvim', lazy = false, priority = 1000 },
    {
        'okaihe/okai',
        lazy = false,
        priority = 1000,
        config = function()
            require('okai').setup()
        end,
    },
    {
        'uloco/bluloco.nvim',
        lazy = false,
        priority = 1000,
        dependencies = { 'rktjmp/lush.nvim' },
    },
    { 'doums/darcula', lazy = false, priority = 1000 },
    { 'pineapplegiant/spaceduck', lazy = false, priority = 1000 },
    
}
