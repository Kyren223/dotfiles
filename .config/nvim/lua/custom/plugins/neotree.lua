-- TODO: Consider removing neotree
-- Not really using it due to oil.nvim, but maybe it's still
-- useful to have a tree-structure file explorer?
return {
    'nvim-neo-tree/neo-tree.nvim',
    branch = 'v3.x',
    dependencies = {
        'nvim-lua/plenary.nvim',
        'nvim-tree/nvim-web-devicons',
        'MunifTanjim/nui.nvim',
    },
    cmd = 'Neotree',
    keys = {
        { '<leader>nt', '<cmd>Neotree toggle reveal left<cr>', desc = '[N]eotree [T]oggle' },
    },
    config = function()
        require('neo-tree').setup({
            open_files_do_not_replace_types = { 'terminal', 'Trouble', 'qf', 'edgy' },
            window = {
                mappings = {
                    ['e'] = function()
                        ---@diagnostic disable-next-line: deprecated
                        vim.api.nvim_exec('Neotree focus filesystem left', true)
                    end,
                    ['b'] = function()
                        ---@diagnostic disable-next-line: deprecated
                        vim.api.nvim_exec('Neotree focus buffers left', true)
                    end,
                    ['g'] = function()
                        ---@diagnostic disable-next-line: deprecated
                        vim.api.nvim_exec('Neotree focus git_status left', true)
                    end,
                },
            },
        })
    end,
}
