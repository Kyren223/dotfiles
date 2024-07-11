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
    s('desc', "{{ desc = '{}' }}", { i(0) }),
    s('cmd', '<cmd>{}<cr>', { i(0) }),
    s('scmd', "'<cmd>{}<cr>'", { i(0) }),
})
