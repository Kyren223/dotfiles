--[[
Copyright (C) 2024 Kyren223. All Rights Reserved.
--]]

local transparent = 'NONE'
function override(original, new)
    return vim.tbl_extend('force', {}, original, new)
end

-- TODO: Highlight invalid escape sequences in red (for example "\<" but not "\n")

local l = {
    normal = { fg = '#EFEDE7', bg = '#1B1B1B' },
    violet = { fg = '#D484FF' },
    comment = { fg = '#007215' },
    identifier = { fg = '#DD6718' },
    string = { fg = '#F6D087' },
    keyword = { fg = '#F16265' },
    number = { fg = '#BB91F0' },
    function_declaration = { fg = '#54D7A9' },
    function_call = { fg = '#8EDFF9' },
    label = { fg = '#20999D', italic = true },
    operator = { fg = '#54D7A9' },
    parentheses = { fg = '#F9FAF4' },
    class = { fg = '#51C6DC' },
    static_field = { fg = '#F8F8F2' },
    type_parameter = { fg = '#007E8A' },

    rust_macro = { fg = '#5874FF' },
}

l.static_method = override(l.normal, { bg = transparent, italic = true })

local highlights = {
    Normal = l.normal,

    -- '#BBBBBB'
    Cursor = { fg = '#F70067', bg = '#F70067' },
    CursorLine = { bg = '#281E25' },

    CursorLineNr = override(l.violet, { bold = true }),
    LineNrAbove = l.violet,
    LineNrBelow = l.violet,

    Comment = {},
    LspInlayHint = { fg = '#cc5f62' },
    -- LspInlayHint = { fg = '#204042' },

    ['@comment'] = l.comment,
    ['@variable'] = l.number,
    ['@constant'] = l.number,
    ['@constant.macro'] = l.identifier,
    ['@keyword'] = l.keyword,
    ['@string'] = l.string,
    ['@string.escape'] = l.number,
    ['@character'] = l.string,
    ['@number'] = l.number,
    ['@float'] = l.number,
    ['@boolean'] = l.keyword,
    ['@function'] = l.function_declaration,
    ['@function.call'] = l.function_call,
    ['@label'] = l.label,
    ['@punctuation.bracket'] = l.parentheses,
    ['@operator'] = l.operator,
    ['@type'] = l.class,
    ['@type.builtin'] = l.keyword,
    ['@module'] = l.number,
    ['@lsp.mod.static'] = l.static_method,
    ['@lsp.type.enumMember'] = l.static_field,
    ['@lsp.type.typeParameter'] = l.type_parameter,
    ['@lsp.type.formatSpecifier'] = l.number,

    -- Rust specific
    ['@lsp.mod.attribute.rust'] = l.rust_macro,
    ['@lsp.typemod.string.attribute.rust'] = l.string,
    ['@lsp.type.lifetime.rust'] = l.label,
    ['@lsp.typemod.macro.declaration.rust'] = override(l.normal, { bg = transparent }),
    ['@lsp.type.selfTypeKeyword.rust'] = l.keyword,
    -- ['@lsp.mod.associated.rust'] = l.associated_function,
    -- ['@lsp.typemod.function.unsafe.rust'] = { bg = '#5E2828' },
}

local M = {}

function M.load()
    for group, args in pairs(highlights) do
        vim.api.nvim_set_hl(0, group, args)
    end
end

return M
