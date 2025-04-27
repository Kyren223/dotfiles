-- https://github.com/zigtools/zls

return {
    mason = false,
    cmd = { 'zls' },
    filetypes = { 'zig', 'zir' },
    root_markers = { 'zls.json', 'build.zig', '.git' },
    workspace_required = false,
    settings = {
        zls = {
            enable_build_on_save = true,
            build_on_save_args = {},
            enable_argument_placeholders = false,
            warn_style = true,

            inlay_hints_show_variable_type_hints = true,
            inlay_hints_show_struct_literal_field_type = true,
            inlay_hints_show_parameter_name = true,
            inlay_hints_show_builtin = true,
            inlay_hints_hide_redundant_param_names = true,
            inlay_hints_hide_redundant_param_names_last_token = true,
        },
    },
}
