-- Misc
vim.keymap.set({ 'n', 'i'}, '<C-a>', '<Esc>ggVG', { desc = 'Visually Highlight [A]ll' })
vim.keymap.set('n', '<Esc>', ':nohlsearch<CR>')

-- Window Navigation
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

-- Window resizing
local resize = 2;
vim.keymap.set('n', '<C-Left>', string.format(':vertical resize -%d<CR>', resize), { desc = "Resize Left" })
vim.keymap.set('n', '<C-Up>', string.format(':resize -%d<CR>', resize), { desc = "Resize Up" })
vim.keymap.set('n', '<C-Down>', string.format(':resize +%d<CR>', resize), { desc = "Resize Down" })
vim.keymap.set('n', '<C-Right>', string.format(':vertical resize +%d<CR>', resize), { desc = "Resize Right" })

-- Keep selection after < and >
vim.keymap.set('v', '<', '<gv', {})
vim.keymap.set('v', '>', '>gv', {})

-- todo.lua
vim.keymap.set('n', '<leader>ft', ':TodoTelescope<cr>', { desc = "[F]ind [T]odos" })

