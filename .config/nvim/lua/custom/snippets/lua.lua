require('luasnip.session.snippet_collection').clear_snippets('lua')
local ls = require('luasnip')
local i = ls.insert_node

---@param abbr string
---@param expansion string
---@param args table
local function s(abbr, expansion, args)
    return ls.snippet(abbr, require('luasnip.extras.fmt').fmt(expansion, args))
end

ls.add_snippets('lua', {
    s('fu', 'function {}({})\n    {}\nend', { i(1), i(2), i(0) }),
    s('desc', "{{ desc = '{}' }}", { i(0) }),
})
