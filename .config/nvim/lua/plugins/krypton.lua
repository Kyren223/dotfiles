return {
    dir = '~/projects/krypton',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    lazy = false,
    init = function() end,
    config = function()
        vim.filetype.add({
            extension = {
                kr = 'krypton',
            },
        })
        require('nvim-web-devicons').set_icon({
            kr = {
                icon = '', -- 
                color = '#07f7f7',
                -- color = '#2c638a',
                -- color = '#37b1ce',
                name = 'Krypton',
            },
        })

        local icon, color = require('nvim-web-devicons').get_icon('main.kr', 'kr', { default = true })
        -- vim.notify('ICON: ' .. icon)
        -- vim.notify('COLOR: ' .. color)
        assert(icon == '')
        assert(color == 'DevIconKrypton')

        vim.api.nvim_create_autocmd('FileType', {
            pattern = 'krypton',
            callback = function()
                vim.bo.commentstring = '// %s'
            end,
        })

        vim.treesitter.language.register('odin', 'krypton')
    end,
}
