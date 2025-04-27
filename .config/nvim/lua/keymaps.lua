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

local function yank_filepath_to_clipboard(os)
    return function()
        local filepath = vim.fn.expand('%:p')
        -- TODO: simplify bcz idc about windows anymore
        if os == 'linux' then
            local home_dir = vim.fn.expand('~')
            filepath = filepath:gsub(home_dir, '~')
        elseif os == 'windows' then
            local mnt = '/mnt/'
            if filepath:sub(1, #mnt) == mnt then
                filepath = filepath:sub(#mnt + 1, #mnt + 1) .. ':' .. filepath:sub(#mnt + 2)
            else
                filepath = '//wsl.localhost/openSUSE-Tumbleweed' .. filepath
            end
            filepath = filepath:gsub('/', '\\')
        end
        vim.fn.setreg('+', filepath)
    end
end

function RemoveClipboardCR()
    local clipboard = vim.fn.getreg('+'):gsub('\r', '')
    vim.fn.setreg('+', clipboard)
end

local function paste()
    RemoveClipboardCR()
    local value = vim.fn.getreg('+')
    if vim.fn.mode() == 'c' then
        -- value = vim.split(value, '\n')[1] -- only use first line (default with normal pasting)
        value = value:gsub('\n', ' ') -- replace newlines with spaces
        vim.api.nvim_feedkeys(value, 'c', false)
    else
        vim.api.nvim_put(vim.split(value, '\n'), 'c', false, true)
    end
end

-- "Greatest Keymap ever" - ThePrimeagen
-- https://www.youtube.com/watch?v=qZO9A5F6BZs&list=PLm323Lc7iSW_wuxqmKx_xxNtJC_hJbQ7R&index=4
set('x', '<leader>p', '<cmd>lua RemoveClipboardCR()<cr>"_dP')

set('n', '!', ':!')

set({ 'n', 'x' }, 'p', '<cmd>lua RemoveClipboardCR()<cr>p', { noremap = true })
set({ 'n', 'x' }, 'P', '<cmd>lua RemoveClipboardCR()<cr>P', { noremap = true })

-- Move lines around
set('n', '<A-j>', ':m .+1<cr>', { noremap = true })
set('n', '<A-k>', ':m .-2<cr>', { noremap = true })
set('v', '<A-j>', ":m '>+1<cr>gv", { noremap = true })
set('v', '<A-k>', ":m '<-2<cr>gv", { noremap = true })

-- Misc
set({ 'n', 'i' }, '<C-a>', '<Esc>ggVG', { desc = 'Visually Highlight [A]ll' })
set('i', '<C-H>', '<C-w>', { desc = 'Ctrl + Backspace to delete word' })
set('n', '<Esc>', '<cmd>nohlsearch<CR>', silent)
set({ 'i', 'c' }, '<C-v>', paste)
set('n', '<leader>z', toggle_zen, { desc = '[Z]en Mode', silent = true })
unbind({ 'i', 'n', 'v' }, '<C-r>')

set('n', 'U', '<cmd>redo<cr>')
set('i', '<C-z>', '<cmd>undo<cr>')
set({ 'i', 'n', 'v' }, '<C-q>', '<cmd>wqa<cr>')
set('n', '<leader>yp', yank_filepath_to_clipboard('linux'), { desc = '[Y]oink File [P]ath (linux)' })
set('n', '<leader>yP', yank_filepath_to_clipboard('windows'), { desc = '[Y]oink File [P]ath (windows)' })

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

-- LSP keymaps
local severity = vim.diagnostic.severity
local function next_diagnostic(diagnostic_severity)
    return function()
        require('lspsaga.diagnostic'):goto_next({ severity = diagnostic_severity })
    end
end
local function prev_diagnostic(diagnostic_severity)
    return function()
        require('lspsaga.diagnostic'):goto_prev({ severity = diagnostic_severity })
    end
end
local function cursor_diagnostics()
    vim.diagnostic.open_float({
        scope = 'cursor',
        border = 'single',
    })
end

local keymaps = {
    { 'n', 'gd', '<cmd>Lspsaga goto_definition<cr>', { desc = '[G]oto [D]efinition' } },
    { 'n', 'gu', '<cmd>Lspsaga finder<cr>', { desc = '[G]oto [U]sages' } },
    { { 'n', 'i' }, '<C-p>', vim.lsp.buf.signature_help, { desc = 'Show [P]arameters' } },
    { 'n', 'K', '<cmd>Lspsaga hover_doc<cr>', { desc = 'Documentation' } },
    { 'n', 'R', '<cmd>Lspsaga rename<cr>', { desc = '[R]ename' } },
    { { 'n', 'i' }, '<M-Enter>', '<cmd>Lspsaga code_action<cr>', { desc = 'Code Actions' } },
    { 'n', '<leader>ca', '<cmd>Lspsaga code_action<cr><Esc>', { desc = '[C]ode [A]ctions' } },
    { 'n', '<leader>e', next_diagnostic(severity.ERROR), { desc = 'Goto [E]rror' } },
    { 'n', '<leader>E', prev_diagnostic(severity.ERROR), { desc = 'Goto [E]rror (prev)' } },
    { 'n', '<leader>w', next_diagnostic(severity.WARN), { desc = 'Goto [W]arning' } },
    { 'n', '<leader>W', prev_diagnostic(severity.WARN), { desc = 'Goto [W]arning (prev)' } },
    { 'n', '<leader>D', cursor_diagnostics, { desc = '[D]iagnostics under cursor' } },
}

for _, ft in ipairs({ 'c', 'h', 'cpp', 'hpp' }) do
    keymaps[ft] = {
        { 'n', 'H', '<cmd>ClangdSwitchSourceHeader<cr>', { desc = '[H]eader and Source Switcher' } },
        { 'n', 'K', '<cmd>lua require("pretty_hover").hover()<cr>', { desc = 'Documentation Hover' } },
    }
end

local function set_keymaps(tbl, bufnr)
    for _, keymap in ipairs(tbl) do
        local mode = keymap[1]
        local lhs = keymap[2]
        local rhs = keymap[3]
        local opts = keymap[4] or {}
        opts.buffer = bufnr
        vim.keymap.set(mode, lhs, rhs, opts)
    end
end

vim.api.nvim_create_autocmd('LspAttach', {
    desc = 'Register LSP keymaps',
    group = vim.api.nvim_create_augroup('lsp-keymaps', { clear = true }),
    callback = function(args)
        local bufnr = args.buf

        local filetype = vim.bo[bufnr].filetype
        set_keymaps(keymaps, bufnr)
        for ft, tbl in pairs(keymaps) do
            if type(ft) == 'number' or ft ~= filetype then
                goto continue
            end
            set_keymaps(tbl, bufnr)
            ::continue::
        end
    end,
})
