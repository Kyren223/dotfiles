return {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    config = function()
        ---@type userdata
        ---@diagnostic disable-next-line: missing-fields
        require('nvim-treesitter.configs').setup({
            auto_install = true,
            highlight = { enable = true },
            indent = { enable = true },
            rainbow = {
                enable = true,
                extended_mode = true,
                max_file_lines = nil,
            },
        })

        -- HACK: Workaround to have syntax highlighting in zsh until a zsh parser is added
        -- https://github.com/nvim-treesitter/nvim-treesitter/issues/655
        local ft_to_lang = require('nvim-treesitter.parsers').ft_to_lang
        ---@diagnostic disable-next-line: duplicate-set-field
        require('nvim-treesitter.parsers').ft_to_lang = function(ft)
            if ft == 'zsh' then
                return 'bash'
            end
            return ft_to_lang(ft)
        end
    end,
}
