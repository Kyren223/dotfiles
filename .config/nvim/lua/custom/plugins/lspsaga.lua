return {
    -- TODO: Change <C-k> in rename to smthing else
    -- bcz I am using <C-k> for moving between windows
    -- Maybe <C-c> for abort, <cr> for confirm
    'nvimdev/lspsaga.nvim',
    dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' },
    event = 'LspAttach',
    opts = {
        lightbulb = {
            enable = false,
            sign = false,
            virtual_text = true,
        },
        implement = {
            sign = false,
            virtual_text = true,
        },
        floaterm = {
            height = 0.7,
            width = 0.7,
        },
        outline = {
            layout = 'float',
        },
    },
}
