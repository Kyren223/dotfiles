return {
    'numToStr/Comment.nvim',
    opts = {
        padding = true,
        ignore = nil,

        toggler = { line = 'gcc', block = 'gbc' },
        opleader = { line = 'gc', block = 'gb' },
        extra = { above = 'gcO', below = 'gco', eol = 'gcA' },

        mappings = {
            basic = true, -- `gcc` `gbc` `gc[count]{motion}` `gb[count]{motion}`
            extra = false, -- `gco`, `gcO`, `gcA`
        },
    },
    config = function()
        local api = require('Comment.api')
        local esc = vim.api.nvim_replace_termcodes('<ESC>', true, false, true)
        -- TODO: Stay in visual mode and keep the same selection even after commenting
        local toggole_linewise_selection = function()
            vim.api.nvim_feedkeys(esc, 'nx', false)
            api.toggle.linewise(vim.fn.visualmode())
        end

        vim.keymap.set('n', '<C-_>', api.toggle.linewise.current, { noremap = true, silent = true })
        vim.keymap.set('v', '<C-_>', toggole_linewise_selection, { noremap = true, silent = true })
    end,
}
