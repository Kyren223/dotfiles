return {
    'rachartier/tiny-inline-diagnostic.nvim',
    event = 'VeryLazy',
    opts = {
        options = {
            -- Throttle the update of the diagnostic when moving cursor, in milliseconds.
            -- You can increase it if you have performance issues.
            -- Or set it to 0 to have better visuals.
            throttle = 0,

            -- The minimum length of the message, otherwise it will be on a new line.
            softwrap = 15,

            -- If multiple diagnostics are under the cursor, display all of them.
            multiple_diag_under_cursor = true,

            --- Enable it if you want to always have message with `after` characters length.
            break_line = {
                enabled = false,
                after = 30,
            },
        },
    },
}
