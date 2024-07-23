return {
    {
        'uga-rosa/ccc.nvim',
        opts = { highlighter = { auto_enable = true } },
        event = "VeryLazy",
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
                session_lens = { load_on_setup = false },
            })

            local session_lens_setup_done = false
            local function search_session()
                if not session_lens_setup_done then
                    require('auto-session').setup_session_lens()
                    session_lens_setup_done = true
                end
                require('auto-session.session-lens').search_session()
            end
            vim.keymap.set('n', '<C-s>', search_session, { desc = '[S]ession Manager' })
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
        version = false,
        keys = {
            {
                'Q',
                function()
                    if vim.bo.modified then
                        vim.cmd.write()
                    end
                    require('mini.bufremove').delete(0)
                end,
                desc = '[Q]uit Buffer',
            },
        },
    },
    {
        'kylechui/nvim-surround',
        version = '*',
        keys = {
            { 'yS',  '<Plug>(nvim-surround-normal)' },
            { 'ySS', '<Plug>(nvim-surround-normal-cur)' },
            { 'S',   '<Plug>(nvim-surround-visual)',    mode = 'v' },
            { 'cS',  '<Plug>(nvim-surround-change)' },
            { 'dS',  '<Plug>(nvim-surround-delete)' },
            { '(',   '<Plug>(nvim-surround-visual)(',   mode = 'v' },
            { '{',   '<Plug>(nvim-surround-visual){',   mode = 'v' },
            { '[',   '<Plug>(nvim-surround-visual)[',   mode = 'v' },
            { '`',   '<Plug>(nvim-surround-visual)`',   mode = 'v' },
            { '"',   '<Plug>(nvim-surround-visual)"',   mode = 'v' },
            { "'",   "<Plug>(nvim-surround-visual)'",   mode = 'v' },
        },
        opts = {
            keymaps = {
                insert = false,
                insert_line = false,
                normal_line = false,
                normal_cur_line = false,
                visual_line = false,
                normal = false,
                normal_cur = false,
                visual = false,
                delete = false,
                change = false,
                change_line = false,
            },
        },
    },
    {
        -- TODO: Make sure it uses a diff color
        -- the color rn is too similar to visual mode
        'RRethy/vim-illuminate',
        event = 'LspAttach',
        keys = { { '<leader>it', '<cmd>IlluminateToggle<cr>', desc = '[I]lluminate [Tloggle]' } },
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
    {
        'christoomey/vim-tmux-navigator',
        keys = {
            { '<C-h>', '<cmd>TmuxNavigateLeft<cr>' },
            { '<C-j>', '<cmd>TmuxNavigateDown<cr>' },
            { '<C-k>', '<cmd>TmuxNavigateUp<cr>' },
            { '<C-l>', '<cmd>TmuxNavigateRight<cr>' },
        },
    },
    {
        'ggandor/leap.nvim',
        dependencies = { 'tpope/vim-repeat' },
        keys = {
            { 's', '<Plug>(leap)',            mode = { 'n', 'x', 'o' } },
            { 'S', '<Plug>(leap-from-window)' },
            {
                'gs',
                function()
                    require('leap.remote').action()
                end,
            },
        },
        config = function()
            require('leap').opts.equivalence_classes = { ' \t\r\n', '([{', ')]}', '\'"`' }
            vim.api.nvim_set_hl(0, 'LeapBackdrop', { fg = '#777777' })
        end,
    },
    { 'windwp/nvim-autopairs', event = 'InsertEnter', config = true },
    {
        -- 'numToStr/Comment.nvim',
        'os-mey/Comment.nvim',
        branch = 'fix-inline-visual-linewise-comment',
        keys = {
            { 'gc',    mode = { 'n', 'v' } },
            { 'gb',    mode = { 'n', 'v' } },
            { '<C-_>', mode = { 'n', 'v' } },
            { 'gcc',   mode = 'n' },
            { 'gcb',   mode = 'n' },
        },
        config = function()
            require('Comment').setup()
            local api = require('Comment.api')
            local esc = vim.api.nvim_replace_termcodes('<ESC>', true, false, true)
            local toggle_linewise_selection = function()
                vim.api.nvim_feedkeys(esc, 'nx', false)
                api.toggle.linewise(vim.fn.visualmode())
            end

            -- <C-_> means Ctrl slash, `_` is a `/`
            vim.keymap.set('n', '<C-_>', api.toggle.linewise.current, { noremap = true, silent = true })
            vim.keymap.set('v', '<C-_>', toggle_linewise_selection, { noremap = true, silent = true })
        end,
    },
    {
        'j-morano/buffer_manager.nvim',
        dependencies = { 'nvim-lua/plenary.nvim' },
        keys = {
            {
                '<leader>e',
                function()
                    require('buffer_manager.ui').toggle_quick_menu()
                end,
            },
        },
    },
}
