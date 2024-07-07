local set = vim.keymap.set
local silent = { silent = true }

-- Misc
set({ 'n', 'i' }, '<C-a>', '<Esc>ggVG', { desc = 'Visually Highlight [A]ll' })
set('n', '<Esc>', ':nohlsearch<CR>', silent)
set({ 'i', 'c' }, '<C-v>', '<C-r>+')
set('n', '<leader>z', function()
    vim.cmd('Neotree close')
    vim.cmd('Trouble todo close')
    vim.cmd('UndotreeHide')
end, { desc = '[Z]en Mode', silent = true })

set('n', 'U', ':redo<cr>')
set('i', '<C-z>', ':undo<cr>')

-- Window Navigation
set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the down window' })
set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the up window' })
set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })

-- Window resizing
local resize = 2
set({ 'n', 't' }, '<C-Left>', string.format(':vertical resize -%d<CR>', resize), { desc = 'Resize Left' })
set({ 'n', 't' }, '<C-Up>', string.format(':resize -%d<CR>', resize), { desc = 'Resize Up' })
set({ 'n', 't' }, '<C-Down>', string.format(':resize +%d<CR>', resize), { desc = 'Resize Down' })
set({ 'n', 't' }, '<C-Right>', string.format(':vertical resize +%d<CR>', resize), { desc = 'Resize Right' })

-- Keep selection after < and > in visual mode
set('v', '<', '<gv')
set('v', '>', '>gv')

-- Execute lua file or line
set('n', '<leader>x', '<cmd>.lua<CR>', { desc = 'Execute the current line' })
set('n', '<leader><leader>x', '<cmd>source %<CR>', { desc = 'Execute the current file' })
