return {
    -- 'numToStr/Comment.nvim',
    'os-mey/Comment.nvim',
    branch = 'fix-inline-visual-linewise-comment',
    keys = {
        { 'gc', mode = { 'n', 'v' } },
        { 'gb', mode = { 'n', 'v' } },
        { '<C-_>', mode = { 'n', 'v' } },
        { 'gcc', mode = 'n' },
        { 'gcb', mode = 'n' },
    },
    config = function()
        require('Comment').setup()
        local api = require('Comment.api')
        local esc = vim.api.nvim_replace_termcodes('<ESC>', true, false, true)
        local toggle_linewise_selection = function()
            vim.api.nvim_feedkeys(esc, 'nx', false)
            api.toggle.linewise(vim.fn.visualmode())
        end

        -- <C-_> means Ctrl slash, `_` is a `/`
        vim.keymap.set('n', '<C-_>', api.toggle.linewise.current, { noremap = true, silent = true })
        vim.keymap.set('v', '<C-_>', toggle_linewise_selection, { noremap = true, silent = true })
    end,
}
