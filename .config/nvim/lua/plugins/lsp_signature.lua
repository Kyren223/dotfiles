return {
    -- 'ray-x/lsp_signature.nvim',
    -- event = 'VeryLazy',
    -- config = function()
    --     local lsp_signature = require('lsp_signature')
    --     vim.api.nvim_create_autocmd('LspAttach', {
    --         callback = function(args)
    --             local bufnr = args.buf
    --             local client = vim.lsp.get_client_by_id(args.data.client_id)
    --             if vim.tbl_contains({ 'null-ls' }, client.name) then
    --                 return
    --             end
    --             lsp_signature.on_attach({}, bufnr)
    --         end,
    --     })
    --
    --     require('lsp_signature').setup({})
    --     vim.keymap.set({ 'i', 'n' }, '<C-p>', lsp_signature.toggle_float_win, { desc = 'toggle signature' })
    -- end,
}
