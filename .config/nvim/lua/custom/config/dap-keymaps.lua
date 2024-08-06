local keymaps = {
    { 'n', '<leader>dr', '<cmd>DapContinue<cr>', { desc = '[D]ebug [R]esume (or start)' } },
    { 'n', '<leader>dR', '<cmd>DapRestartFrame<cr>', { desc = '[D]ebug [R]estart' } },
    { 'n', '<leader>dt', '<cmd>DapRestartFrame<cr>', { desc = '[D]ebug [R]estart' } },
    { 'n', '<leader>dp', '<cmd>DapToggleBreakpoint<cr>', { desc = '[D]ebug Break[p]oint' } },
    { 'n', 'H', '<cmd>lua require("dap.ui.widgets").hover()<cr>', { desc = '[H]over (debug)' } },
    { 'n', '<leader>si', '<<cmd>DapStepInto<cr>', { desc = '[S]tep [I]nto' } },
    { 'n', '<leader>so', '<<cmd>DapStepOver<cr>', { desc = '[S]tep [O]ver' } },
    { 'n', '<leader>sO', '<<cmd>DapStepOut<cr>', { desc = '[S]tep [O]ut' } },
}

for _, keymap in ipairs(keymaps) do
    local mode = keymap[1]
    local lhs = keymap[2]
    local rhs = keymap[3]
    local opts = keymap[4] or {}
    vim.keymap.set(mode, lhs, rhs, opts)
end
