return {
    'rcarriga/nvim-dap-ui',
    dependencies = { 'mfussenegger/nvim-dap', 'nvim-neotest/nvim-nio' },
    event = 'VeryLazy',
    config = function()
        local dap = require('dap')
        local dapui = require('dapui')
        dapui.setup()
        dap.listeners.before.attach.dapui_config = function()
            dapui.open()
            vim.cmd.Hardtime('disable')
        end
        dap.listeners.after.event_initialized['dapui_config'] = function()
            dapui.open()
            vim.cmd.Hardtime('disable')
        end
        dap.listeners.before.event_terminated['dapui_config'] = function()
            dapui.close()
            vim.cmd.Hardtime('enable')
        end
        dap.listeners.before.event_exited['dapui_config'] = function()
            dapui.close()
            vim.cmd.Hardtime('enable')
        end
    end,
}
