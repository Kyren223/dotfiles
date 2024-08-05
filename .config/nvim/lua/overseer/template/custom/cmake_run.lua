local overseer = require('overseer')
local root_pattern = require('lspconfig/util').root_pattern('CMakePresets.json', 'CTestConfig.cmake', 'build', 'cmake')
return {
    name = 'Run Cmake Project',
    params = {
        args = {
            optional = true,
            type = 'string',
        },
    },
    builder = function(params)
        local filename = vim.fn.expand('%:p')
        local root_dir = root_pattern(filename)
        local exe = vim.g.overseer_cmake_main_exe

        -- Make sure params.args is a string
        if not params.args or type(params.args) ~= 'string' then
            params.args = ''
        end

        return {
            name = 'Run ' .. exe,
            cmd = './' .. 'Kalc ' .. params.args,
            cwd = root_dir .. '/build',
        }
    end,
    tags = { overseer.TAG.RUN },
    priority = 41,
    condition = {
        callback = function()
            local filename = vim.fn.expand('%:p')
            local root_dir = root_pattern(filename)
            if not root_dir then
                return false, 'Unable to detect root directory of cmake project'
            end

            if not vim.g.overseer_cmake_main_exe then
                return false,
                    'Global "overseer_cmake_main_exe" must be defined. use `vim.g.overseer_cmake_main_exe = "Value"` to define it'
            end

            return true
        end,
    },
}
