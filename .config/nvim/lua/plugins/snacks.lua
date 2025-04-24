return {
    'folke/snacks.nvim',
    priority = 1000,
    lazy = false,
    ---@type snacks.Config
    opts = {
        styles = {
            input = { row = 0.4 },
        },

        bigfile = {},
        gitbrowse = {},
        image = {},
        indent = {
            scope = { enabled = false },
        },
        input = {},
        notifier = {
            ---@type snacks.notifier.style
            style = 'compact',
            filter = function(notif)
                local filtered_messages = { 'No information available', 'No code actions available' }
                for _, msg in ipairs(filtered_messages) do
                    if notif.msg == msg then
                        return false
                    end
                end
                return true
            end,
        },
        picker = {},
        quickfile = {},
        scratch = {
            filekey = { branch = false },
            ft = function()
                return 'markdown'
            end,
            win = {
                style = 'scratch',
                keys = {
                    ['reset'] = {
                        '<M-r>',
                        function(self)
                            local file = vim.api.nvim_buf_get_name(self.buf)
                            Snacks.bufdelete.delete(self.buf)
                            os.remove(file)

                            local name = 'scratch.' .. vim.fn.fnamemodify(file, ':e')
                            Snacks.notify.info('Deleted ' .. name)
                        end,
                        desc = 'Reset',
                        mode = { 'n', 'x' },
                    },
                },
            },
        },
    },
    keys = {
        {
            '<leader>go',
            function()
                Snacks.gitbrowse.open()
            end,
            desc = '[G]it [O]pen',
        },
        {
            '<leader>gc',
            function()
                Snacks.gitbrowse.open({
                    open = function(url)
                        vim.fn.setreg('+', url)
                    end,
                })
            end,
            desc = '[G]it [O]pen',
        },

        {
            '<leader>ri',
            function()
                Snacks.image.hover()
            end,
            desc = '[R]ender [I]mage',
        },

        {
            '<leader>nd',
            function()
                Snacks.notifier.hide()
            end,
            desc = '[N]otification [D]ismiss All',
        },
        {
            '<leader>nh',
            function()
                Snacks.notifier.show_history()
            end,
            desc = '[N]otification [H]istory',
        },

        {
            '<leader>sp',
            function()
                Snacks.picker.pickers({ layout = 'telescope' })
            end,
            desc = '[S]how [P]ickers',
        },
        {
            '<leader>fs',
            function()
                Snacks.picker.files({
                    layout = 'telescope',
                    hidden = true,
                    follow = true,
                })
            end,
            desc = '[F]ile [S]ystem',
        },
        {
            '<leader>lv',
            function()
                Snacks.picker.grep({
                    layout = 'telescope',
                    hidden = true,
                    follow = true,
                })
            end,
            desc = '[L]ive [G]rep',
        },
        {
            'gi',
            function()
                Snacks.picker.lsp_implementations()
            end,
            { desc = '[G]oto [I]mplementations' },
        },
        {
            'gt',
            function()
                Snacks.picker.lsp_type_definitions()
            end,
            { desc = '[G]oto [T]ype Definitions' },
        },
        {
            '<leader>ds',
            function()
                Snacks.picker.lsp_symbols({ layout = 'telescope' })
            end,
            desc = '[D]ocument [S]ymbols',
        },
        {
            '<leader>ps',
            function()
                Snacks.picker.lsp_workspace_symbols({ layout = 'telescope' })
            end,
            desc = '[P]roject [S]ymbols',
        },
        {
            '<leader>di',
            function()
                Snacks.picker.diagnostics({ layout = 'telescope' })
            end,
            desc = '[Di]agnostics',
        },
        {
            '<leader>dl',
            function()
                Snacks.picker.diagnostics_buffer({ layout = 'telescope' })
            end,
            desc = '[D]iagnostics [L]ocal',
        },
        {
            '<leader>fh',
            function()
                Snacks.picker.help({ layout = 'telescope' })
            end,
            desc = '[F]ind [H]elp',
        },
        {
            '<leader>hi',
            function()
                Snacks.picker.highlights({
                    layout = 'telescope',
                    hidden = true,
                    follow = true,
                })
            end,
            desc = '[Hi]light Groups',
        },
        {
            '<leader>si',
            function()
                Snacks.picker.icons({ layout = 'select' })
            end,
            desc = '[S]earch [I]cons',
        },
        {
            '<leader>sk',
            function()
                Snacks.picker.keymaps({ layout = 'dropdown' })
            end,
            desc = '[S]earch [K]eymaps',
        },
        {
            '<leader>th',
            function()
                Snacks.picker.colorschemes({ layout = 'dropdown' })
            end,
            desc = '[T]hemes [P]icker',
        },

        {
            '<leader>rn',
            function()
                Snacks.rename.rename_file()
            end,
            desc = '[R]e[n]ame',
        },

        {
            '<leader>.',
            function()
                Snacks.scratch()
            end,
            desc = 'Toggle Scratch Buffer',
        },
        {
            '<leader>S',
            function()
                Snacks.scratch.select()
            end,
            desc = 'Select Scratch Buffer',
        },
    },
}
