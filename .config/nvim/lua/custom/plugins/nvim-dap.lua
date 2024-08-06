return {
    'mfussenegger/nvim-dap',
    dependencies = { 'williamboman/mason.nvim' },
    opts = function()
        local dap = require('dap')

        -- Setup C/C++ dap
        if not dap.adapters['codelldb'] then
            dap.adapters['codelldb'] = {
                type = 'server',
                host = 'localhost',
                port = '${port}',
                executable = {
                    command = 'codelldb',
                    args = {
                        '--port',
                        '${port}',
                    },
                },
            }
        end
        for _, lang in ipairs({ 'c', 'cpp' }) do
            dap.configurations[lang] = {
                {
                    type = 'codelldb',
                    request = 'launch',
                    name = 'Launch file',
                    program = function()
                        if vim.g.dap_codelldb_exe then
                            return vim.fn.getcwd() .. '/' .. vim.g.dap_codelldb_exe
                        end
                        return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
                    end,
                    cwd = '${workspaceFolder}',
                },
                {
                    type = 'codelldb',
                    request = 'attach',
                    name = 'Attach to process',
                    pid = require('dap.utils').pick_process,
                    cwd = '${workspaceFolder}',
                },
            }
        end
    end,
}
