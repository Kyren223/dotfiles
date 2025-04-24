require('luasnip.session.snippet_collection').clear_snippets('lua')
local ls = require('luasnip')
local i = ls.insert_node

---@param abbr string
---@param expansion string
---@param args table
local function s(abbr, expansion, args)
    return ls.snippet(abbr, require('luasnip.extras.fmt').fmt(expansion, args))
end

local carbonight_group = [=[
--[[
Copyright (C) 2024 Kyren223
This file is licensed under the GPL-3.0-or-later license, see https://fsf.org/licenses/gpl-3.0
--]]

local utils = require("carbonight.utils")

local M = {{}}

---@param c Colors
function M.get(c)
    return {{
        {}
    }}
end

return M
]=]

ls.add_snippets('lua', {
    s('desc', "{{ desc = '{}' }}", { i(0) }),
    s('cmd', '<cmd>{}<cr>', { i(0) }),
    s('scmd', "'<cmd>{}<cr>'", { i(0) }),
    s('cng', carbonight_group, { i(0) }),
})
