return {
    'stevearc/oil.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    keys = { { '<leader>fo', '<cmd>Oil<cr>', desc = '[F]ilesystem [O]il' } },
    opts = {
        delete_to_trash = true,
        default_file_explorer = true,
        skip_confirm_for_simple_edits = true,
        keymaps = {
            ['gs'] = false,
            ['<C-h>'] = false,
            ['<C-l>'] = false,
            ['<C-k>'] = false,
            ['<C-j>'] = false,
            ['<M-h>'] = 'actions.select_split',
            ['<M-v>'] = 'actions.select_vsplit',
            ['<C-r>'] = 'actions.refresh',
            ['Q'] = 'actions.close',
            ['gS'] = 'actions.change_sort',
            ['gy'] = 'actions.copy_to_system_clipboard',
            ['gp'] = 'actions.paste_from_system_clipboard',
        },
        view_options = {
            show_hidden = true,
            natural_order = true,
        },

        lsp_file_methods = {
            enabled = true,
            -- Time to wait for LSP file operations to complete before skipping
            timeout_ms = 1000,
            -- Set to true to autosave buffers that are updated with LSP willRenameFiles
            -- Set to "unmodified" to only save unmodified buffers
            autosave_changes = false,
        },
    },
    cmd = 'Oil',
    event = 'VimEnter',
}
