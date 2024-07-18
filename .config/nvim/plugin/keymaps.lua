local set = vim.keymap.set
local silent = { silent = true }
---@param mode string|table
---@param keymap string
local function unbind(mode, keymap)
    set(mode, keymap, function() end)
end

local function toggle_zen()
    vim.cmd('Neotree close')
    vim.cmd('Trouble todo close')
    vim.cmd('UndotreeHide')
end


local function paste()
    vim.fn.getreg('+')
end

-- Misc
set({ 'n', 'i' }, '<C-a>', '<Esc>ggVG', { desc = 'Visually Highlight [A]ll' })
set('n', '<Esc>', '<cmd>nohlsearch<CR>', silent)
set({ 'i', 'c' }, '<C-v>', paste) -- FIXME: seems to not work
set('n', '<leader>z', toggle_zen, { desc = '[Z]en Mode', silent = true })
unbind({ 'i', 'n', 'v' }, '<C-r>')

set('n', 'U', '<cmd>redo<cr>')
set('i', '<C-z>', '<cmd>undo<cr>')
set('i', '<C-z>', '<cmd>undo<cr>')

-- Window Navigation - NO NEED BECAUSE IT CONFLICTS WITH TMUX
-- set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
-- set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the down window' })
-- set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the up window' })
-- set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })

-- Window resizing
local resize = 2
set({ 'n', 't' }, '<C-Left>', string.format('<cmd>vertical resize -%d<CR>', resize), { desc = 'Resize Left' })
set({ 'n', 't' }, '<C-Up>', string.format('<cmd>resize -%d<CR>', resize), { desc = 'Resize Up' })
set({ 'n', 't' }, '<C-Down>', string.format('<cmd>resize +%d<CR>', resize), { desc = 'Resize Down' })
set({ 'n', 't' }, '<C-Right>', string.format('<cmd>vertical resize +%d<CR>', resize), { desc = 'Resize Right' })

-- Keep selection after < and > in visual mode
set('v', '<', '<gv')
set('v', '>', '>gv')

-- Execute lua file or line
set('n', '<leader>x', '<cmd>.lua<CR>', { desc = 'Execute the current line' })
set('n', '<leader><leader>x', '<cmd>source %<CR>', { desc = 'Execute the current file' })

-- Reformats file using lsp
set('n', '=', vim.lsp.buf.format, { desc = 'Format File' })
