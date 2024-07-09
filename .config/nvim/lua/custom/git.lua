local set = vim.keymap.set
local gitsigns = require('gitsigns')
gitsigns.setup()
require('neogit').setup({})
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
set('n', '<leader>gi', '<cmd>Octo issue search<cr>', { desc = '[G]ithub [I]ssues' })
set('n', '<leader>pr', '<cmd>Octo issue search<cr>', { desc = 'Github [PR]s' })

-- Git keymaps
set('n', '<leader>gb', gitsigns.toggle_current_line_blame, { desc = '[G]it [B]lame Line' })
set('n', '<leader>gD', gitsigns.toggle_deleted, { desc = '[G]it [D]eleted' })
set('n', '<leader>gd', '<cmd>DiffviewOpen<cr>', { desc = '[G]it [D]iff' })
set('n', '<leader>gl', '<cmd>DiffviewFileHistory<cr>', { desc = '[G]it [L]og' })
set('n', '<leader>gs', '<cmd>Neogit<cr>', { desc = '[G]it [S]tatus' })
set('n', '<leader>ga', 'TODO:', { desc = '[G]it [A]dd' })
set('n', '<leader>gc', 'TODO:', { desc = '[G]it [C]ommit' })
set('n', '<leader>gp', 'TODO:', { desc = '[G]it [P]ush' })
set('n', '<leader>gP', 'TODO:', { desc = '[G]it [P]ull' })

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
