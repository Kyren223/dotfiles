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
    priority = 20,
    condition = {
        filetype = { 'c' },
    },
}
