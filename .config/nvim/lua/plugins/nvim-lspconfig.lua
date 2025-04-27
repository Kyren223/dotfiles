return {
    -- NOTE: Make sure the order is as follows:
    -- Mason loads -> Mason lspconfig loads -> Lspconfig loads
    'neovim/nvim-lspconfig',
    event = { 'BufReadPre', 'BufNewFile' },
    dependencies = {
        -- 'hrsh7th/cmp-nvim-lsp',
        { 'antosha417/nvim-lsp-file-operations', conifg = true },
    },
    config = function()
    end,
}
