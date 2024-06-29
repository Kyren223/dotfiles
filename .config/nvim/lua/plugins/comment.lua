return {
    'numToStr/Comment.nvim',
    opts = {
        padding = true,
        sticky = true, -- keep cursor at it's position
        ignore = nil,

        toggler = { line = 'gcc', block = 'gbc' },
        opleader = { line = 'gc', block = 'gb' },
        extra = { above = 'gcO', below = 'gco', eol = 'gcA' },

        mappings = {
            basic = true,  -- `gcc` `gbc` `gc[count]{motion}` `gb[count]{motion}`
            extra = false, -- `gco`, `gcO`, `gcA`
        },
    },
}
