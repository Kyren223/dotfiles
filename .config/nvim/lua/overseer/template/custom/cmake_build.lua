local overseer = require('overseer')
local root_pattern = require('lspconfig/util').root_pattern('CMakePresets.json', 'CTestConfig.cmake', 'build', 'cmake')
return {
    name = 'Build Cmake Project',
    builder = function(_)
        local filename = vim.fn.expand('%:p')
        local root_dir = root_pattern(filename) or vim.fn.getcwd()

        return {
            name = 'Cmake',
            cmd = 'cmake .. && cmake --build .',
            cwd = root_dir .. '/build',
        }
    end,
    tags = { overseer.TAG.BUILD },
    priority = 40,
    condition = {
        callback = function()
            local filename = vim.fn.expand('%:p')
            local root_dir = root_pattern(filename)
            return root_dir ~= nil
        end,
    },
}
