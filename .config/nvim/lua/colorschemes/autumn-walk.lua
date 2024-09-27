--[[
Copyright (C) 2024 Kyren223. All Rights Reserved.
--]]

local transparent = 'NONE'
local function override(original, new)
    return vim.tbl_extend('force', {}, original, new)
end

-- TODO: Highlight invalid escape sequences in red (for example "\<" but not "\n")

local l = {
    -- normal = { fg = '#EFEDE7', bg = '#1E1E2E' },
    normal = { fg = '#EFEDE7', bg = '#1B1B1B' },
    violet = { fg = '#D484FF' },
    gray_underline = { underline = true, sp = '#909090' },
    comment = { fg = '#007215' },
    macro = { fg = '#DD6718' },
    string = { fg = '#F6D087' },
    keyword = { fg = '#F16265' },
    identifier = { fg = '#BB91F0' },
    function_declaration = { fg = '#54D7A9' },
    function_call = { fg = '#8EDFF9' },
    label = { fg = '#20999D', italic = true },
    operator = { fg = '#54D7A9' },
    parentheses = { fg = '#F9FAF4' },
    class = { fg = '#51C6DC' },
    interface = { fg = '#54D7A9' },
    static_field = { fg = '#F8F8F2' },
    type_parameter = { fg = '#007E8A' },
    parameter = { fg = '#F5A670' },
    annotation = { fg = '#D9E577' },
    rust_macro = { fg = '#5874FF' },
}

l.static_method = override(l.normal, { bg = transparent, italic = true })

local highlights = {
    Normal = l.normal,
    CursorLine = { bg = '#281E25' },
    Visual = { bg = '#232143' },
    CursorLineNr = override(l.violet, { bold = true }),
    LineNrAbove = l.violet,
    LineNrBelow = l.violet,
    LspInlayHint = l.label,
    Comment = {},

    -- Diagnostics
    DiagnosticUnderlineError = { undercurl = true, sp = '#BC3F3C' },
    -- DiagnosticUnderlineError = { undercurl = true },
    DiagnosticUnderlineWarn = { bg = '#452138' },
    DiagnosticUnderlineHint = { underline = false },
    DiagnosticUnnecessary = { fg = '#808080', undercurl = true, sp = '#808080' },

    -- NOTE: Tressitter
    ['@comment'] = l.comment,
    ['@variable'] = l.identifier,
    ['@variable.parameter'] = l.parameter,
    ['@constant'] = l.identifier,
    ['@constant.macro'] = l.macro,
    ['@keyword'] = l.keyword,
    ['@string'] = l.string,
    ['@string.escape'] = l.identifier,
    ['@character'] = l.string,
    ['@number'] = l.identifier,
    ['@float'] = l.identifier,
    ['@boolean'] = l.keyword,
    ['@function'] = l.function_declaration,
    ['@function.call'] = l.function_call,
    ['@label'] = l.label,
    ['@punctuation.bracket'] = l.parentheses,
    ['@punctuation.angle'] = l.comment,
    ['@punctuation.delimiter'] = { fg = '#F19B95' }, -- { fg = '#F16265' } for semicolon
    -- ['@punctuation.semicolon'] = { fg = '#F16265' },
    ['@operator'] = l.operator,
    ['@type'] = l.class,
    ['@type.builtin'] = l.keyword,
    ['@module'] = l.identifier,
    ['@lsp.mod.static'] = l.static_method,
    ['@lsp.type.enumMember'] = l.static_field,
    ['@lsp.type.typeParameter'] = l.type_parameter,
    ['@lsp.type.formatSpecifier'] = l.identifier,
    ['@lsp.typemod.parameter.mutable'] = override(l.normal, l.gray_underline),
    ['@lsp.type.constParameter'] = l.identifier,
    ['@lsp.type.interface'] = l.interface,
    ['@lsp.typemod.static.mutable'] = override(l.normal, l.gray_underline),
    ['@lsp.typemod.variable.mutable'] = l.gray_underline,
    ['@lsp.type.unresolvedReference.rust'] = { fg = '#BC3F3C', underline = true, sp = l.normal.bg },
    ['@attribute'] = l.annotation,

    -- NOTE: Rust
    ['@lsp.mod.attribute.rust'] = l.rust_macro,
    ['@lsp.typemod.string.attribute.rust'] = l.string,
    ['@lsp.type.lifetime.rust'] = l.label,
    ['@lsp.typemod.macro.declaration.rust'] = override(l.normal, { bg = transparent }),
    ['@lsp.type.selfTypeKeyword.rust'] = l.keyword,
    ['@lsp.type.selfKeyword.rust'] = l.keyword,
    -- ['@lsp.mod.associated.rust'] = l.associated_function,
    -- ['@lsp.typemod.function.unsafe.rust'] = { bg = '#5E2828' },
}

local M = {}

function M.load(style)
    for group, args in pairs(highlights) do
        vim.api.nvim_set_hl(0, group, args)
    end
end

return M
