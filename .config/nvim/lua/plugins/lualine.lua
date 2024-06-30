return {
    'nvim-lualine/lualine.nvim',
    config = function()
        -- TODO: Configure this to make the status line fully customizable
        require('lualine').setup({
            options = {
                theme = 'tokyonight',
            },
            sections = { lualine_c = { require('auto-session.lib').current_session_name } },
        })
    end,
}
