local overseer = require('overseer')
return {
    name = 'Make Current C file',
    builder = function(_)
        local path = vim.fn.expand('%:p')
        local dir, file = path:gmatch('(.*)[/\\](.*)')()
        file = string.sub(file, 1, -3) -- remove .c extension

        return {
            cmd = { 'make' },
            args = { file },
            cwd = dir,
        }
    end,
    tags = { overseer.TAG.BUILD },
    priority = 50,
    condition = {
        filetype = { 'c' },
        callback = function()
            -- Disable if already using make/cmake
            local filename = vim.fn.expand('%:p')
            local root_dir = require('lspconfig/util').root_pattern(
                'Makefile',
                'build/Makefile',
                'CMakePresets.json',
                'CTestConfig.cmake',
                'build',
                'cmake'
            )(filename)
            return root_dir == nil
        end,
    },
}
