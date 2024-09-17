-- Took from this repo https://github.com/rcarriga/dotfiles/blob/master/.config/nvim/init.lua
local c = {
    transparent = 'NONE',
    grey1 = '#262626',
    grey2 = '#424242',
    grey3 = '#8B8B8B',
    grey4 = '#bdbdbd',
    grey5 = '#F8F8F8',
    violet = '#D484FF',
    blue = '#2f628e',
    cyan = '#00f1f5',
    cyan2 = '#7EC9D8', -- by Kyren (from catpuccin-mocha)
    green = '#A9FF68',
    dark_green = '#142818',
    yellow = '#FFF59D',
    orange = '#F79000',
    orange2 = '#ff9e64', -- by Kyren (from tokyonight-night)
    red = '#F70067',
    dark_red = '#3F0001',
    float_background = '#132434',
    background = 'NONE',
    mocha = '#1E1E2E', -- by Kyren
    mocha_search = '#3E5767', -- by Kyren (from catppuccin-mocha)
    -- mocha_hi1 = '#28283e', -- by Kyren
    mocha_hi1 = '#2A2B3C', -- by Kyren (from tokyonight-night)
    -- mocha_hi2 = '#3c3c5c', -- by Kyren
    -- mocha_hi2 = '#283457',    -- by Kyren (from tokyonight-night)
    mocha_hi2 = '#45475A', -- by Kyren (from catpuccin-mocha)
    black = '#15161E', -- by Kyren (from tokyonight-night)
    -- black = '#181825' -- by Kyren (from catpuccin-mocha)
    -- illum = '#413761', -- by Kyren
    -- illum = '#3E5767', -- by Kyren
    -- illum = '#462250', -- by Kyren
    -- illum = '#352d53', -- by Kyren
    -- illum =    '#5c3d50', -- by Kyren
}

c.normal = c.grey5
c.border = c.grey3
c.decoration = c.orange
c.hidden = c.grey3
c.built_in = c.red
c.var_name = c.grey5
c.func_name = c.cyan
c.type_name = c.violet
c.key = c.cyan
c.val = c.violet
-- c.parameter = c.green -- original
c.parameter = c.orange2 -- by Kyren
c.string = c.yellow
c.operator = c.orange
c.success = c.green
c.warning = c.orange
c.info = c.cyan
c.error = c.red

local highlights = {
    Normal = { fg = c.normal },
    NormalFloat = { fg = c.normal },
    Border = { fg = c.border },
    FloatBorder = { fg = c.border },
    Decoration = { fg = c.orange },
    Hidden = { fg = c.grey3 },
    Path = { fg = c.blue },
    BuiltIn = { fg = c.red },
    VarName = { fg = c.grey5, bold = true },
    FuncName = { fg = c.cyan },
    TypeName = { fg = c.violet },
    Key = { fg = c.cyan },
    Val = { fg = c.violet },
    String = { fg = c.yellow },
    Operator = { fg = c.orange },
    Success = { fg = c.green },
    Warning = { fg = c.yellow },
    Info = { fg = c.cyan },
    Error = { fg = c.red },
    User1 = { fg = c.success, bg = c.float_background },
    User2 = { fg = c.warning, bg = c.float_background },
    User3 = { fg = c.error, bg = c.float_background },
    User4 = { fg = c.grey1, bg = c.info },
    -- Vim
    Cursor = { fg = c.grey1, bg = c.red },
    -- CursorLine = { fg = c.transparent, bg = c.grey1 }, -- original
    -- CursorColumn = { fg = c.transparent, bg = c.grey1 }, -- original
    -- ColorColumn = { fg = c.transparent, bg = c.grey1 }, -- original
    LineNr = { fg = c.hidden },
    CursorLine = { fg = c.transparent, bg = c.mocha_hi1 }, -- by Kyren
    CursorColumn = { fg = c.transparent, bg = c.mocha_hi1 }, -- by Kyren
    ColorColumn = { fg = c.transparent, bg = c.mocha_hi1 }, -- by Kyren
    -- CursorLineNr = { fg = c.success, bold = true }, -- original
    CursorLineNr = { fg = c.violet, bold = true }, -- by Kyren
    LineNrAbove = { fg = c.violet }, -- by Kyren
    LineNrBelow = { fg = c.violet }, -- by Kyren
    VertSplit = { fg = c.hidden },
    MatchParen = { fg = c.key, underline = true },
    StatusLine = { fg = c.normal },
    StatusLineNC = { fg = c.hidden },
    WinBar = { fg = c.normal },
    WinBarNC = { fg = c.normal },
    WinBarSep = { fg = c.decoration, bg = c.grey1 },
    WinBarPath = { fg = c.grey5, bg = c.grey1 },
    -- IncSearch = { fg = c.green, bold = true, underline = true }, -- original
    -- Search = { fg = c.green, bold = true, underline = true }, -- original
    IncSearch = { fg = c.black, bg = c.orange2, bold = true }, -- by Kyren
    Search = { fg = c.black, bg = c.orange2, bold = true }, -- by Kyren
    Directory = { fg = c.cyan },
    Folded = { fg = c.grey3 },
    WildMenu = { fg = c.cyan },
    VisualNOS = { fg = c.grey3, bg = c.yellow },
    ModeMsg = { fg = c.yellow },
    FoldColumn = { fg = c.grey4 },
    MoreMsg = { fg = c.yellow },
    cursorim = { fg = c.violet },
    Pmenu = { fg = c.grey4 },
    PmenuSel = { fg = c.transparent, bg = c.grey2, bold = true },
    PMenuSbar = { fg = c.transparent },
    PMenuThumb = { fg = c.transparent, bg = c.grey4 },
    -- Visual = { fg = c.transparent, bg = c.grey1, bold = true, underline = true }, -- original
    Visual = { fg = c.transparent, bg = c.mocha_hi2, bold = true }, -- by Kyren
    EndOfBuffer = { fg = c.grey1 },
    Underlined = { fg = c.transparent, underline = true },
    SpellBad = { fg = c.transparent, undercurl = true },
    SpellCap = { fg = c.transparent, undercurl = true },
    SpellLocal = { fg = c.transparent, undercurl = true },
    SignColumn = { fg = c.key },
    Question = { fg = c.info },
    TabLineFill = { fg = c.grey3 },
    NotificationInfo = { fg = c.normal, bg = c.float_background },
    NotificationError = { fg = c.error, bg = c.float_background },
    NotificationWarning = { fg = c.warning, bg = c.float_background },
    WinSeparator = { fg = c.grey2 },
    -- General
    Boolean = { fg = c.val },
    Character = { fg = c.val },
    Comment = { fg = c.hidden },
    Conditional = { fg = c.built_in },
    Constant = { fg = c.var_name },
    Define = { fg = c.built_in },
    DiffAdd = { fg = c.background, bg = c.dark_green },
    DiffChange = { fg = c.background, bg = c.grey1 },
    DiffDelete = { fg = c.background, bg = c.dark_red },
    DiffText = { fg = c.background, bg = c.dark_red },
    ErrorMsg = { fg = c.error },
    WarningMsg = { fg = c.warning },
    Float = { fg = c.val },
    Function = { fg = c.func_name },
    Identifier = { fg = c.var_name },
    Keyword = { fg = c.built_in },
    Label = { fg = c.key },
    NonText = { fg = c.hidden },
    Number = { fg = c.val },
    PreProc = { fg = c.key },
    Special = { fg = c.cyan },
    SpecialKey = { fg = c.built_in },
    Statement = { fg = c.built_in },
    Tag = { fg = c.key },
    Title = { fg = c.normal, bold = true },
    Todo = { fg = c.normal, bold = true },
    Type = { fg = c.type_name },
    SpecialComment = { fg = c.info, bold = true },
    Typedef = { fg = c.type_name },
    PreCondit = { fg = c.built_in },
    Include = { fg = c.built_in },
    Ignore = { fg = c.built_in },
    Delimiter = { fg = c.decoration },
    Conceal = { fg = c.transparent, bold = true },
    -- gitsigns
    GitSignsAdd = { fg = c.success, bold = true },
    GitSignsDelete = { fg = c.error, bold = true },
    GitSignsChange = { fg = c.yellow, bold = true },
    --ini
    dosiniLabel = { fg = c.key },
    dosiniValue = { fg = c.val },
    dosiniHeader = { fg = c.built_in },
    -- TreeSitter
    ['@error'] = { fg = c.error },
    ['@comment'] = { fg = c.hidden },
    ['@punct.delimiter'] = { fg = c.decoration },
    ['@punct.bracket'] = { fg = c.decoration },
    ['@punct.special'] = { fg = c.decoration },
    ['@constant'] = { fg = c.var_name },
    ['@const.builtin'] = { fg = c.built_in },
    ['@const.macro'] = { fg = c.built_in },
    ['@string'] = { fg = c.string },
    ['@string.regex'] = { fg = c.operator },
    ['@string.escape'] = { fg = c.operator },
    ['@character'] = { fg = c.val },
    ['@number'] = { fg = c.val },
    ['@boolean'] = { fg = c.val },
    ['@float'] = { fg = c.val },
    ['@function'] = { fg = c.func_name },
    ['@func.builtin'] = { fg = c.built_in },
    ['@func.macro'] = { fg = c.built_in },
    ['@parameter'] = { fg = c.green },
    ['@parameter.reference'] = { fg = c.green },
    ['@method'] = { fg = c.func_name },
    ['@field'] = { fg = c.func_name },
    ['@property'] = { fg = c.parameter },
    ['@tag'] = { fg = c.func_name },
    ['@constructor'] = { fg = c.type_name },
    ['@conditional'] = { fg = c.built_in },
    ['@repeat'] = { fg = c.built_in },
    ['@label'] = { fg = c.key },
    ['@operator'] = { fg = c.operator },
    ['@keyword'] = { fg = c.built_in },
    ['@keyword.function'] = { fg = c.built_in },
    ['@exception'] = { fg = c.error },
    ['@type'] = { fg = c.type_name },
    ['@type.builtin'] = { fg = c.type_name },
    ['@structure'] = { fg = c.error },
    ['@include'] = { fg = c.built_in },
    ['@annotation'] = { fg = c.string },
    ['@text'] = { fg = c.string },
    ['@strong'] = { fg = c.transparent, bold = true },
    ['@emphasis'] = { fg = c.transparent, bold = true, underline = true },
    ['@underline'] = { fg = c.transparent, underline = true },
    ['@title'] = { fg = c.key, bold = true },
    ['@literal'] = { fg = c.decoration },
    ['@uri'] = { fg = c.info },
    ['@variable'] = { fg = c.var_name },
    ['@variable.builtin'] = { fg = c.built_in },
    ['@definition'] = { fg = c.transparent, bold = true },
    ['@definition.usage'] = { fg = c.transparent, bold = true, underline = true },
    ['@current.scope'] = { fg = c.transparent, bold = true },
    ['@text.reference'] = { fg = c.normal, bold = true, underline = true },
    -- Golang
    goFunctionCall = { fg = c.func_name },
    goVarDefs = { fg = c.var_name },
    -- Telescope
    TelescopeBorder = { fg = c.border },
    -- LSP
    LspReferenceText = { fg = c.background, bold = true, underline = true },
    LspReferenceRead = { fg = c.background, bold = true, underline = true },
    LspReferenceWrite = { fg = c.background, bold = true, underline = true },
    DiagnosticTruncateLine = { fg = c.hidden },
    DiagnosticError = { fg = c.error },
    DiagnosticWarn = { fg = c.warning },
    DiagnosticInfo = { fg = c.info },
    DiagnosticHint = { fg = c.info },
    LspCodeLens = { fg = c.type_name, italic = true },
    IblIndent = { fg = c.grey2 },

    ['@lsp.type.property.lua'] = { fg = c.key },
    ['@lsp.mod.defaultLibrary.lua'] = { fg = c.built_in },
    ['@lsp.type.parameter.python'] = { fg = c.parameter },

    -- LSP Signature
    LspSelectedParam = { fg = c.normal, bold = true, underline = true },

    --lsp-inlayhints.nvim
    LspInlayHint = { fg = c.type_name, italic = true },

    --nvim-cmp
    CmpItemAbbr = { fg = c.normal },
    CmpDocumentationBorder = { fg = c.border },
    CmpItemAbbrMatch = { fg = c.normal, bold = true },
    CmpItemAbbrMatchFuzzy = { fg = c.normal, bold = true, underline = true },
    CmpItemAbbrDeprecated = { fg = c.normal, bold = true },
    CmpItemKindVariable = { fg = c.var_name, bold = true },
    CmpItemKindInterface = { fg = c.type_name, bold = true },
    CmpItemKindText = { fg = c.normal, bold = true },
    CmpItemKindFunction = { fg = c.func_name, bold = true },
    CmpItemKindMethod = { fg = c.func_name, bold = true },
    CmpItemKindKeyword = { fg = c.built_in, bold = true },
    CmpItemKindProperty = { fg = c.key, bold = true },
    CmpItemKindUnit = { fg = c.yellow, bold = true },
    CmpItemKindCopilt = { fg = c.green, bold = true },
    CmpBorderedWindow_FloatBorder = { fg = c.border },

    --neorg
    ['@neorg.headings.1.title'] = { fg = c.red, bold = true },
    ['@neorg.headings.2.title'] = { fg = c.orange, bold = true },
    ['@neorg.headings.3.title'] = { fg = c.cyan, bold = true },
    ['@neorg.headings.4.title'] = { fg = c.green, bold = true },
    ['@neorg.headings.5.title'] = { fg = c.yellow, bold = true },
    ['@neorg.headings.6.title'] = { fg = c.grey3, bold = true },
    ['@neorg.headings.1.prefix'] = { fg = c.red, bold = true },
    ['@neorg.headings.2.prefix'] = { fg = c.orange, bold = true },
    ['@neorg.headings.3.prefix'] = { fg = c.cyan, bold = true },
    ['@neorg.headings.4.prefix'] = { fg = c.green, bold = true },
    ['@neorg.headings.5.prefix'] = { fg = c.yellow, bold = true },
    ['@neorg.headings.6.prefix'] = { fg = c.grey3, bold = true },
    ['@neorg.todo_items.done.1'] = { fg = c.success },
    ['@neorg.todo_items.done.2'] = { fg = c.success },
    ['@neorg.todo_items.done.3'] = { fg = c.success },
    ['@neorg.todo_items.done.4'] = { fg = c.success },
    ['@neorg.todo_items.done.5'] = { fg = c.success },
    ['@neorg.todo_items.done.6'] = { fg = c.success },
    ['@neorg.todo_items.undone.1'] = { fg = c.cyan },
    ['@neorg.todo_items.undone.2'] = { fg = c.cyan },
    ['@neorg.todo_items.undone.3'] = { fg = c.cyan },
    ['@neorg.todo_items.undone.4'] = { fg = c.cyan },
    ['@neorg.todo_items.undone.5'] = { fg = c.cyan },
    ['@neorg.todo_items.undone.6'] = { fg = c.cyan },
    ['@neorg.todo_items.pending.1'] = { fg = c.yellow },
    ['@neorg.todo_items.pending.2'] = { fg = c.yellow },
    ['@neorg.todo_items.pending.3'] = { fg = c.yellow },
    ['@neorg.todo_items.pending.4'] = { fg = c.yellow },
    ['@neorg.todo_items.pending.5'] = { fg = c.yellow },
    ['@neorg.todo_items.pending.6'] = { fg = c.yellow },

    logDate = { fg = c.info },
    logLevelDebug = { fg = c.grey3 },
    logLevelInfo = { fg = c.info },

    MiniMapNormal = { fg = c.hidden },
    MiniMapSymbolCount = { fg = c.info },
    MiniMapSymbolLine = { fg = c.cyan },
    MiniMapSymbolView = { fg = c.hidden },

    NeogitDiffAddHighlight = { fg = '#859900' },
    NeogitDiffDeleteHighlight = { fg = '#dc322f' },
    NeogitDiffContextHighlight = { fg = '#b2b2b2' },
    NeogitHunkHeader = { fg = '#cccccc' },
    NeogitHunkHeaderHighlight = { fg = '#cccccc' },

    -- FzfLuaBorder = { fg = c.border },

    NeotestPassedWinBar = { fg = c.success, bg = c.grey1 },
    NeotestFailedWinBar = { fg = c.error, bg = c.grey1 },
    NeotestRunningWinBar = { fg = c.yellow, bg = c.grey1 },
    NeotestSkippedWinBar = { fg = c.cyan, bg = c.grey1 },

    AerialVariableIcon = { fg = c.green },

    -- vim-illuminate
    -- IlluminatedWordText = { bg = c.illum },  -- by Kyren
    -- IlluminatedWordRead = { bg = c.illum },  -- by Kyren
    -- IlluminatedWordWrite = { bg = c.illum }, -- by Kyren
}

local M = {}

function M.set()
    for group, args in pairs(highlights) do
        vim.api.nvim_set_hl(0, group, args)
    end
end

return M
