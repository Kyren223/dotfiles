local set = vim.keymap.set
local gitsigns = require('gitsigns')
gitsigns.setup()
require('neogit').setup({
    mappings = {
        commit_editor = {
            ['<C-y>'] = 'Submit',
            ['<C-n>'] = 'Abort',
        },
        commit_editor_I = {
            ['<C-y>'] = 'Submit',
            ['<C-n>'] = 'Abort',
        },
    },
})
require('octo').setup()
require('diffview').setup({
    enhanced_diff_hl = true,
    default = { winbar_info = true },
    keymaps = {
        view = {
            { 'n', 'q', '<cmd>DiffviewClose<cr>', { desc = 'Quit the diffview' } },
        },
        file_panel = {
            { 'n', 'q', '<cmd>DiffviewClose<cr>', { desc = 'Quit the diffview' } },
        },
        file_history_panel = {
            { 'n', 'q', '<cmd>DiffviewClose<cr>', { desc = 'Quit the diffview' } },
        },
    },
})

vim.treesitter.language.register('markdown', 'octo')
-- Autocomplete for @ (user mention) and # (issue)
-- Works in GitHub issues/PRs (for octo.nvim)
vim.api.nvim_create_autocmd('FileType', {
    pattern = 'octo',
    callback = function()
        vim.keymap.set('i', '@', '@<C-x><C-o>', { silent = true, buffer = true })
        vim.keymap.set('i', '#', '#<C-x><C-o>', { silent = true, buffer = true })
    end,
})

-- GitHub keymaps
set('n', '<leader>gi', '<cmd>Octo issue search<cr>', { desc = '[G]ithub [I]ssues (local)' })
set('n', '<leader>pr', '<cmd>Octo pr search<cr>', { desc = 'Github [PR]s (local)' })
set('n', '<leader>gI', '<cmd>Octo search is:issue is:open author:@me<cr>', { desc = '[G]ithub [I]ssues (global)' })
set('n', '<leader>pR', '<cmd>Octo search is:pr author:@me<cr>', { desc = 'Github [PR]s (global)' })

-- Git keymaps
set('n', '<leader>gB', gitsigns.toggle_current_line_blame, { desc = '[G]it [B]lame Line' })
set('n', '<leader>gD', gitsigns.toggle_deleted, { desc = '[G]it [D]eleted' })
set('n', '<leader>gb', '<cmd>Neogit branch<cr>', { desc = '[G]it [B]ranch' })
set('n', '<leader>gd', '<cmd>DiffviewOpen<cr>', { desc = '[G]it [D]iff' })
set('n', '<leader>gl', '<cmd>DiffviewFileHistory<cr>', { desc = '[G]it [L]og (diffview)' })
set('n', '<leader>gL', '<cmd>Neogit log<cr>', { desc = '[G]it [L]og (neogit)' })
set('n', '<leader>gs', '<cmd>Neogit<cr>', { desc = '[G]it [S]tatus' })
set('n', '<leader>gc', '<cmd>Neogit commit<cr>', { desc = '[G]it [C]ommit' })
set('n', '<leader>gp', '<cmd>Neogit push<cr>', { desc = '[G]it [P]ush' })
set('n', '<leader>gP', '<cmd>Neogit pull<cr>', { desc = '[G]it [P]ull' })
-- NOTE: Waiting to actually have my next merge conflict and
-- see how diffview handles and then deciding if I want to use
-- neogit or diffview for merge (prob diffview), same with rebase
-- althoug I don't think I will use rebase anytime soon
set('n', '<leader>gr', 'TODO:', { desc = '[G]it [R]ebase' })
set('n', '<leader>gm', 'TODO:', { desc = '[G]it [M]erge' })

-- Hunk Keymaps
local function stage_visual_chunk()
    gitsigns.stage_hunk({ vim.fn.line('.'), vim.fn.line('v') })
end
local function reset_visual_chunk()
    gitsigns.reset_hunk({ vim.fn.line('.'), vim.fn.line('v') })
end
set('n', '<leader>hp', gitsigns.preview_hunk, { desc = '[H]unk [P]review' })
set('n', '<leader>hs', gitsigns.stage_hunk, { desc = '[H]unk [S]tage' })
set('n', '<leader>hr', gitsigns.reset_hunk, { desc = '[H]unk [R]eset' })
set('v', '<leader>hs', stage_visual_chunk, { desc = '[H]unk [S]tage' })
set('v', '<leader>hr', reset_visual_chunk, { desc = '[H]unk [S]tage' })
set('n', '<leader>hS', gitsigns.stage_buffer, { desc = '[S]tage Buffer' })
set('n', '<leader>hR', gitsigns.reset_buffer, { desc = '[R]eset Buffer' })
set('n', '<leader>hu', gitsigns.undo_stage_hunk, { desc = '[H]unk [U]ndo' })
