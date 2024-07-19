return {
    {
        'okuuva/auto-save.nvim',
        cmd = 'ASToggle', -- optional for lazy loading on command
        event = { 'InsertLeave', 'TextChanged' },
        opts = {
            execution_message = { enabled = false },
            condition = function(buf)
                local excluded_ft = {}

                if vim.fn.getbufvar(buf, '&buftype') ~= '' then
                    return false
                end

                local filetype = vim.fn.getbufvar(buf, '&filetype')
                for _, ft in ipairs(excluded_ft) do
                    if ft == filetype then
                        return false
                    end
                end

                return true
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
        'AckslD/nvim-neoclip.lua',
        dependencies = {
            { 'kkharji/sqlite.lua',           module = 'sqlite' },
            { 'nvim-telescope/telescope.nvim' },
        },
        config = function()
            require('neoclip').setup({
                enable_persistent_history = true,
                keys = {
                    telescope = {
                        i = {
                            paste = '<C-y>',
                            paste_behind = '<C-S-Y>',
                        },
                    },
                },
            })
            -- NOTE: Using `plus` to set the plus register to the selected value
            vim.keymap.set('n', '<leader>nc', '<cmd>Telescope neoclip plus<cr>', { desc = '[N]eo[c]lip History' })
        end,
    },
    {
        'mbbill/undotree',
        config = function()
            vim.keymap.set('n', '<leader>ut', vim.cmd.UndotreeToggle)
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
        config = function()
            vim.keymap.set('n', 'Q', function()
                if vim.bo.modified then
                    vim.cmd.write()
                end
                require('mini.bufremove').delete(0)
            end, { desc = '[Q]uit Buffer' })
        end,
    },
}
