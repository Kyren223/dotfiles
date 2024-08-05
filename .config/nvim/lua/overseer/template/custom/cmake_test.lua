local overseer = require('overseer')
local root_pattern = require('lspconfig/util').root_pattern('CMakePresets.json', 'CTestConfig.cmake', 'build', 'cmake')
return {
    name = 'Test Cmake Project',
    builder = function(_)
        local filename = vim.fn.expand('%:p')
        local root_dir = root_pattern(filename)

        return {
            name = 'Cmake Tests',
            cmd = 'ctest --output-on-failure',
            cwd = root_dir .. '/build',
        }
    end,
    tags = { overseer.TAG.TEST },
    priority = 42,
    condition = {
        callback = function()
            local filename = vim.fn.expand('%:p')
            local root_dir = root_pattern(filename)
            if not root_dir then
                return false, 'Unable to detect root directory of cmake project'
            end

            return true
        end,
    },
}
