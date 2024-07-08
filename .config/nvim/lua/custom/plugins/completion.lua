return {
    'hrsh7th/nvim-cmp',
    lazy = false,
    priority = 100,
    dependencies = {
        'onsails/lspkind.nvim', -- icons for completion type
        'hrsh7th/cmp-path', -- complete filepaths
        'hrsh7th/cmp-nvim-lsp', -- lsp source for nvim-cmp
        'saadparwaiz1/cmp_luasnip', -- snippets source for nvim-cmp
        { 'L3MON4D3/LuaSnip', build = 'make install_jsregexp' }, -- snippets plugin
    },
    config = function()
        require('custom.completion')
    end,
}
