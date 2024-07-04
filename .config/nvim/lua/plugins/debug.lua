return {
    'mfussenegger/nvim-dap',
    dependencies = {
        'rcarriga/nvim-dap-ui',
        'nvim-neotest/nvim-nio', -- dependency for nvim-dap-ui
    },
    config = function()
        local dap = require('dap')
        local dapui = require('dapui')

        dap.listeners.before.attach.dapui_config = function()
            dapui.open()
        end
        dap.listeners.before.launch.dapui_config = function()
            dapui.open()
        end
        dap.listeners.before.event_terminated.dapui_config = function()
            dapui.close()
        end
        dap.listeners.before.event_exited.dapui_config = function()
            dapui.close()
        end

        vim.keymap.set('n', '<leader>bp', dap.toggle_breakpoint, { desc = 'Set [B]reak[p]oint (toggle)' })
        vim.keymap.set('n', '<leader>dd', dap.continue, { desc = '[D]ebugger [D]ebug (start)' })
    end,
}
