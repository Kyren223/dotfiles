return {
    'rmagatti/auto-session',
    lazy = false,
    opts = {
        suppressed_dirs = { '~/', '/' },
        session_lens = { load_on_setup = false },
        bypass_save_filetypes = { 'snacks_dashboard' },
        close_filetypes_on_save = { 'checkhealth', 'build_terminal' },
    },
}
