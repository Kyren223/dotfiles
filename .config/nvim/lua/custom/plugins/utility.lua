return {
    {
        'uga-rosa/ccc.nvim',
        opts = { highlighter = { auto_enable = true } },
        keys = {
            { '<leader>cp', '<cmd>CccPick<cr>',              desc = '[C]olor [P]icker' },
            { '<leader>ct', '<cmd>CccHighlighterToggle<cr>', desc = '[C]olor [T]oggle' },
        },
    },
    {
        'okuuva/auto-save.nvim',
        cmd = 'ASToggle',
        event = { 'InsertLeave', 'TextChanged' },
        opts = {
            execution_message = { enabled = false },
            condition = function(buf)
                return vim.fn.getbufvar(buf, '&buftype') == ''
            end,
        },
    },
    {
        'rmagatti/auto-session',
        config = function()
            vim.opt.sessionoptions = 'blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions'
            require('auto-session').setup({
                log_level = 'error',
                auto_session_suppress_dirs = { '~/', '/' },
            })
            local session = require('auto-session.session-lens')
            vim.keymap.set('n', '<C-s>', session.search_session, { desc = '[S]ession Manager' })
        end,
    },
    { 'wakatime/vim-wakatime',  lazy = false },
    {
        'mbbill/undotree',
        keys = { { '<leader>ut', vim.cmd.UndotreeToggle } },
        config = function()
            vim.g.undotree_DiffAutoOpen = false
            vim.g.undotree_DiffpanelHeight = 0
            vim.g.undotree_SetFocusWhenToggle = false
            vim.g.undotree_HelpLine = false
            vim.g.undotree_TreeNodeShape = ''
            vim.g.undotree_TreeVertShape = '│'
            vim.g.undotree_TreeSplitShape = '─┘'
            vim.g.undotree_TreeReturnShape = '─┐'
        end,
    },
    -- NOTE: No keybindings, use `:Spectre` or `:Spectre <file>`
    -- Spectre has no undo, so it should be rarely used, which is why no keybindings are defined
    { 'nvim-pack/nvim-spectre', cmd = 'Spectre', config = true },
    {
        'echasnovski/mini.nvim',
        lazy = true,
        version = false,
        init = function()
            local function quit_buffer()
                if vim.bo.modified then
                    vim.cmd.write()
                end
                require('mini.bufremove').delete(0)
            end
            vim.keymap.set('n', 'Q', quit_buffer, { desc = '[Q]uit Buffer' })
        end,
    },
    {
        'kylechui/nvim-surround',
        version = '*',
        config = true,
        keys = {
            { '(', '<Plug>(nvim-surround-visual)(', mode = 'v' },
            { ')', '<Plug>(nvim-surround-visual))', mode = 'v' },
            { '{', '<Plug>(nvim-surround-visual){', mode = 'v' },
            { '}', '<Plug>(nvim-surround-visual)}', mode = 'v' },
            { '[', '<Plug>(nvim-surround-visual)[', mode = 'v' },
            { '`', '<Plug>(nvim-surround-visual)`', mode = 'v' },
            'cs',
            'ds',
            'ys',
        },
    },
    {
        -- TODO: Make sure it uses a diff color
        -- the color rn is too similar to visual mode
        'RRethy/vim-illuminate',
        config = function()
            vim.keymap.set('n', '<leader>it', '<cmd>IlluminateToggle<cr>', { desc = '[I]lluminate [Tloggle]' })
        end,
    },
    {
        'lukas-reineke/indent-blankline.nvim',
        main = 'ibl',
        event = 'BufEnter',
        opts = {
            scope = {
                show_start = false,
                show_end = false,
            },
        },
    },
}
