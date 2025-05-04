return {
    'windwp/nvim-autopairs',
    event = 'InsertEnter',
    opts = {
        check_ts = true,
        -- don't add pairs inside these treesitter nodes
        -- THIS DOESN'T EVEN WORK IN LUA lol
        -- I guess waiting on this to be fixed...
        ts_config = {
            lua = { 'string' },
            go = { 'string' },
            zig = { 'string' },
        },
    },
    config = function(_, opts)
        require('nvim-autopairs').setup(opts)

        local Rule = require('nvim-autopairs.rule')
        local npairs = require('nvim-autopairs')
        local cond = require('nvim-autopairs.conds')

        npairs.add_rule(Rule('<', '>', {
            -- if you use nvim-ts-autotag, you may want to exclude these filetypes from this rule
            -- so that it doesn't conflict with nvim-ts-autotag
            '-html',
            '-javascriptreact',
            '-typescriptreact',
        }):with_pair(
            -- regex will make it so that it will auto-pair on
            -- `a<` but not `a <`
            -- The `:?:?` part makes it also
            -- work on Rust generics like `some_func::<T>()`
            cond.before_regex('%a+:?:?$', 3)
        ):with_move(function(opts)
            return opts.char == '>'
        end))
    end,
}
