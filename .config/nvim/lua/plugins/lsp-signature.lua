return {
    -- FIXME: fork the repo and fix the following issues
    -- Make both insert and normal be toggelable rather than insert always showing and normal toggleable
    'ray-x/lsp_signature.nvim',
    event = 'LspAttach',
    opts = {
        bind = true, -- This is mandatory, otherwise border config won't get registered.
        handler_opts = { border = 'single' },
        doc_lines = 0,
        hint_enable = false,
    },
}
