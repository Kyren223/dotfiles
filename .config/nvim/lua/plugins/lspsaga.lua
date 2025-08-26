return {
    -- TODO: see what I don't need from here
    -- maybe I can just fork the renaming and change
    -- it a bit to my linking?
    -- 'nvimdev/lspsaga.nvim',
    'Kyren223/lspsaga.nvim',
    dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' },
    event = 'LspAttach',
    opts = {
        ui = {
            border = 'rounded',
            foldericon = false,
            title = false,
            kind = nil,
        },
        diagnostic = {
            show_layout = 'float',
            keys = {
                exec_action = 'o',
                quit = 'q',
                toggle_or_jump = '<CR>',
                quit_in_show = { 'q', '<ESC>' },
            },
        },
        code_action = { show_preview = false },
        lightbulb = { enable = false },
        rename = {
            pre_hook = function()
                pcall(function()
                    vim.cmd('IlluminateToggle')
                end)
            end,
            post_hook = function()
                pcall(function()
                    vim.cmd('IlluminateToggle')
                end)
            end,
            keys = {
                quit = '<C-c>',
                exec = '<CR>',
                select = 'x',
            },
        },
        symbol_in_winbar = { enable = false },
    },
}
