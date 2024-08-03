return {
    'christoomey/vim-tmux-navigator',
    keys = {
        { '<C-h>', '<cmd>TmuxNavigateLeft<cr>', mode = { 'n', 'i' } },
        { '<C-j>', '<cmd>TmuxNavigateDown<cr>', mode = { 'n', 'i' } },
        { '<C-k>', '<cmd>TmuxNavigateUp<cr>', mode = { 'n', 'i' } },
        { '<C-l>', '<cmd>TmuxNavigateRight<cr>', mode = { 'n', 'i' } },
    },
}
