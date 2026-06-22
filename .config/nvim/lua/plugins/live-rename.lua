return {
    'saecki/live-rename.nvim',
    commit = '2a30bfdc9369c8ffb188e6da715fbdf1aef6f647',
    -- default config
    keys = { 'r', 'rr', 'R' },
    opts = {
        -- Send a `textDocument/prepareRename` request to the server to
        -- determine the word to be renamed, can be slow on some servers.
        -- Otherwise fallback to using `<cword>`.
        prepare_rename = true,
        --- The timeout for the `textDocument/prepareRename` request and final
        --- `textDocument/rename` request when submitting.
        request_timeout = 1500,
        -- Make an initial `textDocument/rename` request to gather other
        -- occurences which are edited and use these ranges to preview.
        -- If disabled only the word under the cursor will have a preview.
        show_other_ocurrences = true,
        -- Try to infer patterns from the initial `textDocument/rename` request
        -- and use these to show hopefully better edit previews.
        use_patterns = true,
        -- The register which is used to temporarily record a macro into. This
        -- macro can then be executed on other symbols using the `macrorepeat`
        -- rename option.
        scratch_register = 'l',
        keys = {
            submit = {
                { 'n', '<cr>' },
                { 'v', '<cr>' },
                { 'i', '<cr>' },
                { 'n', '<esc>' },
            },
            cancel = {
                { 'n', '<c-c>' },
                { 'i', '<c-c>' },
                { 'n', 'q' },
            },
        },
        hl = {
            current = 'LiveRenameCurrent',
            others = 'LiveRenameOthers',
        },
    },

    -- -- Start in normal mode and maintain cursor position.
    -- require("live-rename").rename()
    --
    -- -- Start in normal mode and jump to the start of the word.
    -- require("live-rename").rename({ cursorpos = 0 })
    --
    -- -- Start in insert mode and jump to the end of the word
    -- require("live-rename").rename({ insert = true, cursorpos = -1 })
    --
    -- -- Start in insert mode with an empty word
    -- require("live-rename").rename({ text = "", insert = true })
    --
    -- -- The actions that happened in the previous rename window are recorded as a macro.
    -- -- The rename can be repeated by using `.`, or by manually calling the rename
    -- -- funciton with the `macrorepeat` parameter.
    --
    -- -- The last lsp rename is repeated and commited without any further confirmation.
    -- require("live-rename").rename({ macrorepeat = true, noconfirm = true })
    --
    -- -- Without `noconfirm` additional actions can be appended to the macro.
    -- require("live-rename").rename({ macrorepeat = true })
}
