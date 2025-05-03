return {
    'pwntester/octo.nvim',
    cmd = 'Octo',
    event = { { event = 'BufReadCmd', pattern = 'octo://*' } },
    dependencies = {
        'nvim-lua/plenary.nvim',
        'folke/snacks.nvim',
        'nvim-tree/nvim-web-devicons',
    },
    keys = {
        { '<leader>gi', '<cmd>Octo issue search<cr>', desc = '[G]ithub [I]ssues (local)' },
        { '<leader>pr', '<cmd>Octo pr search<cr>', desc = 'Github [PR]s (local)' },
        { '<leader>gI', '<cmd>Octo search is:issue is:open author:@me<cr>', desc = '[G]ithub [I]ssues (global)' },
        { '<leader>pR', '<cmd>Octo search is:pr author:@me<cr>', desc = 'Github [PR]s (global)' },

        { '<localleader>a', '', desc = '+assignee (Octo)', ft = 'octo' },
        { '<localleader>c', '', desc = '+comment/code (Octo)', ft = 'octo' },
        { '<localleader>l', '', desc = '+label (Octo)', ft = 'octo' },
        { '<localleader>i', '', desc = '+issue (Octo)', ft = 'octo' },
        { '<localleader>r', '', desc = '+react (Octo)', ft = 'octo' },
        { '<localleader>p', '', desc = '+pr (Octo)', ft = 'octo' },
        { '<localleader>pr', '', desc = '+rebase (Octo)', ft = 'octo' },
        { '<localleader>ps', '', desc = '+squash (Octo)', ft = 'octo' },
        { '<localleader>v', '', desc = '+review (Octo)', ft = 'octo' },
        { '<localleader>g', '', desc = '+goto_issue (Octo)', ft = 'octo' },
        { '@', '', mode = 'i', ft = 'octo', silent = true },
        { '#', '', mode = 'i', ft = 'octo', silent = true },
    },
    opts = function()
        -- Keep some empty windows in sessions
        vim.api.nvim_create_autocmd('ExitPre', {
            group = vim.api.nvim_create_augroup('octo_exit_pre', { clear = true }),
            callback = function(_)
                local keep = { 'octo' }
                for _, win in ipairs(vim.api.nvim_list_wins()) do
                    local buf = vim.api.nvim_win_get_buf(win)
                    if vim.tbl_contains(keep, vim.bo[buf].filetype) then
                        vim.bo[buf].buftype = '' -- set buftype to empty to keep the window
                    end
                end
            end,
        })

        return {
            enable_builtin = true,
            -- default_to_projects_v2 = true,
            default_merge_method = 'squash',
            picker = 'snacks',
        }
    end,
}
