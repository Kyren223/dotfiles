return {
    'mbbill/undotree',
    keys = { { '<leader>ut', vim.cmd.UndotreeToggle } },
    config = function()
        vim.g.undotree_DiffAutoOpen = false
        vim.g.undotree_DiffpanelHeight = 0
        vim.g.undotree_SetFocusWhenToggle = false
        vim.g.undotree_HelpLine = false
        vim.g.undotree_TreeNodeShape = ''
        vim.g.undotree_TreeVertShape = '│'
        vim.g.undotree_TreeSplitShape = '─┘'
        vim.g.undotree_TreeReturnShape = '─┐'
    end,
}
