-- https://github.com/zigtools/zls

return {
    cmd = { 'zls' },
    filetypes = { 'zig', 'zir', 'zon' },
    root_markers = { 'zls.json', 'build.zig', '.git' },
    workspace_required = false,
    settings = {
        zls = {
            enable_build_on_save = true,
            enable_argument_placeholders = false,
            warn_style = true,

            inlay_hints_show_variable_type_hints = true,
            inlay_hints_show_struct_literal_field_type = true,
            inlay_hints_show_parameter_name = false,
            inlay_hints_show_builtin = true,
            inlay_hints_exclude_single_argument = true,
            inlay_hints_hide_redundant_param_names = true,
            inlay_hints_hide_redundant_param_names_last_token = true,
        },
    },
}
