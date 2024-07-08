require('custom.snippets.lua')
local luasnip = require('luasnip')
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
        { name = 'nvim_lsp' },
        { name = 'luasnip' },
        { name = 'lazydev', group_index = 0 }, -- for lazydev.nvim
        { name = 'path' }, -- for filesystem
    }),

    snippet = {
        expand = function(args)
            luasnip.lsp_expand(args.body)
        end,
    },
    window = {
        -- TODO: Decide if I like borders or not
        completion = cmp.config.window.bordered(),
        documentation = cmp.config.window.bordered(),
    },
    mapping = cmp.mapping.preset.insert({
        ['<Tab>'] = tab(true),
        ['<S-Tab>'] = tab(false),
        ['<C-Space>'] = cmp.mapping.complete(), -- invoke completion
        ['<CR>'] = cmp.mapping.confirm({ select = true, behavior = cmp.ConfirmBehavior.Insert }),
        ['<C-u>'] = cmp.mapping.scroll_docs(-4),
        ['<C-d>'] = cmp.mapping.scroll_docs(4),
        ['<C-m>'] = cmp.mapping.abort(),
        -- NOTE: Select makes it so it doesn't put the text in the buffer (like Insert or defualt does)
        -- Ex: typing "p" and then select "private" will not write "private" in your buffer, but keep it "p"
        -- Only after accepting the suggestion then it'll become "private"
        ['<C-n>'] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }),
        ['<C-p>'] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }),
    }),
})

print('Sourced completion.lua')
