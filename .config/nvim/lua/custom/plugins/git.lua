local quit_keymap = { 'n', 'q', '<cmd>DiffviewClose<cr>', { desc = 'Quit the diffview' } }
local diffview_opts = {
    enhanced_diff_hl = true,
    default = { winbar_info = true },
    keymaps = {
        view = { quit_keymap },
        file_panel = { quit_keymap },
        file_history_panel = { quit_keymap },
    },
}

local neogit_opts = {
    mappings = {
        commit_editor = {
            ['<C-y>'] = 'Submit',
            ['<C-n>'] = 'Abort',
        },
        commit_editor_I = {
            ['<C-y>'] = 'Submit',
            ['<C-n>'] = 'Abort',
        },
        popup = {
            ['p'] = 'PushPopup',
            ['P'] = 'PullPopup',
        },
    },
}

local function octo_config()
    require('octo').setup({ suppress_missing_scope = { projects_v2 = true } })

    vim.treesitter.language.register('markdown', 'octo')
    vim.api.nvim_create_autocmd('FileType', {
        pattern = 'octo',
        callback = function()
            -- Autocomplete for @ (user mention) and # (issue)
            vim.keymap.set('i', '@', '@<C-x><C-o>', { silent = true, buffer = true })
            vim.keymap.set('i', '#', '#<C-x><C-o>', { silent = true, buffer = true })
        end,
    })
end

-- Helpers
local function stage_visual_chunk()
    require('gitsigns').stage_hunk({ vim.fn.line('.'), vim.fn.line('v') })
end
local function reset_visual_chunk()
    require('gitsigns').reset_hunk({ vim.fn.line('.'), vim.fn.line('v') })
end

-- GitHub Keymaps
local search_open_issues_by_me = '<cmd>Octo search is:issue is:open author:@me<cr>'
vim.keymap.set('n', '<leader>gi', '<cmd>Octo issue search<cr>', { desc = '[G]ithub [I]ssues (local)' })
vim.keymap.set('n', '<leader>pr', '<cmd>Octo pr search<cr>', { desc = 'Github [PR]s (local)' })
vim.keymap.set('n', '<leader>gI', search_open_issues_by_me, { desc = '[G]ithub [I]ssues (global)' })
vim.keymap.set('n', '<leader>pR', '<cmd>Octo search is:pr author:@me<cr>', { desc = 'Github [PR]s (global)' })

-- Git keymaps
vim.keymap.set('n', '<leader>gB', '<cmd>Gitsigns toggle_current_line_blame<cr>', { desc = '[G]it [B]lame Line' })
vim.keymap.set('n', '<leader>gD', '<cmd>Gitsigns toggle_deleted<cr>', { desc = '[G]it [D]eleted' })
vim.keymap.set('n', '<leader>gb', '<cmd>Neogit branch<cr>', { desc = '[G]it [B]ranch' })
vim.keymap.set('n', '<leader>gd', '<cmd>DiffviewOpen<cr>', { desc = '[G]it [D]iff' })
vim.keymap.set('n', '<leader>gl', '<cmd>DiffviewFileHistory<cr>', { desc = '[G]it [L]og (diffview)' })
vim.keymap.set('n', '<leader>gs', '<cmd>Neogit<cr>', { desc = '[G]it [S]tatus' })
vim.keymap.set('n', '<leader>gL', '<cmd>Neogit log<cr>', { desc = '[G]it [L]og (neogit)' })
vim.keymap.set('n', '<leader>gc', '<cmd>Neogit commit<cr>', { desc = '[G]it [C]ommit' })
vim.keymap.set('n', '<leader>gp', '<cmd>Neogit push<cr>', { desc = '[G]it [P]ush' })
vim.keymap.set('n', '<leader>gP', '<cmd>Neogit pull<cr>', { desc = '[G]it [P]ull' })
vim.keymap.set('n', '<leader>gr', '<cmd>Neogit rebase<cr>', { desc = '[G]it [R]ebase' })
vim.keymap.set('n', '<leader>gm', '<cmd>Neogit merge<cr>', { desc = '[G]it [M]erge' })

-- Hunk Keymaps
vim.keymap.set('n', '<leader>hp', '<cmd>Gitsigns preview_hunk<cr>', { desc = '[H]unk [P]review' })
vim.keymap.set('n', '<leader>hs', '<cmd>Gitsigns stage_hunk<cr>', { desc = '[H]unk [S]tage' })
vim.keymap.set('n', '<leader>hr', '<cmd>Gitsigns reset_hunk<cr>', { desc = '[H]unk [R]eset' })
vim.keymap.set('v', '<leader>hs', stage_visual_chunk, { desc = '[H]unk [S]tage' })
vim.keymap.set('v', '<leader>hr', reset_visual_chunk, { desc = '[H]unk [S]tage' })
vim.keymap.set('n', '<leader>hS', '<cmd>Gitsigns stage_buffer<cr>', { desc = '[S]tage Buffer' })
vim.keymap.set('n', '<leader>hR', '<cmd>Gitsigns reset_buffer<cr>', { desc = '[R]eset Buffer' })
vim.keymap.set('n', '<leader>hu', '<cmd>Gitsigns undo_stage_hunk<cr>', { desc = '[H]unk [U]ndo' })

return {
    {
        'NeogitOrg/neogit',
        opts = neogit_opts,
        cmd = 'Neogit',
        commit = 'c31ef8b5fdb3ea4beaf6ab66e07327b810e32c9f',
    },
    { 'pwntester/octo.nvim', config = octo_config, cmd = 'Octo' },
    { 'lewis6991/gitsigns.nvim', config = true, cmd = 'Gitsigns', event = 'VeryLazy' },
    {
        'sindrets/diffview.nvim',
        opts = diffview_opts,
        cmd = { 'DiffviewOpen', 'DiffviewClose', 'DiffviewFileHistory' },
    },
}
