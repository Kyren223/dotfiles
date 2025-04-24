return {
    'windwp/nvim-autopairs',
    event = 'InsertEnter',
    opts = {
        check_ts = true,
        ts_config = {
            lua = { 'string' }, -- don't add pairs inside lua strings
            javascript = { 'template_string' }, -- FIX: remove me
        },
    },
}
