return {
    'nvim-treesitter/nvim-treesitter',
    version = false, -- last release is way too old
    build = ':TSUpdate',
    lazy = false, -- It's only 2ms it's fine
    cmd = { 'TSUpdateSync', 'TSUpdate', 'TSInstall' },
    keys = {
        { '<c-space>', desc = 'Increment Selection' },
        { '<bs>', desc = 'Decrement Selection', mode = 'x' },
    },
    ---@type TSConfig
    ---@diagnostic disable-next-line: missing-fields
    opts = {
        highlight = { enable = true },
        indent = { enable = true },
        auto_install = true,
        rainbow = {
            enable = true,
            extended_mode = true,
            max_file_lines = nil,
        },

        ensure_installed = {
            'bash',
            'c',
            'diff',
            'html',
            'javascript',
            'jsdoc',
            'json',
            'jsonc',
            'lua',
            'luadoc',
            'luap',
            'markdown',
            'markdown_inline',
            'printf',
            'python',
            'query',
            'regex',
            'toml',
            'tsx',
            'typescript',
            'vim',
            'vimdoc',
            'xml',
            'yaml',
        },

        incremental_selection = {
            enable = true,
            keymaps = {
                init_selection = '<C-space>',
                node_incremental = '<C-space>',
                scope_incremental = false,
                node_decremental = '<bs>',
            },
        },

        textobjects = {
            move = {
                enable = true,
                goto_next_start = {
                    ['gf'] = '@function.outer',
                    ['gc'] = '@class.outer',
                    ['ga'] = '@parameter.inner',
                },
                goto_previous_start = {
                    ['gF'] = '@function.outer',
                    ['gC'] = '@class.outer',
                    ['gA'] = '@parameter.inner',
                },
            },
        },
    },
    config = function(_, opts)
        require('nvim-treesitter.configs').setup(opts)

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
    init = function(plugin)
        -- PERF: add nvim-treesitter queries to the rtp and it's custom query predicates early
        -- This is needed because a bunch of plugins no longer `require("nvim-treesitter")`, which
        -- no longer trigger the **nvim-treesitter** module to be loaded in time.
        -- Luckily, the only things that those plugins need are the custom queries, which we make available
        -- during startup.
        require('lazy.core.loader').add_to_rtp(plugin)
        require('nvim-treesitter.query_predicates')
    end,
}
