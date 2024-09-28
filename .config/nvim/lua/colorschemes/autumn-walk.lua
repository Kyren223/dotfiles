--[[
Copyright (C) 2024 Kyren223. All Rights Reserved.
--]]

local transparent = 'NONE'
local function override(original, new)
    return vim.tbl_extend('force', {}, original, new)
end

local function rgb(c)
    c = string.lower(c)
    return { tonumber(c:sub(2, 3), 16), tonumber(c:sub(4, 5), 16), tonumber(c:sub(6, 7), 16) }
end

---@param foreground string foreground color
---@param background string background color
---@param alpha number|string number between 0 and 1. 0 results in bg, 1 results in fg
local function blend(foreground, alpha, bg)
    local background = bg or '#000000'
    alpha = type(alpha) == 'string' and (tonumber(alpha, 16) / 0xff) or alpha
    local bg = rgb(background)
    local fg = rgb(foreground)

    local blendChannel = function(i)
        local ret = (alpha * fg[i] + ((1 - alpha) * bg[i]))
        return math.floor(math.min(math.max(0, ret), 255) + 0.5)
    end

    return string.format('#%02x%02x%02x', blendChannel(1), blendChannel(2), blendChannel(3))
end

local l = {
    -- normal = { fg = '#EFEDE7', bg = '#09090F' },
    normal = { fg = '#EFEDE7', bg = '#1B1B1B' },
    visual = { bg = '#232143' },
    cursor_line = { bg = '#281E25' },
    violet = { fg = '#D484FF' },
    gray_underline = { underline = true, sp = '#909090' },
    comment = { fg = '#007215' },
    doc_comment = { fg = '#5D545F' },
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
    illuminate = { bg = '#534355' },
}

l.static_method = override(l.normal, { bg = transparent, italic = true })

local highlights = function()
    return {
        Normal = l.normal,
        CursorLine = l.cursor_line,
        Visual = l.visual,
        CursorLineNr = override(l.violet, { bold = true }),
        LineNrAbove = l.violet,
        LineNrBelow = l.violet,
        LspInlayHint = l.label,
        Comment = {},
        StatusLine = l.normal,
        EndOfBuffer = { fg = 'bg' },

        -- NOTE: Diagnostics
        DiagnosticUnderlineError = { undercurl = true, sp = '#BC3F3C' },
        -- DiagnosticUnderlineError = { undercurl = true },
        -- DiagnosticUnderlineWarn = { bg = '#452138' },
        DiagnosticUnderlineHint = { underline = false },
        DiagnosticUnnecessary = { fg = '#808080', undercurl = true, sp = '#808080' },
        -- DiagnosticError = { fg = c.error },
        -- DiagnosticWarn = { fg = c.warning },
        -- DiagnosticInfo = { fg = c.info },
        -- DiagnosticHint = { fg = c.info },

        -- NOTE: Tressitter
        ['@comment'] = l.comment,
        ['@variable'] = l.identifier,
        ['@variable.parameter'] = l.parameter,
        ['@constant'] = l.identifier,
        ['@constant.macro'] = l.macro,
        ['@keyword'] = l.keyword,
        ['@string'] = l.string,
        ['@string.escape'] = l.identifier,
        ['@lsp.type.invalidEscapeSequence'] = { fg = '#FF434F' },
        ['@character'] = l.string,
        ['@number'] = l.identifier,
        ['@float'] = l.identifier,
        ['@boolean'] = l.keyword,
        ['@function'] = l.function_declaration,
        ['@function.call'] = l.function_call,
        ['@label'] = l.label,
        ['@punctuation.bracket'] = l.parentheses,
        ['@punctuation.delimiter'] = { fg = '#F19B95' }, -- { fg = '#F16265' } for semicolon
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
        ['@lsp.type.unresolvedReference'] = { fg = '#BC3F3C', nocombine = true },
        ['@attribute'] = l.annotation,
        ['@lsp.typemod.comment.documentation'] = l.doc_comment,

        -- NOTE: Rust
        ['@lsp.mod.attribute.rust'] = l.rust_macro,
        ['@lsp.typemod.string.attribute.rust'] = l.string,
        ['@lsp.type.lifetime.rust'] = l.label,
        ['@lsp.typemod.macro.declaration.rust'] = override(l.normal, { bg = transparent }),
        ['@lsp.type.selfTypeKeyword.rust'] = l.keyword,
        ['@lsp.type.selfKeyword.rust'] = l.keyword,
        -- ['@lsp.mod.associated.rust'] = l.associated_function,
        -- ['@lsp.typemod.function.unsafe.rust'] = { bg = '#5E2828' },

        -- NOTE: Lua
        ['@lsp.type.property.lua'] = { fg = '#F5A670' },
        ['@comment.documentation.lua'] = l.doc_comment,
        ['@lsp.type.comment.lua'] = {},

        -- NOTE: vim-illuminate
        IlluminatedWordText = l.illuminate,
        IlluminatedWordRead = l.illuminate,
        IlluminatedWordWrite = l.illuminate,

        -- NOTE: Neogit
        NeogitDiffAddHighlight = { fg = '#859900' },
        NeogitDiffDeleteHighlight = { fg = '#dc322f' },
        NeogitDiffContextHighlight = { fg = '#b2b2b2' },
        NeogitHunkHeader = { fg = '#cccccc' },
        NeogitHunkHeaderHighlight = { fg = '#cccccc' },

        -- NOTE: nvim-cmp
        -- CmpItemAbbr = { fg = c.normal },
        -- CmpDocumentationBorder = { fg = c.border },
        -- CmpItemAbbrMatch = { fg = c.normal, bold = true },
        -- CmpItemAbbrMatchFuzzy = { fg = c.normal, bold = true, underline = true },
        -- CmpItemAbbrDeprecated = { fg = c.normal, bold = true },
        -- CmpItemKindVariable = { fg = c.var_name, bold = true },
        -- CmpItemKindInterface = { fg = c.type_name, bold = true },
        -- CmpItemKindText = { fg = c.normal, bold = true },
        -- CmpItemKindFunction = { fg = c.func_name, bold = true },
        -- CmpItemKindMethod = { fg = c.func_name, bold = true },
        -- CmpItemKindKeyword = { fg = c.built_in, bold = true },
        -- CmpItemKindProperty = { fg = c.key, bold = true },
        -- CmpItemKindUnit = { fg = c.yellow, bold = true },
        -- CmpItemKindCopilt = { fg = c.green, bold = true },
        -- CmpBorderedWindow_FloatBorder = { fg = c.border },
    }
end

local styles = {}
styles.tokyo = function()
    l.normal.bg = '#1E1E2E'
    l.visual.bg = blend('#3d59a1', 0.4)
    l.cursor_line.bg = '#292e42'
    l.illuminate.bg = '#3b4261'
end

local M = {}

function M.load(style)
    if style ~= nil then
        if not styles[style] then
            Notify('Style "' .. style .. '" not found, unable to load colorscheme!', 'Thing', vim.log.levels.ERROR)
            return
        end
        styles[style]()
    end

    for group, args in pairs(highlights()) do
        vim.api.nvim_set_hl(0, group, args)
    end
end

return M
