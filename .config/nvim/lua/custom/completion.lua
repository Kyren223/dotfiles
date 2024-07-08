require('custom.snippets.lua')
local luasnip = require('luasnip')
local lspkind = require('lspkind')
local cmp = require('cmp')

-- Enable paretheses for function completions
cmp.event:on('confirm_done', require('nvim-autopairs.completion.cmp').on_confirm_done())

-- Helper functions
local function tab(is_forward)
    return cmp.mapping(function(fallback)
        local jump_amount = is_forward and 1 or -1
        if cmp.visible() then
            local behaviour = cmp.SelectBehavior.Select
            local select_item = is_forward and cmp.select_next_item or cmp.select_prev_item
            select_item({ behaviour = behaviour })
        elseif luasnip.locally_jumpable(jump_amount) then
            luasnip.jump(jump_amount)
        else
            fallback()
        end
    end, { 'i', 's' })
end

local function is_enabled()
    local context = require('cmp.config.context')

    local is_in_comment = context.in_treesitter_capture('comment') or context.in_syntax_group('Comment')
    if is_in_comment then
        return false
    end

    return true
end

cmp.setup({
    enabled = is_enabled,
    completion = { completeopt = 'menu,menuone,noinsert' },
    sources = cmp.config.sources({
        { name = 'nvim_lsp' }, -- for lsp
        { name = 'luasnip' }, -- for snippets
        { name = 'lazydev', group_index = 0 }, -- for lazydev.nvim
        { name = 'path' }, -- for filesystem
    }, {}),
    snippet = {
        expand = function(args)
            luasnip.lsp_expand(args.body)
        end,
    },
    window = {
        documentation = cmp.config.window.bordered(),
        completion = {
            border = 'rounded',
            winhighlight = 'Normal:Pmenu,FloatBorder:Pmenu,Search:None',
            col_offset = -3,
            side_padding = 0,
        },
    },
    mapping = cmp.mapping.preset.insert({
        ['<Tab>'] = tab(true),
        ['<S-Tab>'] = tab(false),
        ['<C-Space>'] = cmp.mapping.complete(), -- invoke completion
        ['<CR>'] = cmp.mapping.confirm({ select = true, behavior = cmp.ConfirmBehavior.Insert }),
        ['<C-u>'] = cmp.mapping.scroll_docs(-4),
        ['<C-d>'] = cmp.mapping.scroll_docs(4),
        ['<C-m>'] = cmp.mapping.abort(),
        ['<C-n>'] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }),
        ['<C-p>'] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }),
    }),
    ---@diagnostic disable-next-line: missing-fields
    formatting = {
        fields = { 'kind', 'abbr', 'menu' },
        format = function(entry, vim_item)
            local kind = lspkind.cmp_format({ mode = 'symbol_text', maxwidth = 50 })(entry, vim_item)
            local strings = vim.split(kind.kind, '%s', { trimempty = true })
            kind.kind = ' ' .. (strings[1] or '') .. ' ' -- left (icon)
            kind.menu = '    ' .. (strings[2] or '') .. '' -- right (text)
            return kind
        end,
    },
})