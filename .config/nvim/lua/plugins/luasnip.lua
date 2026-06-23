return {
    'L3MON4D3/LuaSnip',
    version = 'v2.*', -- follow latest release.
    build = 'make install_jsregexp',
    opts = {},
    config = function(_, opts)
        require('luasnip').setup(opts)

        -- Load language specific snippets
        require('luasnip.loaders.from_vscode').load({ paths = './snippets' })

        -- load project specific snippets
        local project = vim.fn.fnamemodify(vim.fn.getcwd(), ':t')
        local project_snippets = {
            eko = 'eko.json',
            ['carbonight.nvim'] = 'carbonight.json',
        }
        local file = project_snippets[project]
        if file then
            require('luasnip.loaders.from_vscode').load_standalone({ path = './snippets/' .. file })
        end

        -- some shorthands...
        local ls = require('luasnip')
        local s = ls.snippet
        local sn = ls.snippet_node
        local isn = ls.indent_snippet_node
        local t = ls.text_node
        local i = ls.insert_node
        local f = ls.function_node
        local c = ls.choice_node
        local d = ls.dynamic_node
        local r = ls.restore_node
        local events = require('luasnip.util.events')
        local ai = require('luasnip.nodes.absolute_indexer')
        local opt = require('luasnip.nodes.optional_arg')
        local extras = require('luasnip.extras')
        local l = extras.lambda
        local rep = extras.rep
        local p = extras.partial
        local m = extras.match
        local n = extras.nonempty
        local dl = extras.dynamic_lambda
        local fmt = require('luasnip.extras.fmt').fmt
        local fmta = require('luasnip.extras.fmt').fmta
        local conds = require('luasnip.extras.expand_conditions')
        local postfix = require('luasnip.extras.postfix').postfix
        local ts_postfix = require('luasnip.extras.treesitter_postfix').treesitter_postfix
        local types = require('luasnip.util.types')
        local parse = require('luasnip.util.parser').parse_snippet
        local ms = ls.multi_snippet
        local k = require('luasnip.nodes.key_indexer').new_key
        local postfix_builtin = require('luasnip.extras.treesitter_postfix').builtin

        ls.add_snippets('all', {
            ts_postfix({
                matchTSNode = postfix_builtin.tsnode_matcher.find_topmost_types({
                    'identifier',
                    'method_invocation',
                    'field_access',
                    'type_identifier',
                    'class_literal',
                    'this',
                    'scoped_type_identifier',
                }),
                trig = '.unwrap',
            }, {
                f(function(_, parent)
                    local match = parent.snippet.env.LS_TSMATCH
                    -- vim.notify('postfix: "' .. vim.inspect(match) .. '"')

                    if not match then
                        vim.notify('warning empty unwrap', vim.log.levels.WARN)
                        return { 'unwrap()' }
                    end

                    -- If LuaSnip provides the match as a table, concat it
                    if type(match) == 'table' then
                        match = table.concat(match, '\n')
                    end

                    local wrapped = string.format('unwrap(%s)', match)
                    -- Split it back into a table of strings to safely handle any newlines
                    return vim.split(wrapped, '\n', { plain = true })
                end),
            }),
        })
    end,
}
